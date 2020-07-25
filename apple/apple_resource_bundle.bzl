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
load(":metal_library.bzl", "metal_library")
load(":common.bzl", "METAL_FILE_TYPES")

def apple_resource_bundle(
        name,
        resources,
        infoplists,
        bundle_id = None,
        **kwargs):
    """
    To use this rule in your BUILD files, load it with:

    ```starlark
    load("@rules_apple_line//apple:apple_resource_bundle.bzl", "apple_resource_bundle")
    ```
    """

    # Replace DEVELOPMENT_LANGUAGE with "en" and PRODUCT_BUNDLE_IDENTIFIER with
    # a generated value so that it can be used with Bazel.

    # For the simplicity of this patch, we only use a single Info.plist for
    # each resource bundle target now.
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
plutil -replace CFBundleDevelopmentRegion -string en -o - $< | \
plutil -replace CFBundleIdentifier -string {} -o $@ -
""".format(bundle_id),
    )

    _resources = []
    metal_files = []

    for file in resources:
        filename = paths.basename(file)

        if filename.endswith(METAL_FILE_TYPES[0]):
            metal_files.append(file)
            continue

        # Remove the BUILD file and .DS_Store file from resources if
        # accidentally added
        if filename != "BUILD" and filename != ".DS_Store":
            _resources.append(file)

    if metal_files:
        metal_lib_name = name + "_metallib"
        metal_library(
            name = metal_lib_name,
            srcs = metal_files,
        )
        _resources.append(":" + metal_lib_name)

    _apple_resource_bundle(
        name = name,
        resources = _resources,
        infoplists = modified_infoplists,
        **kwargs
    )
