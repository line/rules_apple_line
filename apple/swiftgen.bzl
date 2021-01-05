# Copyright 2021 LINE Corporation
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

load(
    "@build_bazel_rules_apple//apple:utils.bzl",
    "group_files_by_directory",
)

def _swiftgen_impl(ctx):
    srcs = ctx.files.srcs

    inputs = []
    inputs.extend(srcs)
    inputs.append(ctx.file.template_file)
    output = ctx.outputs.out

    # Figure out the source type from the input files
    src_type = ""
    for f in srcs:
        if ".xcassets/" in f.path:
            src_type = "xcassets"
            break
        if f.path.endswith(".strings") or f.path.endswith(".stringsdict"):
            src_type = "strings"
            break

    args = ctx.actions.args()
    args.add("run")
    args.add(src_type)
    args.add("--output", output)
    args.add("--templatePath", ctx.file.template_file)

    for (key, value) in ctx.attr.template_params.items():
        args.add_joined(
            "--param",
            (key, value),
            join_with = "=",
        )

    # Figure out the last argument that will be passed to the swiftgen command
    if src_type == "xcassets":
        xcassets_dirs = group_files_by_directory(
            srcs,
            ["xcassets"],
            attr = "srcs",
        ).keys()
        if len(xcassets_dirs) != 1:
            fail("The xcassets_swift's srcs should contain exactly one" +
                 " directory named *.xcassets.")
        args.add(xcassets_dirs[0])

    elif src_type == "strings":
        for f in srcs:
            if f.path.endswith(".strings"):
                args.add(f)
            if f.path.endswith(".stringsdict"):
                args.add(f)

    else:
        fail("Failed to figure out the resource type from the input files, " +
             "or support for it has not been implemented: {}".format(src_type))

    ctx.actions.run(
        inputs = inputs,
        outputs = [output],
        executable = ctx.executable._swiftgen,
        arguments = [args],
        mnemonic = "SwiftGen",
    )

swiftgen = rule(
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            doc = "The list of input resource files.",
            mandatory = True,
        ),
        "out": attr.output(
            doc = "The output Swift filename.",
            mandatory = True,
        ),
        "template_file": attr.label(
            allow_single_file = [".stencil"],
            doc = "The template file which will be used to generate Swift code.",
            mandatory = True,
        ),
        "template_params": attr.string_dict(
            doc = """An optional dictionary of parameters that you want to pass
to the template.""",
        ),
        "_swiftgen": attr.label(
            default = "@SwiftGen//:swiftgen",
            allow_files = True,
            cfg = "exec",
            executable = True,
        ),
    },
    doc = "Generates Swift code from the given resource files.",
    implementation = _swiftgen_impl,
)
