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

"""Bazel rule for creating a multi-architecture static framework for an Objective-C module."""

load("@build_bazel_rules_apple//apple:ios.bzl", "ios_static_framework")
load("@bazel_skylib//lib:paths.bzl", "paths")
load(":headermap_support.bzl", "headermap_support")
load(":module_map.bzl", "module_map")
load(":objc_module_map_config.bzl", "objc_module_map_config")
load(":unique_symbol_file.bzl", "unique_symbol_file")
load(
    ":common.bzl",
    "DEFAULT_MINIMUM_OS_VERSION",
    "DEFAULT_VISIBILITY",
    "HEADERS_FILE_TYPES",
    "SHARED_OBJC_COMPILER_OPTIONS",
)

def objc_static_framework(
        name,
        srcs = [],
        non_arc_srcs = [],
        hdrs = [],
        archives = [],
        deps = [],
        avoid_deps = None,
        data = [],
        module_name = None,
        textual_hdrs = [],
        includes = [],
        testonly = False,
        enable_modules = False,
        minimum_os_version = DEFAULT_MINIMUM_OS_VERSION,
        pch = None,
        visibility = DEFAULT_VISIBILITY,
        umbrella_header = None,
        **kwargs):
    """Builds and bundles a Objective-C static framework for Xcode consumption or third-party distribution.

    This rule in general is very similar to `build_bazel_rules_apple`'s
    `ios_static_framework` rule, with support for modules and header maps out
    of the box--which means you don't need to change your imports to make your
    code build with Bazel. Note that, unlike `build_bazel_rules_apple`'s
    `ios_static_framework`, by default, it will not link any of its
    dependencies into the final framework binary - the same way Xcode does when
    it builds frameworks.

    Args:
      name: A unique name for this target. This will be the name of the
          `objc_library` target that the framework depends on. The framework
          target will be named `${name}Framework`.
      srcs: The Objective-C source files to compile.
      hdrs: The list of C, C++, Objective-C, and Objective-C++ header files
          published by this library to be included by sources in dependent
          rules.  These headers describe the public interface for the library
          and will be made available for inclusion by sources in this rule or
          in dependent rules. Headers not meant to be included by a client of
          this library should be listed in the `srcs` attribute instead.  These
          will be compiled separately from the source if modules are enabled.
      non_arc_srcs: The Objective-C source files to compile that do not use
          ARC. Provide both `srcs` and `non_arc_srcs` explicitly if both kinds
          of source files should be included.
      pch: Header file to prepend to every source file being compiled (both arc
          and non-arc). Use of pch files is actively discouraged in BUILD files,
          and this should be considered deprecated. Since pch files are not
          actually precompiled this is not a build-speed enhancement, and instead
          is just a global dependency. From a build efficiency point of view you
          are actually better including what you need directly in your sources
          where you need it.
      textual_hdrs: The list of C, C++, Objective-C, and Objective-C++ files
          that are included as headers by source files in this rule or by users
          of this library. Unlike `hdrs`, these will not be compiled separately
          from the sources.
      includes: List of header search paths to add to this target and all
          depending targets. Unlike `copts`, these flags are added for this
          rule and every rule that depends on it. (Note: not the rules it
          depends upon!) Be very careful, since this may have far-reaching
          effects. When in doubt, add "-iquote" flags to `copts` instead.
      archives: The list of `.a` files provided to Objective-C targets that
          depend on this target.
      enable_modules: Enables clang module support (via `-fmodules`). Setting
          this to `True` will allow you to @import system headers and other
          targets).
      umbrella_header: An optional single `.h` file to use as the umbrella
          header for this framework. Usually, this header will have the same name
          as this target, so that clients can load the header using the #import
          <MyFramework/MyFramework.h> format. If this attribute is not specified
          (the common use case), an umbrella header will be generated under the
          same name as this target.
      deps: Dependencies of the `objc_library` target being compiled.
      avoid_deps: A list of `objc_library` and `swift_library` targets on which
          this framework depends in order to compile, but you don't want to link to
          the framework binary. Defaults to `deps` if not specified.
      data: The list of files needed by this rule at runtime. These will be
          bundled to the top level directory of the bundling target (`.app` or
          `.framework`).
      copts: Additional compiler options that should be passed to `clang`.
      module_name: The name of the module being built. If not
          provided, the `name` is used.
      minimum_os_version: The minimum OS version supported by the framework.
      testonly: If `True`, only testonly targets (such as tests) can depend
          on the `objc_library` target. The default is `False`.
      visibility: The visibility specifications for this target.
      **kwargs: Additional arguments being passed through to the underlying
          `objc_library` rule.
    """

    module_name = module_name or name

    if avoid_deps == None:
        avoid_deps = deps

    private_hdrs = []
    for x in srcs:
        _, extension = paths.split_extension(x)
        if extension in HEADERS_FILE_TYPES:
            private_hdrs.append(x)

    module_map_name = name + "Module"
    module_map(
        name = name + "Module",
        hdrs = hdrs,
        module_name = module_name,
        visibility = visibility,
    )

    copts = SHARED_OBJC_COMPILER_OPTIONS + kwargs.get("copts", [])

    # Prior to 2.0.0, Bazel implicitly includes root path (i.e. `bazel-line-ios`)
    # in the C family compilation command, but not anymore since 2.0.0 it seemed.
    copts += [
        "-iquote",
        ".",
    ]

    # Modules is not enabled if a custom module map is present even with
    # `enable_modules` set to `True`. This forcibly enables it.
    # See https://github.com/bazelbuild/bazel/blob/18d01e7f6d8a3f5b4b4487e9d61a6d4d0f74f33a/src/main/java/com/google/devtools/build/lib/rules/objc/CompilationSupport.java#L1280
    if enable_modules:
        copts += ["-fmodules"]

    headermaps = headermap_support(
        name = name,
        module_name = module_name,
        hdrs = hdrs + textual_hdrs,
        private_hdrs = private_hdrs,
        deps = deps,
    )
    headermap_deps = [
        headermaps["public_hmap"],
        headermaps["private_hmap"],
        headermaps["private_angled_hmap"],
    ]
    objc_deps = deps + headermap_deps
    copts += headermaps["headermap_copts"]

    if archives:
        native.objc_import(
            name = name + "Import",
            hdrs = hdrs,
            archives = archives,
            sdk_dylibs = kwargs.get("sdk_dylibs", []),
            sdk_frameworks = kwargs.get("sdk_frameworks", []),
            includes = includes,
            testonly = testonly,
        )
        objc_deps += [":" + name + "Import"]
        avoid_deps = []

    # objc_library needs at least a source file
    if not srcs:
        unique_symbol_name = name + "UniqueSymbol"
        unique_symbol_file(
            name = unique_symbol_name,
            out = name + "UniqueSymbol.m",
        )
        srcs = [":{}".format(unique_symbol_name)]

    objc_module_map_config_name = name + "_module_maps"
    objc_module_map_config(
        name = objc_module_map_config_name,
        deps = deps,
        out = name + "_module_map_config.cfg",
    )
    objc_deps += [":" + objc_module_map_config_name]
    if deps:
        copts += [
            "--config",
            "$(execpath {})".format(":" + objc_module_map_config_name),
        ]

    native.objc_library(
        name = name,
        module_map = module_map_name,
        hdrs = hdrs + [
            # These aren't headers but here is the only place to declare these
            # files as the inputs because objc_library doesn't have an attribute
            # to declare custom inputs.
            ":" + objc_module_map_config_name,
            ":" + module_map_name,
        ],
        srcs = srcs,
        non_arc_srcs = non_arc_srcs,
        pch = pch,
        includes = includes,
        enable_modules = enable_modules,
        testonly = testonly,
        copts = copts,
        defines = kwargs.get("defines", []),
        visibility = visibility,
        deps = objc_deps,
        data = data,
        sdk_dylibs = kwargs.get("sdk_dylibs", []),
        sdk_frameworks = kwargs.get("sdk_frameworks", []),
        textual_hdrs = kwargs.get("textual_hdrs", []),
    )

    ios_static_framework(
        name = name + "Framework",
        avoid_deps = avoid_deps,
        bundle_name = module_name,
        hdrs = hdrs + textual_hdrs,
        testonly = testonly,
        minimum_os_version = minimum_os_version,
        visibility = visibility,
        deps = [":" + name],
        umbrella_header = umbrella_header,
    )
