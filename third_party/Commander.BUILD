load("@build_bazel_rules_swift//swift:swift.bzl", "SwiftInfo", "swift_library")

swift_library(
    name = "Commander",
    srcs = glob(["Sources/Commander/*.swift"]),
    copts = ["-suppress-warnings"],
    visibility = ["//visibility:public"],
)
