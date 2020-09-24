load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@build_bazel_rules_apple//apple:versioning.bzl", "apple_bundle_version")
load(
    "//examples/ios/App/Sources:constants.bzl",
    "APP_EXECUTABLE_NAME",
    "APP_IDENTIFIER",
    "APP_VERSION",
    "DEFAULT_MINIMUM_OS_VERSION",
)

ios_application(
    name = "App",
    app_icons = ["//examples/ios/App/Sources:AppIcon"],
    bundle_id = select(APP_IDENTIFIER),
    executable_name = select(APP_EXECUTABLE_NAME),
    extensions = [
        "//examples/ios/App/ShareExtension:ShareExtension_appex",
    ],
    families = [
        "iphone",
        "ipad",
    ],
    infoplists = ["//examples/ios/App/Sources:PreprocessedInfoPlist"],
    linkopts = select({
        "//examples/ios/App/Configuration:Debug": [],
        # Speed up link time of the app. The exported symbol list is only
        # needed for an app if you're using that app as the bundle loader in tests.
        "//conditions:default": [
            "-exported_symbols_list",
            "/dev/null",
        ],
    }),
    minimum_os_version = DEFAULT_MINIMUM_OS_VERSION,
    version = ":version",
    visibility = ["//visibility:public"],
    watch_application = "//examples/ios/App/WatchKitApp",
    deps = ["//examples/ios/App/Sources:Main"],
)

apple_bundle_version(
    name = "version",
    build_label_pattern = "{timestamp_version}",
    build_version = "{timestamp_version}",
    capture_groups = {
        "timestamp_version": ".*",
    },
    fallback_build_label = "1980.0101.000000",  # Low number so we can't accidentally upload it.
    visibility = ["//visibility:public"],
)
