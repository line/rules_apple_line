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

load(
    "@com_github_ob_rules_ios//rules:hmap.bzl",
    "headermap",
)

def headermap_support(name, module_name, hdrs, private_hdrs, deps):
    # Don't rename this. The 'headermap' rule relies on the filename to
    # determine which one is a public header map, in order to merge it with
    # transitve public header maps.
    public_hmap = name + "_public_hmap"
    public_hdrs_filegroup = name + "_public_hdrs"
    private_hmap = name + "_private_hmap"
    private_angled_hmap = name + "_private_angled_hmap"
    private_hdrs_filegroup = name + "_private_hdrs"
    private_angled_hdrs_filegroup = name + "_private_angled_hdrs"

    native.filegroup(
        name = public_hdrs_filegroup,
        srcs = hdrs,
    )
    native.filegroup(
        name = private_hdrs_filegroup,
        srcs = private_hdrs + hdrs,
    )
    native.filegroup(
        name = private_angled_hdrs_filegroup,
        srcs = private_hdrs,
    )

    headermap(
        name = public_hmap,
        namespace = module_name,
        hdrs = [public_hdrs_filegroup],
        hdr_providers = deps,
        flatten_headers = True,
    )
    headermap(
        name = private_hmap,
        namespace = module_name,
        hdrs = [private_hdrs_filegroup],
        flatten_headers = False,
    )
    headermap(
        name = private_angled_hmap,
        namespace = module_name,
        hdrs = [private_angled_hdrs_filegroup],
        flatten_headers = True,
    )

    headermap_copts = [
        "-I$(execpath :{})".format(private_hmap),
        "-I$(execpath :{})".format(public_hmap),
        "-I$(execpath :{})".format(private_angled_hmap),
        "-I.",
        "-iquote",
        "$(execpath :{})".format(private_hmap),
    ]

    return {
        "public_hmap": public_hmap,
        "private_hmap": private_hmap,
        "private_angled_hmap": private_angled_hmap,
        "headermap_copts": headermap_copts,
    }
