load("//apple:apple_preprocessed_plist.bzl", "apple_preprocessed_plist")
load("//apple:apple_library.bzl", "apple_library")
load(
    "//examples/ios/App/Sources:constants.bzl",
    "INFO_PLIST_DICT",
)

apple_library(
    name = "Main",
    srcs = glob([
        "**/*.swift",
    ]),
    data = glob([
        "**/*.storyboard",
    ]),
    deps = [
        "//examples/ios/Mixed",
        "//examples/ios/PureObjC",
        "//examples/ios/PureSwift",
    ],
)

apple_preprocessed_plist(
    name = "PreprocessedInfoPlist",
    src = "Info.plist",
    out = "Info-Preprocessed.plist",
    substitutions = INFO_PLIST_DICT,
    visibility = ["//examples/ios/App:__pkg__"],
)

filegroup(
    name = "AppIcon",
    srcs = glob([":Assets.xcassets/AppIcon.appiconset/**"]),
    visibility = ["//visibility:public"],
)
