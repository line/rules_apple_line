load("@build_bazel_rules_apple//apple:watchos.bzl", "watchos_extension")
load("//apple:apple_preprocessed_plist.bzl", "apple_preprocessed_plist")
load("//apple:swift_library.bzl", "swift_library")
load(
    "//examples/ios/App/Sources:constants.bzl",
    "APP_IDENTIFIER",
    "DEFAULT_MINIMUM_WATCHOS_VERSION",
    "EXTENSION_INFO_PLIST_DICT",
)

watchos_extension(
    name = "WatchKitExtension",
    bundle_id = select(APP_IDENTIFIER) + ".WatchKitApp.WatchKitExtension",
    infoplists = [":PreprocessedInfoPlist"],
    minimum_os_version = DEFAULT_MINIMUM_WATCHOS_VERSION,
    resources = glob([
        "Assets.xcassets/**",
    ]),
    version = "//examples/ios/App:version",
    visibility = ["//visibility:public"],
    deps = [
        ":WatchKitExtensionLib",
        "@zld//:zld_linkopts",
    ],
)

swift_library(
    name = "WatchKitExtensionLib",
    srcs = glob(["**/*.swift"]),
    module_name = "WatchKitExtension",
)

apple_preprocessed_plist(
    name = "PreprocessedInfoPlist",
    src = "Info.plist",
    out = "Info-Preprocessed.plist",
    substitutions = EXTENSION_INFO_PLIST_DICT,
)
