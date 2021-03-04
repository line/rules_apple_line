load(
    "@rules_apple_line//apple:mixed_static_framework.bzl",
    "mixed_static_framework",
)

_PUBLIC_HEADERS = glob(["Sources/OHHTTPStubs/include/*.h"])

mixed_static_framework(
    name = "OHHTTPStubs",
    srcs = glob(
        [
            "Sources/**/*.h",
            "Sources/**/*.m",
            "Sources/**/*.swift",
        ],
        exclude = _PUBLIC_HEADERS,
    ),
    hdrs = _PUBLIC_HEADERS,
    umbrella_header = "Sources/OHHTTPStubs/include/HTTPStubs.h",
)
