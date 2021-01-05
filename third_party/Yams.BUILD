load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Yams",
    srcs = glob(["Sources/Yams/**/*.swift"]),
    copts = [
        "-suppress-warnings",
        "-DSWIFT_PACKAGE",
    ],
    visibility = ["//visibility:public"],
    deps = [":CYams"],
)

objc_library(
    name = "CYams",
    srcs = glob(["Sources/CYaml/src/*"]),
    hdrs = glob(["Sources/CYaml/include/*"]),
    copts = [
        "-iquote",
        "external/Yams/Sources/CYaml/include",
    ],
    module_map = "Sources/CYaml/include/module.modulemap",
)
