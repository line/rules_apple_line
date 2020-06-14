load("//apple:string_dict_select_values.bzl", "string_dict_select_values")

def _impl(ctx):
    substitutions = {}
    for key, value in zip(ctx.attr.keys, ctx.attr.values):
        substitutions["${" + key + "}"] = value
        substitutions["$(" + key + ")"] = value

    output = ctx.outputs.out
    ctx.actions.expand_template(
        template = ctx.file.src,
        output = output,
        substitutions = substitutions,
    )

    return [
        DefaultInfo(files = depset([output])),
    ]

_apple_preprocessed_plist = rule(
    attrs = {
        "src": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "The property list file that should be processed.",
        ),
        "out": attr.output(
            mandatory = True,
            doc = "The file reference for the output plist.",
        ),
        "keys": attr.string_list(
            allow_empty = True,
            mandatory = False,
            default = [],
            doc = "The attribute names to be expanded.",
        ),
        "values": attr.string_list(
            allow_empty = True,
            mandatory = False,
            default = [],
            doc = "The attribute values. The order should match the order of keys.",
        ),
    },
    doc = """
Generates the plist given the provided keys and values to be used for the
substitution.  By default, Bazel only supports a limited set of variable
substitutions when handling Info.plists --- use this rule to preprocess them
before passing them to the official rules.  See [rules_apple's Variable
Substitution](https://github.com/bazelbuild/rules_apple/blob/d77d5b96293344a96176c1f93da5af5dee23d0f5/doc/common_info.md#variable-substitution)
for more details.  Note that this does not compile your plist into the binary
format.

To use this rule in your BUILD files, load it with:

```starlark
load("@com_linecorp_bazel_rules_apple//apple:apple_preprocessed_plist.bzl", "apple_preprocessed_plist")
```
""",
    fragments = ["apple"],
    implementation = _impl,
)

def apple_preprocessed_plist(name, src, out, substitutions, **kwargs):
    _apple_preprocessed_plist(
        name = name,
        src = src,
        out = out,
        keys = substitutions.keys(),
        values = string_dict_select_values(substitutions.values()),
        **kwargs
    )
