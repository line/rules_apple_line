# Copyright 2020 LINE Corporation
#
# LINE Corporation licenses this file to you under the Apache License,
# version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at:
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

"""Rule for creating a multi-architecture static framework for a mixed
Objective-C and Swift module."""

load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "SwiftInfo",
    "swift_library",
)
load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    _ios_static_framework = "ios_static_framework",
)
load(
    "@build_bazel_rules_apple//apple:providers.bzl",
    "AppleBundleInfo",
)
load("@bazel_skylib//lib:paths.bzl", "paths")
load(":headermap_support.bzl", "headermap_support")
load(":module_map.bzl", "module_map")
load(
    ":common.bzl",
    "DEFAULT_MINIMUM_OS_VERSION",
    "DEFAULT_VISIBILITY",
    "HEADERS_FILE_TYPES",
    "OBJC_FILE_TYPES",
    "SHARED_OBJC_COMPILER_OPTIONS",
    "SHARED_SWIFT_COMPILER_OPTIONS",
    "SWIFT_FILE_TYPES",
)

_PLATFORM_TO_SWIFTMODULE = {
    "ios_armv7": "arm",
    "ios_arm64": "arm64",
    "ios_i386": "i386",
    "ios_x86_64": "x86_64",
}

def _module_zipper_arg(framework, module_name, cpu, file):
    return "{framework}/Modules/{module_name}.swiftmodule/{cpu}.{ext}={file_path}".format(
        framework = framework,
        module_name = module_name,
        cpu = cpu,
        ext = file.extension,
        file_path = file.path,
    )

def _objc_headers_impl(ctx):
    # Get all the Obj-C headers
    headers = []
    for dep in ctx.attr.deps:
        objc_headers = dep[apple_common.Objc].header.to_list()
        for hdr in objc_headers:
            if hdr.owner == dep.label:
                headers.append(hdr)
    return [
        DefaultInfo(
            files = depset(headers),
        ),
    ]

_objc_headers = rule(
    _objc_headers_impl,
    attrs = {
        "deps": attr.label_list(
            providers = [SwiftInfo],
        ),
    },
)

def _mixed_static_framework_impl(ctx):
    bundle_info = ctx.attr.framework[AppleBundleInfo]
    framework_name = bundle_info.bundle_name + bundle_info.bundle_extension
    new_framework = ctx.actions.declare_file(ctx.label.name + ".zip")
    inputs = [
        ctx.file.framework,
    ]
    zipper_args = []

    # Get the `swiftdoc` and `swiftmodule` files for each architecture.
    for arch, target in ctx.split_attr.swift_partial_target.items():
        cpu = _PLATFORM_TO_SWIFTMODULE[arch]
        if not cpu:
            continue

        swift_info = target[SwiftInfo]
        swiftdoc = swift_info.direct_swiftdocs[0]
        swiftmodule = swift_info.direct_swiftmodules[0]
        inputs.extend([swiftmodule, swiftdoc])
        zipper_args.extend([
            _module_zipper_arg(framework_name, swift_info.module_name, cpu, swiftmodule),
            _module_zipper_arg(framework_name, swift_info.module_name, cpu, swiftdoc),
        ])

    command = """
        {zipper} x {framework}
        {zipper} c {new_framework} $(find {framework_name} -type f) $@
        rm -rf {framework}
    """.format(
        framework = ctx.file.framework.path,
        framework_name = framework_name,
        new_framework = new_framework.path,
        zipper = ctx.executable._zipper.path,
    )

    ctx.actions.run_shell(
        inputs = inputs,
        outputs = [new_framework],
        mnemonic = "BundleStaticFramework",
        progress_message = "Processing and bundling {}".format(framework_name),
        command = command,
        arguments = zipper_args,
        tools = [
            ctx.executable._zipper,
        ],
    )

    return [
        DefaultInfo(
            files = depset([new_framework]),
        ),
    ]

_mixed_static_framework = rule(
    implementation = _mixed_static_framework_impl,
    attrs = dict(
        framework = attr.label(
            providers = [AppleBundleInfo],
            allow_single_file = True,
        ),
        swift_partial_target = attr.label(
            mandatory = True,
            providers = [SwiftInfo],
            cfg = apple_common.multi_arch_split,
        ),
        minimum_os_version = attr.string(
            mandatory = True,
        ),
        platform_type = attr.string(
            default = str(apple_common.platform_type.ios),
        ),
        _zipper = attr.label(
            default = "@bazel_tools//tools/zip:zipper",
            cfg = "host",
            executable = True,
        ),
    ),
    fragments = ["apple"],
    outputs = {
        "output_file": "%{name}.zip",
    },
)

def mixed_static_framework(
        name,
        srcs,
        non_arc_srcs = [],
        hdrs = [],
        textual_hdrs = [],
        enable_modules = True,
        includes = [],
        copts = [],
        objc_copts = [],
        swift_copts = [],
        swiftc_inputs = [],
        objc_deps = [],
        swift_deps = [],
        avoid_deps = None,
        deps = [],
        data = [],
        umbrella_header = None,
        visibility = DEFAULT_VISIBILITY,
        minimum_os_version = DEFAULT_MINIMUM_OS_VERSION,
        **kwargs):
    """Builds and bundles a static framework for Xcode consumption or third-party distribution.

    This supports Swift only targets and mixed language targets. If your target
    only contains Objective-C source code, use `objc_static_framework` rule
    instead.

    This rule in general is very similar to `build_bazel_rules_apple`'s
    `ios_static_framework` rule, with some differences:

    * It supports Swift as well as mixed Objective-C and Swift targets.
    * It supports bundling a swift_library target that depend transitively on
        any other swift_library targets. By default, it will not link any of
        its dependencies into the final framework binary - the same way Xcode
        does when it builds frameworks - which means you can prebuild your
        dependencies as static frameworks for Xcode consumption.
    * It supports header maps out of the box--you don't need to change your
        imports to make your code build with Bazel.
    * It always collects the Swift generated header and bundles a
        `module.modulemap` file. For a mixed language target, the module map
        file is an extended module map.
    * It bundles `swiftmodule` and `swiftdoc` files (`ios_static_framework`
        rule bundles `swiftinterface` instead of `swiftmodule` file).

    This rule uses the native `objc_library` rule and `rules_swift`'s
    `swift_library` in its implementation. Even if you're not building a static
    framework for Xcode consumption or third-party distribution, this can still
    be used as a convenient way to declare a library target that compiles mixed
    Objective-C and Swift source code.

    The macro contains 3 underlying rules--given `name` is `Greet`:

    * `Greet_swift`: a `swift_library` target. This target has private
        visibility by default, hence it can't be a dependency of any other
        target. It should not be used directly.
    * `GreetModule`: a `module_map` target. This has the same visibility as
        `Greet`. The common use-case is using it in an `objc_library`'s
        `copts` attribute to import the generated module map file (e.g.
        `-fmodule-map-file=$(execpath //path/to/package:GreetModule)`). This
        will be done automatically if the dependent target is also a
        `mixed_static_framework` target.
    * `Greet`: an `objc_library` target. This is the wrapper library target.
        This can be depended on any `objc_library` or `swift_library` target.

    ### Examples

    ```starlark
    load("@com_linecorp_bazel_rules_apple//apple:mixed_static_framework.bzl", "mixed_static_framework")

    mixed_static_framework(
        name = "Mixed",
        srcs = glob([
            "*.m",
            "*.swift",
        ]),
        hdrs = glob(["*.h"]),
    )
    ```

    Args:
      name: A unique name for this target. This will be the name of the
          library target that the framework depends on. The framework target
          will be named `${name}Framework`.
      srcs: The list of Objective-C and Swift source files to compile.
      non_arc_srcs: The Objective-C source files to compile that do not use
          ARC. Provide both `srcs` and `non_arc_srcs` explicitly if both kinds
          of source files should be included.
      hdrs: The list of C, C++, Objective-C, and Objective-C++ header files
          published by this library to be included by sources in dependent
          rules. These headers describe the public interface for the library
          and will be made available for inclusion by sources in this rule or
          in dependent rules. Headers not meant to be included by a client of
          this library should be listed in the `srcs` attribute instead.  These
          will be compiled separately from the source if modules are enabled.
      textual_hdrs: The list of C, C++, Objective-C, and Objective-C++ files
          that are included as headers by source files in this rule or by users
          of this library. Unlike `hdrs`, these will not be compiled separately
          from the sources.
      enable_modules: Enables clang module support (via `-fmodules`).

          Note: This is `True` by default. Changing this to `False` might no
          longer work. This attribute is here because there are still targets
          which are referencing to it.
      includes: List of header search paths to add to this target and all
          depending targets. Unlike `copts`, these flags are added for this
          rule and every rule that depends on it. (Note: not the rules it
          depends upon!) Be very careful, since this may have far-reaching
          effects. When in doubt, add "-iquote" flags to `copts` instead.

          Usage of this is rarely necessary because all headers will be visible
          to their depended targets with the help of header maps.
      copts: Additional compiler options that should be passed to `clang` and
          `swiftc`.
      objc_copts: Additional compiler options that should be passed to `clang`.
      swift_copts: Additional compiler options that should be passed to `swiftc`.
      swiftc_inputs: Additional files that are referenced using `$(rootpath
          ...)` and `$(execpath ...)` in attributes that support location
          expansion (e.g. `copts`).
      objc_deps: Dependencies of the underlying `objc_library` target.
      swift_deps: Dependencies of the underlying `swift_library` target.
      deps: Dependencies of the both `objc_library` and `swift_library` targets.
      avoid_deps: A list of `objc_library` and `swift_library` targets on which
          this framework depends in order to compile, but the transitive
          closure of which will not be linked into the framework's binary. By
          default this is the same as `deps`, that is none of the
          depependencies will be linked into the framework's binary. For
          example, providing an empty list (`[]`) here will result in a fully
          static link binary.
      data: The list of files needed by this rule at runtime. These will be
          bundled to the top level directory of the bundling target (`.app` or
          `.framework`).
      umbrella_header: An optional single `.h` file to use as the umbrella
          header for this framework. Usually, this header will have the same name
          as this target, so that clients can load the header using the #import
          `<MyFramework/MyFramework.h>` format. If this attribute is not specified
          (the common use case), an umbrella header will be generated under the
          same name as this target.
      visibility: The visibility specifications for this target.
      **kwargs: Additional arguments being passed through.
    """
    swift_srcs = []
    objc_srcs = []
    private_hdrs = []
    for x in srcs:
        _, extension = paths.split_extension(x)
        if extension in SWIFT_FILE_TYPES:
            swift_srcs.append(x)
        elif extension in OBJC_FILE_TYPES:
            objc_srcs.append(x)
            if extension in HEADERS_FILE_TYPES:
                private_hdrs.append(x)

    module_name = kwargs.get("module_name", name)

    objc_library_name = name
    swift_library_name = name + "_swift"

    objc_deps = objc_deps + deps
    swift_deps = swift_deps + deps

    headermaps = headermap_support(
        name = name,
        module_name = module_name,
        hdrs = hdrs,
        private_hdrs = private_hdrs,
        deps = deps,
    )
    headermap_deps = [
        headermaps["public_hmap"],
        headermaps["private_hmap"],
        headermaps["private_angled_hmap"],
    ]
    objc_deps += headermap_deps
    swift_deps += headermap_deps

    headermap_copts = headermaps["headermap_copts"]

    swift_copts = SHARED_SWIFT_COMPILER_OPTIONS + swift_copts + [
        "-Xfrontend",
        "-enable-objc-interop",
        "-import-underlying-module",
    ]
    for copt in headermap_copts:
        swift_copts += [
            "-Xcc",
            copt,
        ]

    objc_deps = objc_deps + [":" + swift_library_name]

    # Add Obj-C includes to Swift header search paths
    repository_name = native.repository_name()
    for x in includes:
        include = x if repository_name == "@" else "external/" + repository_name.lstrip("@") + "/" + x
        swift_copts += [
            "-Xcc",
            "-I{}".format(include),
        ]

    # Generate module map for the underlying module
    module_map(
        name = name + "_objc_module",
        hdrs = hdrs,
        textual_hdrs = textual_hdrs,
        module_name = module_name,
    )

    objc_module_map = ":" + name + "_objc_module"
    swiftc_inputs = swiftc_inputs + hdrs + textual_hdrs + private_hdrs + [objc_module_map]

    swift_copts += [
        "-Xcc",
        "-fmodule-map-file=$(execpath {})".format(objc_module_map),
    ]

    swift_library(
        name = swift_library_name,
        srcs = swift_srcs,
        swiftc_inputs = swiftc_inputs,
        copts = swift_copts,
        module_name = module_name,
        visibility = ["//visibility:private"],
        features = [
            "swift.no_generated_module_map",
        ],
        deps = swift_deps,
        generated_header_name = module_name + "-Swift.h",
    )

    objc_copts = SHARED_OBJC_COMPILER_OPTIONS + objc_copts + headermap_copts

    # Modules is not enabled if a custom module map is present even with
    # `enable_modules` set to `True`. This forcibly enables it.
    # See https://github.com/bazelbuild/bazel/blob/18d01e7f6d8a3f5b4b4487e9d61a6d4d0f74f33a/src/main/java/com/google/devtools/build/lib/rules/objc/CompilationSupport.java#L1280
    if enable_modules:
        objc_copts += ["-fmodules"]

    # The extended module map for mixed language modules can't have the name
    # "module.modulemap", otherwise it would cause duplicate definition errors.
    module_map(
        name = name + "Module",
        hdrs = hdrs,
        deps = [":" + swift_library_name],
        module_name = module_name,
        visibility = visibility,
    )
    umbrella_module_map = name + "Module"
    objc_deps += [name + "Module"]

    # TODO: Extract module deps to a separate attribute, because iterating
    # through `deps` prevents the use of `select`.
    for dep in deps:
        if dep.startswith(":"):
            continue
        if dep.startswith("@//"):
            continue
        label = Label(dep)
        dep_name = Label("@" + label.workspace_name + "//" + label.package + ":" + label.name + "Module")
        objc_copts += ["-fmodule-map-file=$(execpath {})".format(dep_name)]
        objc_deps += [dep_name]

    native.objc_library(
        name = objc_library_name,
        module_map = umbrella_module_map,
        enable_modules = enable_modules,
        includes = includes,
        srcs = objc_srcs,
        non_arc_srcs = non_arc_srcs,
        hdrs = hdrs,
        textual_hdrs = textual_hdrs,
        copts = objc_copts,
        deps = objc_deps,
        data = data,
        pch = kwargs.get("pch", None),
        sdk_frameworks = kwargs.get("sdk_frameworks", []),
        visibility = visibility,
    )

    _objc_headers(
        name = name + ".hdrs",
        deps = [
            ":" + swift_library_name,
        ],
    )

    if avoid_deps == None:
        avoid_deps = deps

    _ios_static_framework(
        name = name + ".intermediate",
        hdrs = hdrs + textual_hdrs + [
            ":" + name + ".hdrs",
        ],
        deps = [
            ":" + objc_library_name,
        ],
        avoid_deps = avoid_deps,
        bundle_name = name,
        minimum_os_version = minimum_os_version,
        umbrella_header = umbrella_header,
    )

    _mixed_static_framework(
        name = name + "Framework",
        framework = name + ".intermediate",
        swift_partial_target = ":" + swift_library_name,
        minimum_os_version = minimum_os_version,
    )
