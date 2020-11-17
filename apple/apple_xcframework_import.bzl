"""Experimental implementation of apple_xcframework_import rule."""

# Helper functions '_all_framework_binaries', '_classify_framework_imports',
# '_get_framework_binary_file', '_group_files_by_directory', '_is_swiftmodule'
# were imported from rules_apple at 1d8010912dd803aedc0fc310925b1c88ea64622e.

load(
    "@build_bazel_apple_support//lib:apple_support.bzl",
    "apple_support",
)
load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_dynamic_framework_import",
    "apple_static_framework_import",
)
load(
    "@build_bazel_rules_apple//apple/internal/utils:defines.bzl",
    "defines",
)
load(
    "@bazel_skylib//lib:paths.bzl",
    "paths",
)

def _all_dsym_binaries(frameworks_groups):
    """Returns a list of Files of all imported dSYM binaries."""
    binaries = []
    for framework_dsym_dir, framework_imports in frameworks_groups.items():
        if not framework_dsym_dir.endswith(".framework.dSYM"):
            continue
        binary = _get_dsym_binary_file(
            framework_dsym_dir,
            framework_imports.to_list(),
        )
        if binary != None:
            binaries.append(binary)

    return binaries

def _all_dsym_infoplists(frameworks_groups):
    """Returns a list of Files of all imported dSYM Info.plists."""
    return [
        file
        for files in frameworks_groups.values()
        for file in files.to_list()
        if file.basename.lower() == "info.plist"
    ]

def _all_framework_binaries(frameworks_groups):
    """Returns a list of Files of all imported binaries."""
    binaries = []
    for framework_dir, framework_imports in frameworks_groups.items():
        if not framework_dir.endswith(".framework"):
            continue
        binary = _get_framework_binary_file(
            framework_dir,
            framework_imports.to_list(),
        )
        if binary != None:
            binaries.append(binary)

    return binaries

def _classify_framework_imports(ctx, framework_imports):
    """Classify a list of framework files into bundling, header, or module_map."""

    bundling_imports = []
    header_imports = []
    module_map_imports = []
    for file in framework_imports:
        file_short_path = file.short_path
        if file_short_path.endswith(".h"):
            header_imports.append(file)
            continue
        if file_short_path.endswith(".modulemap"):
            # With the flip of `--incompatible_objc_framework_cleanup`, the
            # `objc_library` implementation in Bazel no longer passes module
            # maps as inputs to the compile actions, so that `@import`
            # statements for user-provided framework no longer work in a
            # sandbox. This trap door allows users to continue using `@import`
            # statements for imported framework by adding module map to
            # header_imports so that they are included in Obj-C compilation but
            # they aren't processed in any way.
            if defines.bool_value(
                ctx,
                "apple.incompatible.objc_framework_propagate_modulemap",
                False,
            ):
                header_imports.append(file)
            module_map_imports.append(file)
            continue
        if "Headers/" in file_short_path:
            # This matches /Headers/ and /PrivateHeaders/
            header_imports.append(file)
            continue
        if _is_swiftmodule(file_short_path):
            # Add Swift's module files to header_imports so that they are
            # correctly included in the build by Bazel but they aren't
            # processed in any way
            header_imports.append(file)
            continue
        if file_short_path.endswith(".swiftdoc"):
            # Ignore swiftdoc files, they don't matter in the build, only for
            # IDEs
            continue
        bundling_imports.append(file)

    return bundling_imports, header_imports, module_map_imports

def _get_dsym_binary_file(framework_dir, framework_imports):
    """Returns the File that is the framework dSYM's binary."""
    framework_name = paths.split_extension(paths.basename(framework_dir))[0]
    dsym_binary_path = paths.join(framework_dir, framework_name)
    for framework_import in framework_imports:
        if paths.basename(framework_import.path).lower() != "info.plist":
            return framework_import

    return None

def _get_framework_binary_file(framework_dir, framework_imports):
    """Returns the File that is the framework's binary."""
    framework_name = paths.split_extension(paths.basename(framework_dir))[0]
    framework_path = paths.join(framework_dir, framework_name)
    for framework_import in framework_imports:
        if framework_import.path == framework_path:
            return framework_import

    return None

def _group_files_by_directory(files, extensions, attr):
    """Groups files based on their containing directories.
    This function examines each file in |files| and looks for a containing
    directory with the given extension. It then returns a dictionary that maps
    the directory names to the files they contain.
    For example, if you had the following files:
      - some/path/foo.images/bar.png
      - some/path/foo.images/baz.png
      - some/path/quux.images/blorp.png
    Then passing the extension "images" to this function would return:
      {
          "some/path/foo.images": depset([
              "some/path/foo.images/bar.png",
              "some/path/foo.images/baz.png"
          ]),
          "some/path/quux.images": depset([
              "some/path/quux.images/blorp.png"
          ])
      }
    If an input file does not have a containing directory with the given
    extension, the build will fail.
    Args:
      files: An iterable of File objects.
      extensions: The list of extensions of the containing directories to
          return. The extensions should NOT include the leading dot.
      attr: Unused now.
    Returns:
      A dictionary whose keys are directories with the given extension and
      their values are the sets of files within them.
    """
    grouped_files = {}

    ext_info = [(".%s" % e, len(e) + 1) for e in extensions]

    for f in files:
        path = f.path

        for search_string, search_string_len in ext_info:
            # Make sure the matched string either has a '/' after it, or occurs
            # at the end of the string (this lets us match directories without
            # requiring a trailing slash but prevents matching something like
            # '.xcdatamodeld' when passing 'xcdatamodel'). The ordering of
            # these checks is also important, to ensure that we can handle
            # cases that occur when working with common Apple file structures,
            # like passing 'xcdatamodel' and correctly parsing paths matching
            # 'foo.xcdatamodeld/bar.xcdatamodel/...'.
            after_index = -1
            index_with_slash = path.find(search_string + "/")
            if index_with_slash != -1:
                after_index = index_with_slash + search_string_len
            else:
                index_without_slash = path.find(search_string)
                after_index = index_without_slash + search_string_len

                # If the search string wasn't at the end of the string, it must
                # have a non-slash character after it (because we already
                # checked the slash case above), so eliminate it.
                if after_index != len(path):
                    after_index = -1

            if after_index != -1:
                container = path[:after_index]
                contained_files = grouped_files.setdefault(
                    container,
                    default = [],
                )
                contained_files.append(f)

                # No need to check other extensions
                break

    return {k: depset(v) for k, v in grouped_files.items()}

def _is_swiftmodule(path):
    """Predicate to identify Swift modules/interfaces."""
    return path.endswith((".swiftmodule", ".swiftinterface"))

def _merge_dsym_imports_impl(ctx):
    xcframework_imports = ctx.files.xcframework_imports
    framework_groups = _group_files_by_directory(
        xcframework_imports,
        ["framework.dSYM"],
        attr = "xcframework_imports",
    )
    if not framework_groups:
        return []
    all_dsym_binaries = _all_dsym_binaries(framework_groups)

    first_dsym_key = framework_groups.keys()[0]

    outputs = []

    # e.g. MyFramework.framework.dSYM
    framework_dsym_dir = paths.basename(first_dsym_key)

    # e.g. MyFramework
    output_binary_name = framework_dsym_dir.rstrip(".framework.dSYM")

    # Create a universal dSYM binary
    output_dsym_binary = ctx.actions.declare_file(
        framework_dsym_dir + "/Contents/Resources/DWARF/" + output_binary_name,
    )
    outputs.append(output_dsym_binary)

    args = ctx.actions.args()
    args.add("lipo")
    args.add("-create")
    args.add("-output", output_dsym_binary)
    args.add_all(all_dsym_binaries)

    apple_support.run(
        actions = ctx.actions,
        executable = "/usr/bin/xcrun",
        inputs = all_dsym_binaries,
        outputs = [output_dsym_binary],
        arguments = [args],
        mnemonic = "XcframeworkCombineDsymBinaries",
        apple_fragment = ctx.fragments.apple,
        xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig],
    )

    # Merge dSYM Info.plists
    input_infoplists = _all_dsym_infoplists(framework_groups)
    output_infoplist = ctx.actions.declare_file(
        framework_dsym_dir + "/Contents/Info.plist",
    )
    outputs.append(output_infoplist)

    plist_merger_args = ctx.actions.args()
    plist_merger_args.add_all(input_infoplists, before_each = "--input")
    plist_merger_args.add("--output", output_infoplist)
    plist_merger_args.add("--output_format", "binary1")

    ctx.actions.run(
        executable = ctx.executable._plist_merger,
        inputs = input_infoplists,
        outputs = [output_infoplist],
        arguments = [plist_merger_args],
        mnemonic = "XcframeworkMergeDsymInfoPlists",
    )

    return [
        DefaultInfo(
            files = depset(outputs),
        ),
    ]

def _merge_framework_imports_impl(ctx):
    xcframework_imports = ctx.files.xcframework_imports
    framework_groups = _group_files_by_directory(
        xcframework_imports,
        ["framework"],
        attr = "xcframework_imports",
    )
    all_framework_binaries = _all_framework_binaries(framework_groups)

    first_framework_key = framework_groups.keys()[0]
    framework_imports = framework_groups[first_framework_key]

    outputs = []

    bundling_imports, header_imports, module_map_imports = (
        _classify_framework_imports(ctx, framework_imports.to_list())
    )

    # e.g. MyFramework.framework
    framework_dir_basename = paths.basename(first_framework_key)

    # e.g. MyFramework
    framework_name = paths.split_extension(framework_dir_basename)[0]

    # Symlink headers and module maps. Here we're assuming headers and module
    # maps are the same for different platforms, which may not always be true.
    for file in header_imports + module_map_imports:
        symlinked_file = ctx.actions.declare_file(
            "/".join([
                framework_dir_basename,
                paths.basename(paths.dirname(file.path)),
                paths.basename(file.path),
            ]),
        )
        ctx.actions.symlink(
            output = symlinked_file,
            target_file = file,
        )
        outputs.append(symlinked_file)

    # Create a universal binary.
    # This assumes that the input binaries don't contain the same arch built
    # for different platforms, which can be wrong, for example, when both an
    # arm64 slice for iOS simulator and an arm64 slice for iPhone are both
    # provided.
    output_binary = ctx.actions.declare_file(
        framework_dir_basename + "/" + framework_name,
    )
    outputs.append(output_binary)

    args = ctx.actions.args()
    args.add("lipo")
    args.add("-create")
    args.add("-output", output_binary)
    args.add_all(all_framework_binaries)

    apple_support.run(
        actions = ctx.actions,
        executable = "/usr/bin/xcrun",
        inputs = all_framework_binaries,
        outputs = [output_binary],
        arguments = [args],
        mnemonic = "XcframeworkCombineBinaries",
        apple_fragment = ctx.fragments.apple,
        xcode_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig],
    )

    return [
        DefaultInfo(
            files = depset(outputs),
        ),
    ]

_merge_dsym_imports = rule(
    attrs = {
        "xcframework_imports": attr.label_list(
            allow_empty = False,
            allow_files = True,
        ),
        "_plist_merger": attr.label(
            default = "//tools/plist_merger",
            cfg = "exec",
            executable = True,
            allow_files = True,
        ),
        "_xcode_config": attr.label(default = configuration_field(
            fragment = "apple",
            name = "xcode_config_label",
        )),
    },
    fragments = ["apple"],
    implementation = _merge_dsym_imports_impl,
)

_merge_framework_imports = rule(
    attrs = {
        "xcframework_imports": attr.label_list(
            allow_empty = False,
            allow_files = True,
        ),
        "_xcode_config": attr.label(default = configuration_field(
            fragment = "apple",
            name = "xcode_config_label",
        )),
    },
    fragments = ["apple"],
    implementation = _merge_framework_imports_impl,
)

def apple_xcframework_import(**kwargs):
    """Encapsulates an already-built xcframework.

    It is defined by a list of files in exactly one `.xcframework` directory.
    `apple_xcframework_import` targets need to be added to library targets
    through the `deps` attribute.

    ### Examples

    ```starlark
    load("@rules_apple_line//apple:apple_xcframework_import.bzl", "apple_xcframework_import")

    apple_xcframework_import(
        name = "ThirdParty",
        framework_type = "dynamic",
        xcframework_imports = glob([
            "ThirdParty.xcframework/**",
        ]),
    )
    ```
    """

    name = kwargs.pop("name")
    xcframework_imports = kwargs.pop("xcframework_imports")

    framework_preprocessed_target = name + "_framework"

    _merge_framework_imports(
        name = framework_preprocessed_target,
        xcframework_imports = xcframework_imports,
    )

    dsym_preprocessed_target = name + "_framework_dSYM"

    _merge_dsym_imports(
        name = dsym_preprocessed_target,
        xcframework_imports = xcframework_imports,
    )

    framework_type = kwargs.pop("framework_type")

    if framework_type == "dynamic":
        apple_dynamic_framework_import(
            name = name,
            framework_imports = [":" + framework_preprocessed_target],
            dsym_imports = [":" + dsym_preprocessed_target],
            **kwargs
        )
    elif framework_type == "static":
        apple_static_framework_import(
            name = name,
            framework_imports = [":" + framework_preprocessed_target],
            **kwargs
        )
    else:
        fail("Expected framework_type to be one of 'dynamic' and 'static'" +
             "but got '{}'".format(framework_type))
