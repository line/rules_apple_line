py_binary(
    name = "plist_merger",
    srcs = ["plist_merger.py"],
    srcs_version = "PY3",
    # Used by the rule implementations, so it needs to be public; but
    # should be considered an implementation detail of the rules and
    # not used by other things.
    visibility = ["//visibility:public"],
    deps = ["@build_bazel_rules_apple//tools/wrapper_common:execute"],
)
