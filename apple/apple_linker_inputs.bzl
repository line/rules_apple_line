# Copyright 2020 LINE Corporation
#
# LINE Corporation licenses this file to you under the Apache License,
# version 2.0 (the "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at:
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

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

    linkopts_depset = depset(linkopts)
    linker_inputs_depset = depset(ctx.files.linker_inputs)

    objc_provider = apple_common.new_objc_provider(
        link_inputs = linker_inputs_depset,
        linkopt = linkopts_depset,
    )

    cc_linker_input = cc_common.create_linker_input(
        additional_inputs = linker_inputs_depset,
        owner = ctx.label,
        user_link_flags = linkopts_depset,
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

Unlike C++ rules like `cc_binary` and `cc_test`, Apple rules don't have any
mechanism to allow providing additional inputs to the linker action. This
little rule helps mitigate that.

To use this rule in your BUILD files, load it with:

```starlark
load("@rules_apple_line//apple:apple_linker_inputs.bzl", "apple_linker_inputs")
```
""",
    implementation = _apple_linker_inputs_impl,
)
