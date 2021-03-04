load(
    "@rules_apple_line//apple:objc_static_framework.bzl",
    "objc_static_framework",
)

_PUBLIC_HEADERS = glob(
    [
        "Classes/*.h",
        "Classes/Manager/*.h",
        "Classes/Toolbar/*.h",
        "Classes/GlobalStateExplorers/Globals/FLEXGlobalsEntry.h",
        "Classes/Core/**/*.h",
        "Classes/Utility/Runtime/Objc/**/*.h",
        "Classes/ObjectExplorers/**/*.h",
        "Classes/Editing/**/*.h",
        "Classes/Utility/FLEXMacros.h",
        "Classes/Utility/Categories/*.h",
        "Classes/Utility/FLEXAlert.h",
        "Classes/Utility/FLEXResources.h",
    ],
    exclude = ["Classes/FLEX.h"],
)

objc_static_framework(
    name = "FLEX",
    srcs = glob(
        [
            "Classes/**/*.c",
            "Classes/**/*.h",
            "Classes/**/*.m",
            "Classes/**/*.mm",
        ],
        exclude = _PUBLIC_HEADERS,
    ),
    hdrs = _PUBLIC_HEADERS,
    umbrella_header = "Classes/FLEX.h",
)
