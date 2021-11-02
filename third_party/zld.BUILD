load("@build_bazel_apple_support//lib:apple_support.bzl", "apple_support")
load("@rules_apple_line//apple:apple_linker_inputs.bzl", "apple_linker_inputs")

apple_linker_inputs(
    name = "zld_linkopts",
    linker_inputs = ["@zld"],
    linkopts = [
        "--ld-path=$(execpath @zld)",
        "-Wl,-zld_original_ld_path,{}/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld".format(
            apple_support.path_placeholders.xcode(),
        ),
    ],
    visibility = ["//visibility:public"],
)
