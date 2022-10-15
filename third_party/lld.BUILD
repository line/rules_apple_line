load("@rules_apple_line//apple:apple_linker_inputs.bzl", "apple_linker_inputs")

apple_linker_inputs(
    name = "lld_linkopts",
    linker_inputs = ["ld64.lld"],
    linkopts = [
        "--ld-path=$(execpath ld64.lld)",
    ],
    visibility = ["//visibility:public"],
)
