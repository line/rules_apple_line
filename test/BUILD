load("@bazel_skylib//rules:build_test.bzl", "build_test")

build_test(
    name = "examples_build_test",
    targets = [
        "//examples/ios/App",
        "//examples/ios/Mixed:MixedFramework",
        "//examples/ios/PureObjC:PureObjCFramework",
        "//examples/ios/PureSwift:PureSwiftFramework",
    ],
)

build_test(
    name = "pkg_dsym_build_test",
    tags = ["manual"],
    targets = [
        "//examples/ios/App:App_dSYM",
    ],
)
