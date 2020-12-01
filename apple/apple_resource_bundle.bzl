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

load("@bazel_skylib//lib:paths.bzl", "paths")
load(
    "@build_bazel_rules_apple//apple:resources.bzl",
    _apple_resource_bundle = "apple_resource_bundle",
)

def apple_resource_bundle(
        name,
        infoplists,
        bundle_id = None,
        **kwargs):
    """
    To use this rule in your BUILD files, load it with:

    ```starlark
    load("@rules_apple_line//apple:apple_resource_bundle.bzl", "apple_resource_bundle")
    ```
    """

    # Replace PRODUCT_BUNDLE_IDENTIFIER with the provided bundle_id. For the
    # simplicity of this patch, we only use a single Info.plist for each
    # resource bundle target now.
    if len(infoplists) > 1:
        fail("There should be only a single Info.plist")
    infoplist = infoplists[0]

    modified_infoplists = [
        name + "-" + paths.basename(infoplist) + "-modified",
    ]

    bundle_id = bundle_id or name

    native.genrule(
        name = name + "_info_plist_modified",
        srcs = [infoplist],
        outs = modified_infoplists,
        message = "Substitute variables in {}".format(infoplist),
        cmd = """
plutil -replace CFBundleIdentifier -string {} -o "$@" "$<"
""".format(bundle_id),
    )

    _apple_resource_bundle(
        name = name,
        infoplists = modified_infoplists,
        **kwargs
    )
