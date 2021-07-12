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
load("@build_bazel_rules_apple//apple/internal:resources.bzl","resources")

def _metal_apple_target_triple(ctx):
    """Returns a Metal target triple string for an Apple platform.
    Args:
        ctx: The compilation context.
    Returns:
        A target triple string describing the platform.
    """
    platform = ctx.fragments.apple.single_arch_platform
    environment = "" if platform.is_device else "-simulator"
    target_os_version = ctx.attr.minimum_os_version

    return "air64-apple-{platform}{version}{environment}".format(
        environment = environment,
        platform = ctx.attr.platform,
        version = target_os_version,
    )

def _metal_library_impl(ctx):
    air_files = []
    includes_input = []

    target = _metal_apple_target_triple(ctx)
    # Compile each .metal file into a single .air file
    
    for includePath in ctx.attr.includes:
        includes_input.append("-I{}".format(includePath))
    
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
            "-ffast-math"]

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

    resource_provider = resources.bucketize_typed(
        [output_metallib],
        bucket_type = "unprocessed",
    )
    return [
        resource_provider,
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
                A list of header that you need import to metal source.
""",
        ),
        "out": attr.string(
            default = "default.metallib",
            doc = """\
An output `.metallib` filename. Defaults to `default.metallib` if unspecified.
""",
        ),
        "minimum_os_version": attr.string(
            mandatory = True,
            doc = """\
                Minimum os version for build target.
""",
        ),
        "platform": attr.string(
            default = "ios",
            doc = """\
                Target platform for build target.
""",
        ),
        "includes": attr.string_list(
            mandatory = True,
            doc = """\
                A list of header search path.
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