def _apple_linker_inputs_impl(ctx):
    linkopts = []
    for opt in ctx.attr.linkopts:
        expanded_opt = ctx.expand_location(
            opt,
            targets = ctx.attr.linker_inputs,
        )
        expanded_opt = ctx.expand_make_variables(
            "linkopts",
            expanded_opt,
            {},
        )
        linkopts.append(expanded_opt)

    linker_inputs = depset(ctx.files.linker_inputs)
    objc_provider = apple_common.new_objc_provider(
        link_inputs = depset(ctx.files.linker_inputs),
        linkopt = depset(linkopts),
    )

    cc_linker_input = cc_common.create_linker_input(
        additional_inputs = depset(ctx.files.linker_inputs),
        owner = ctx.label,
        user_link_flags = depset(linkopts),
    )
    cc_linking_context = cc_common.create_linking_context(
        linker_inputs = depset([cc_linker_input]),
    )
    cc_info = CcInfo(
        linking_context = cc_linking_context,
    )

    # objc_provider can be removed once apple_binary is reimplemented in
    # Starlark
    return [
        cc_info,
        objc_provider,
    ]

apple_linker_inputs = rule(
    attrs = {
        "linkopts": attr.string_list(
            doc = """
Extra flags to be passed to Clang's linker command. Subject to ["Make"
variable](https://docs.bazel.build/versions/master/be/make-variables.html)
substitution and [label
expansion](https://docs.bazel.build/versions/master/be/common-definitions.html#label-expansion).
""",
        ),
        "linker_inputs": attr.label_list(
            allow_files = True,
            doc = """
Extra files to be passed to the linker action.
""",
        ),
    },
    doc = """
Provides additional inputs to Apple rules' linker action.

Unlike C++ rules like `cc_binary` and `cc_test`, Apple rules doesn't have any
mechanism to allow providing additional inputs to the linker action. This
little rule helps mitigate that.
""",
    implementation = _apple_linker_inputs_impl,
)
