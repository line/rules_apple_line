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

load("@build_bazel_rules_swift//swift:swift.bzl", "SwiftInfo")
load(":common.bzl", "HEADERS_FILE_TYPES")

def _module_map_content(
        module_name,
        hdrs,
        textual_hdrs,
        swift_generated_header,
        module_map_path):
    # Up to the execution root
    # bazel-out/<platform-config>/bin/<path/to/package>/<target-name>.modulemaps/<module-name>
    slashes_count = module_map_path.count("/")
    relative_path = "".join(["../"] * slashes_count)

    content = "module " + module_name + " {\n"

    for hdr in hdrs:
        content += "  header \"%s%s\"\n" % (relative_path, hdr.path)
    for hdr in textual_hdrs:
        content += "  textual header \"%s%s\"\n" % (relative_path, hdr.path)

    content += "\n"
    content += "  export *\n"
    content += "}\n"

    # Add a Swift submodule if a Swift generated header exists
    if swift_generated_header:
        content += "\n"
        content += "module " + module_name + ".Swift {\n"
        content += "  header \"%s\"\n" % swift_generated_header.basename
        content += "  requires objc\n"
        content += "}\n"

    return content

def _umbrella_header_content(module_name, hdrs):
    # If the platform is iOS, add an import call to `UIKit/UIKit.h` to the top
    # of the umbrella header. This allows implicit import of UIKit from Swift.
    content = """\
#ifdef __OBJC__
#import <Foundation/Foundation.h>
#if __has_include(<UIKit/UIKit.h>)
#import <UIKit/UIKit.h>
#endif
#endif

"""
    for hdr in hdrs:
        content += "#import \"%s\"\n" % (hdr.path)

    return content

def _impl(ctx):
    outputs = []

    hdrs = ctx.files.hdrs
    textual_hdrs = ctx.files.textual_hdrs
    outputs.extend(hdrs)
    outputs.extend(textual_hdrs)

    # Find Swift generated header
    swift_generated_header = None
    for dep in ctx.attr.deps:
        if CcInfo in dep:
            objc_headers = dep[CcInfo].compilation_context.headers.to_list()
        else:
            objc_headers = []
        for hdr in objc_headers:
            if hdr.owner == dep.label:
                swift_generated_header = hdr
                outputs.append(swift_generated_header)

    # Write the module map content
    if swift_generated_header:
        umbrella_header_path = ctx.attr.module_name + ".h"
        umbrella_header = ctx.actions.declare_file(umbrella_header_path)
        outputs.append(umbrella_header)
        ctx.actions.write(
            content = _umbrella_header_content(ctx.attr.module_name, hdrs),
            output = umbrella_header,
        )
        outputs.append(umbrella_header)

    module_map = ctx.outputs.out
    outputs.append(module_map)

    ctx.actions.write(
        content = _module_map_content(
            module_name = ctx.attr.module_name,
            hdrs = hdrs,
            textual_hdrs = textual_hdrs,
            swift_generated_header = swift_generated_header,
            module_map_path = module_map.path,
        ),
        output = module_map,
    )

    module_map_to_provide = []
    if ctx.attr.add_to_provider:
        module_map_to_provide = [module_map]

    objc_provider = apple_common.new_objc_provider(
        module_map = depset(module_map_to_provide),
        header = depset(outputs),
    )

    compilation_context = cc_common.create_compilation_context(
        headers = depset(outputs),
    )
    cc_info = CcInfo(
        compilation_context = compilation_context,
    )

    return struct(
        providers = [
            DefaultInfo(
                files = depset([module_map]),
            ),
            objc_provider,
            cc_info,
        ],
    )

_module_map = rule(
    implementation = _impl,
    attrs = {
        "module_name": attr.string(
            mandatory = True,
            doc = "The name of the module.",
        ),
        "hdrs": attr.label_list(
            allow_files = HEADERS_FILE_TYPES,
            doc = """\
The list of C, C++, Objective-C, and Objective-C++ header files used to
construct the module map.
""",
        ),
        "textual_hdrs": attr.label_list(
            allow_files = HEADERS_FILE_TYPES,
            doc = """\
The list of C, C++, Objective-C, and Objective-C++ header files used to
construct the module map. Unlike hdrs, these will be declared as 'textual
header' in the module map.
""",
        ),
        "deps": attr.label_list(
            providers = [SwiftInfo],
            doc = """\
The list of swift_library targets.  A `${module_name}.Swift` submodule will be
generated if non-empty.
""",
        ),
        "add_to_provider": attr.bool(
            default = True,
            doc = """\
Whether to add the generated module map to the returning provider. Targets
imported via `apple_static_framework_import` or
`apple_dynamic_framework_import` already have their module maps provided to
swift_library targets depending on them. Set this to `False` in that case to
avoid duplicate modules.
""",
        ),
        "out": attr.output(
            doc = "The name of the output module map file.",
        ),
        "_realpath": attr.label(
            cfg = "exec",
            allow_single_file = True,
            default = Label("@bazel_tools//tools/objc:realpath"),
        ),
    },
    doc = "Generates a module map given a list of header files.",
)

# TODO: Revisit. Stardoc generation of this. Stardoc will look at this macro
# instead of the rule above, so it is generating empty documentation for this.
def module_map(name, **kwargs):
    _module_map(
        name = name,
        out = name + "-module.modulemap",
        **kwargs
    )
