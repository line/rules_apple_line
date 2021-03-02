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
    "swift_library",
)
load(
    "@build_bazel_rules_apple//apple:ios.bzl",
    "ios_static_framework",
)
load(":defines.bzl", "SWIFT_DEFINES")
load(":headermap_support.bzl", "headermap_support")
load(
    ":common.bzl",
    "DEFAULT_MINIMUM_OS_VERSION",
    "DEFAULT_VISIBILITY",
    "SHARED_COMPILER_OPTIONS",
    "SHARED_SWIFT_COMPILER_OPTIONS",
)

def swift_static_framework(
        name,
        srcs,
        copts = [],
        use_defines = None,
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

    module_name = kwargs.pop("module_name", name)

    swift_library_name = name

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

    if use_defines == None:
        use_defines = native.repository_name() == "@"

    if use_defines:
        swift_defines = SWIFT_DEFINES
    else:
        swift_defines = []

    swift_copts = SHARED_COMPILER_OPTIONS + swift_defines + SHARED_SWIFT_COMPILER_OPTIONS + copts
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
        visibility = visibility,
        deps = swift_deps,
        generated_header_name = module_name + "-Swift.h",
        data = data,
    )

    if avoid_deps == None:
        avoid_deps = deps

    ios_static_framework(
        name = name + "Framework",
        deps = [":" + swift_library_name],
        avoid_deps = avoid_deps,
        bundle_name = module_name,
        minimum_os_version = minimum_os_version,
        visibility = visibility,
    )
