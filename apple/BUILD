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
    "@bazel_skylib//:bzl_library.bzl",
    "bzl_library",
)

bzl_library(
    name = "rules",
    srcs = [
        "@bazel_skylib//lib:paths.bzl",
        "@bazel_skylib//lib:sets.bzl",
        "@bazel_skylib//lib:types.bzl",
        "@bazel_tools//tools/build_defs/repo:http.bzl",
        "@build_bazel_apple_support//lib:apple_support.bzl",
        "@build_bazel_rules_apple//apple:ios.bzl",
        "@build_bazel_rules_apple//apple:providers.bzl",
        "@build_bazel_rules_swift//swift:swift.bzl",
        "@com_github_ob_rules_ios//rules:hmap.bzl",
    ] + glob(["*.bzl"]),
    visibility = ["//visibility:public"],
)
