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

"""Rule for creating a multi-architecture static framework for a
Swift module."""

load(
    "@build_bazel_rules_swift//swift:swift.bzl",
    "SwiftInfo",
    "swift_library",
)
load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_static_framework",
)
load(
    "@build_bazel_rules_apple//apple:providers.bzl",
    "AppleBundleInfo",
)
load(":headermap_support.bzl", "headermap_support")
load(":module_map.bzl", "module_map")
load(
    ":common.bzl",
    "DEFAULT_MINIMUM_OS_VERSION",
    "DEFAULT_VISIBILITY",
    "SHARED_COMPILER_OPTIONS",
    "SHARED_SWIFT_COMPILER_OPTIONS",
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

def _swift_static_framework_impl(ctx):
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

_swift_static_framework = rule(
    implementation = _swift_static_framework_impl,
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

def swift_static_framework(
        name,
        srcs,
        copts = [],
        swiftc_inputs = [],
        deps = [],
        avoid_deps = None,
        data = [],
        visibility = DEFAULT_VISIBILITY,
        minimum_os_version = DEFAULT_MINIMUM_OS_VERSION,
        **kwargs):
    """Builds and bundles a Swift static framework for Xcode consumption or third-party distribution.

    This rule in general is very similar to `build_bazel_rules_apple`'s
    `ios_static_framework` rule, with some differences:

    * It supports bundling a swift_library target that depend transitively on
        any other swift_library targets. By default, it will not link any of
        its dependencies into the final framework binary - the same way Xcode
        does when it builds frameworks - which means you can prebuild your
        dependencies as static frameworks for Xcode consumption.
    * It supports header maps out of the box--you don't need to change your
        imports to make your code build with Bazel.
    * It always collects the Swift generated header and bundles a
        `module.modulemap` file.
    * It bundles `swiftmodule` and `swiftdoc` files (`ios_static_framework`
        rule bundles `swiftinterface` instead of `swiftmodule` file).

    Under the hood, this uses an `objc_library` target to wrap a
    `swift_library` target -- so by a sense, it's still a mixed Obj-C and Swift
    target - to make use of `objc_library`'s configuration transition.

    ### Examples

    ```starlark
    load("@rules_apple_line//apple:swift_static_framework.bzl", "swift_static_framework")

    swift_static_framework(
        name = "MyLibrary",
        srcs = glob(["**/*.swift"]),
    )
    ```

    Args:
      name: A unique name for this target. This will be the name of the
          library target that the framework depends on. The framework target
          will be named `${name}Framework`.
      srcs: The list of Swift source files to compile.
      copts: Additional compiler options that should be passed to `swiftc`.
      swiftc_inputs: Additional files that are referenced using `$(rootpath
          ...)` and `$(execpath ...)` in attributes that support location
          expansion (e.g. `copts`).
      swift_deps: Dependencies of the underlying `swift_library` target.
      deps: A list of targets that are dependencies of the target being built.
          Note that, by default, none of these and all of their transitive
          dependencies will be linked into the final binary when building the
          `${name}Framework` target.
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
      visibility: The visibility specifications for this target.
      **kwargs: Additional arguments being passed through.
    """
    swift_srcs = srcs

    module_name = kwargs.get("module_name", name)

    objc_library_name = name
    swift_library_name = name + "_swift"

    objc_deps = [":" + swift_library_name]
    swift_deps = [] + deps

    headermaps = headermap_support(
        name = name,
        module_name = module_name,
        hdrs = [],
        private_hdrs = [],
        deps = deps,
    )
    headermap_deps = [
        headermaps["public_hmap"],
        headermaps["private_hmap"],
        headermaps["private_angled_hmap"],
    ]
    swift_deps += headermap_deps

    headermap_copts = headermaps["headermap_copts"]

    swift_copts = SHARED_SWIFT_COMPILER_OPTIONS + copts
    for copt in headermap_copts:
        swift_copts += [
            "-Xcc",
            copt,
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

    module_map(
        name = name + "Module",
        hdrs = [],
        deps = [":" + swift_library_name],
        module_name = module_name,
        visibility = visibility,
    )
    umbrella_module_map = name + "Module"
    objc_deps += [name + "Module"]

    native.objc_library(
        name = objc_library_name,
        module_map = umbrella_module_map,
        deps = objc_deps,
        data = data,
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

    ios_static_framework(
        name = name + ".intermediate",
        hdrs = [
            ":" + name + ".hdrs",
        ],
        deps = [
            ":" + objc_library_name,
        ],
        avoid_deps = avoid_deps,
        bundle_name = name,
        minimum_os_version = minimum_os_version,
    )

    _swift_static_framework(
        name = name + "Framework",
        framework = name + ".intermediate",
        swift_partial_target = ":" + swift_library_name,
        minimum_os_version = minimum_os_version,
    )
