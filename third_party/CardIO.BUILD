load(
    "@rules_apple_line//apple:objc_static_framework.bzl",
    "objc_static_framework",
)

objc_static_framework(
    name = "CardIO",
    hdrs = glob(["CardIO/*.h"]),
    archives = glob(["CardIO/*.a"]),
    umbrella_header = "CardIO/CardIO.h",
)
