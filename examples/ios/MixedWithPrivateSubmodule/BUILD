load(
    "@rules_apple_line//apple:mixed_static_framework.bzl",
    "mixed_static_framework",
)
load(
    "@rules_apple_line//apple:objc_library.bzl",
    "objc_library",
)

mixed_static_framework(
    name = "MixedWithPrivateSubmodule",
    srcs = [
        "MXDObjcGreeter.m",
        "SwiftGreeter.swift",
    ],
    hdrs = [
        "MXDObjcGreeter.h",
    ],
    avoid_deps = [],
    objc_copts = [
        "-I$(BINDIR)/examples/ios",
    ],
    deps = [
        "//examples/ios/MixedWithPrivateSubmodule/submodule",
    ],
)
