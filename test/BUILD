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

build_test(
    name = "third_party_build_test",
    targets = [
        "@CardIO//:CardIOFramework",
        "@GoogleAnalytics//:GoogleAnalyticsFramework",
        "@OHHTTPStubs//:OHHTTPStubsFramework",
        "@facebook_ios_sdk//:FBSDKCoreKitFramework",
        "@facebook_ios_sdk//:FBSDKLoginKitFramework",
        "@FLEX//:FLEXFramework",
    ],
)
