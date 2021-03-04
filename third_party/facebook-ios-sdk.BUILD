load(
    "@rules_apple_line//apple:objc_static_framework.bzl",
    "objc_static_framework",
)

objc_static_framework(
    name = "FBSDKCoreKit",
    srcs = glob(
        [
            "FBSDKCoreKit/FBSDKCoreKit/**/*.m",
            "FBSDKCoreKit/FBSDKCoreKit/AppLink/Internal/**/*.h",
        ],
        exclude = glob([
            # From the podspec
            "FBSDKCoreKit/FBSDKCoreKit/FBSDKDeviceButton.*",
            "FBSDKCoreKit/FBSDKCoreKit/FBSDKDeviceViewControllerBase.*",
            "FBSDKCoreKit/FBSDKCoreKit/Internal/Device/**/*",
            # Non ARC code
            "FBSDKCoreKit/FBSDKCoreKit/Internal_NoARC/FBSDKDynamicFrameworkLoader.m",
        ]),
    ),
    hdrs = glob([
        "FBSDKCoreKit/FBSDKCoreKit/*.h",
        "FBSDKCoreKit/FBSDKCoreKit/AppEvents/**/*.h",
        "FBSDKCoreKit/FBSDKCoreKit/AppLink/*.h",
        "FBSDKCoreKit/FBSDKCoreKit/Basics/**/*.h",
        "FBSDKCoreKit/FBSDKCoreKit/Internal/**/*.h",
    ]),
    non_arc_srcs = [
        "FBSDKCoreKit/FBSDKCoreKit/Internal_NoARC/FBSDKDynamicFrameworkLoader.m",
    ],
    umbrella_header = "FBSDKCoreKit/FBSDKCoreKit/FBSDKCoreKit.h",
)

objc_static_framework(
    name = "FBSDKLoginKit",
    srcs = glob([
        "FBSDKLoginKit/FBSDKLoginKit/**/*.m",
        "FBSDKLoginKit/FBSDKLoginKit/Internal/**/*.h",
    ]),
    hdrs = glob([
        "FBSDKLoginKit/FBSDKLoginKit/*.h",
    ]),
    copts = ["-w"],
    umbrella_header = "FBSDKLoginKit/FBSDKLoginKit/FBSDKLoginKit.h",
    deps = [
        ":FBSDKCoreKit",
    ],
)
