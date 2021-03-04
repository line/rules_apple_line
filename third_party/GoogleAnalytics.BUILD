load(
    "@rules_apple_line//apple:objc_static_framework.bzl",
    "objc_static_framework",
)

objc_static_framework(
    name = "GoogleAnalytics",
    hdrs = glob(["Sources/*.h"]),
    archives = glob(["Libraries/*.a"]),
    sdk_dylibs = [
        "libsqlite3",
        "libz",
    ],
)
