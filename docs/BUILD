load(
    "@io_bazel_stardoc//stardoc:stardoc.bzl",
    "stardoc",
)

stardoc(
    name = "docs",
    out = "README.md",
    input = "doc_hub.bzl",
    deps = ["//apple:rules"],
)
