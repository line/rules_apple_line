load(
    "@bazel_skylib//:bzl_library.bzl",
    "bzl_library",
)

bzl_library(
    name = "rules",
    srcs = [
        "@bazel_skylib//lib:paths.bzl",
        "@bazel_skylib//lib:sets.bzl",
        "@bazel_skylib//lib:types.bzl",
        "@bazel_tools//tools/build_defs/repo:http.bzl",
        "@build_bazel_apple_support//lib:apple_support.bzl",
        "@build_bazel_rules_apple//apple:ios.bzl",
        "@build_bazel_rules_apple//apple:providers.bzl",
        "@build_bazel_rules_swift//swift:swift.bzl",
        "@com_github_ob_rules_ios//rules:hmap.bzl",
        "@rules_proto//proto:defs.bzl",
    ] + glob(["*.bzl"]),
    visibility = ["//visibility:public"],
)
