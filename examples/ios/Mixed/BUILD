load(
    "@rules_apple_line//apple:mixed_static_framework.bzl",
    "mixed_static_framework",
)

mixed_static_framework(
    name = "Mixed",
    srcs = glob([
        "**/*.m",
        "**/*.swift",
    ]),
    hdrs = glob([
        "**/*.h",
    ]),
    objc_copts = [
        "-I$(BINDIR)/examples/ios",
    ],
)
