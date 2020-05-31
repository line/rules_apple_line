load("//apple:swift_static_framework.bzl", "swift_static_framework")
load("//apple:apple_preprocessed_plist.bzl", "apple_preprocessed_plist")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_extension")
load(
    "//examples/ios/App/Sources:constants.bzl",
    "APP_IDENTIFIER",
    "DEFAULT_MINIMUM_OS_VERSION",
    "INFO_PLIST_DICT",
)

swift_static_framework(
    name = "ShareExtension",
    srcs = glob(["**/*.swift"]),
    data = glob(["**/*.storyboard"]),
)

apple_preprocessed_plist(
    name = "PreprocessedInfoPlist",
    src = "Info.plist",
    out = "Info-Preprocessed.plist",
    substitutions = INFO_PLIST_DICT,
)

ios_extension(
    name = "ShareExtension_appex",
    bundle_id = select(APP_IDENTIFIER) + ".ShareExtension",
    bundle_name = "ShareExtension",
    families = [
        "iphone",
        "ipad",
    ],
    infoplists = [":PreprocessedInfoPlist"],
    minimum_os_version = DEFAULT_MINIMUM_OS_VERSION,
    version = "//examples/ios/App:version",
    visibility = ["//examples/ios/App:__pkg__"],
    deps = [":ShareExtension"],
)