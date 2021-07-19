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

"""Metal library implementation."""

load("@build_bazel_apple_support//lib:apple_support.bzl", "apple_support")
load(
    "@build_bazel_rules_apple//apple/internal:platform_support.bzl",
    "platform_support",
)
load("@bazel_skylib//lib:dicts.bzl", "dicts")
load("@bazel_skylib//lib:paths.bzl", "paths")
load(":common.bzl", "METAL_FILE_TYPES")
load("@build_bazel_rules_apple//apple/internal:resources.bzl", "resources")

def _metal_apple_target_triple(platform_prerequisites):
    """Returns a Metal target triple string for an Apple platform.
    Args:
        ctx: The compilation context.
    Returns:
        A target triple string describing the platform.
    """
    target_os_version = platform_prerequisites.minimum_os

    platform = platform_prerequisites.platform
    platform_string = platform_prerequisites.platform_type
    if platform_string == "macos":
        platform_string = "macosx"

    environment = "" if platform.is_device else "-simulator"

    return "air64-apple-{platform}{version}{environment}".format(
        environment = environment,
        platform = platform_string,
        version = target_os_version,
    )

def _metal_library_impl(ctx):
    air_files = []
    includes_input = []

    # Compile each .metal file into a single .air file
    platform_prerequisites = platform_support.platform_prerequisites(
        apple_fragment = ctx.fragments.apple,
        config_vars = ctx.var,
        device_families = None,
        disabled_features = ctx.disabled_features,
        explicit_minimum_os = None,
        features = ctx.features,
        objc_fragment = None,
        platform_type_string = str(ctx.fragments.apple.single_arch_platform.platform_type),
        uses_swift = False,
        xcode_path_wrapper = ctx.executable._xcode_path_wrapper,
        xcode_version_config = ctx.attr._xcode_config[apple_common.XcodeVersionConfig],
    )
    target = _metal_apple_target_triple(platform_prerequisites)
    
    for include_path in ctx.attr.includes:
        includes_input.append("-I{}".format(include_path))
    
    for input_metal in ctx.files.srcs:
        air_file = ctx.actions.declare_file(
            paths.replace_extension(input_metal.basename, ".air"),
        )
        air_files.append(air_file)

        args = [
            "metal",
            "-c",
            "-target",
            target,
            "-ffast-math"
        ]

        args = args + includes_input
        args = args + ["-o",
            air_file.path,
            input_metal.path,
        ]

        apple_support.run(
            ctx,
            executable = "/usr/bin/xcrun",
            inputs = [input_metal] + ctx.files.hdrs,
            outputs = [air_file],
            arguments = args,
            mnemonic = "MetalCompile",
        )

    # Compile .air files into a single .metallib file, which stores the Metal library.
    output_metallib = ctx.outputs.out

    args = [
        "metallib",
        "-o",
        output_metallib.path,
    ] + [
        air_file.path
        for air_file in air_files
    ]

    apple_support.run(
        ctx,
        executable = "/usr/bin/xcrun",
        inputs = air_files,
        outputs = [output_metallib],
        arguments = args,
        mnemonic = "MetallibCompile",
    )

    # Return the provider for the new bundling logic of rules_apple.
    return [
        DefaultInfo(
            files = depset([output_metallib]),
        ),
        resources.bucketize_typed([output_metallib], "unprocessed"),
    ]

metal_library = rule(
    attrs = dicts.add(apple_support.action_required_attrs(), {
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = METAL_FILE_TYPES,
            doc = """\
A list of `.metal` source files that will be compiled into the library.
""",
        ),
        "hdrs": attr.label_list(
            allow_files = [".h"],
            doc = """\
A list of headers that you need import to metal source.
""",
        ),
        "out": attr.string(
            default = "default.metallib",
            doc = """\
An output `.metallib` filename. Defaults to `default.metallib` if unspecified.
""",
        ),
        "includes": attr.string_list(
            doc = """\
A list of header search paths.
""",
        )
    }),
    doc = """\
Compiles Metal Shading Language source code into a Metal library.
To use this rule in your BUILD files, load it with:
```starlark
load("@rules_apple_line//apple:metal_library.bzl", "metal_library")
```
""",
    fragments = ["apple"],
    implementation = _metal_library_impl,
    outputs = {
        "out": "%{out}",
    },
)
