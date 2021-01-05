load("@build_bazel_rules_swift//swift:swift.bzl", "swift_binary", "swift_library")

swift_library(
    name = "SwiftGenKit",
    srcs = glob(["Sources/SwiftGenKit/**/*.swift"]),
    deps = [
        "@Kanna",
        "@PathKit",
        "@Yams",
    ],
)

swift_binary(
    name = "swiftgen",
    srcs = glob(["Sources/SwiftGen/**/*.swift"]),
    visibility = ["//visibility:public"],
    deps = [
        ":SwiftGenKit",
        "@Commander",
        "@StencilSwiftKit",
    ],
)
