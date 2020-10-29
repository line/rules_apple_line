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

load("@build_bazel_rules_apple//apple:watchos.bzl", "watchos_extension")
load("//apple:apple_preprocessed_plist.bzl", "apple_preprocessed_plist")
load("//apple:swift_library.bzl", "swift_library")
load(
    "//examples/ios/App/Sources:constants.bzl",
    "APP_IDENTIFIER",
    "DEFAULT_MINIMUM_WATCHOS_VERSION",
    "EXTENSION_INFO_PLIST_DICT",
)

watchos_extension(
    name = "WatchKitExtension",
    bundle_id = select(APP_IDENTIFIER) + ".WatchKitApp.WatchKitExtension",
    infoplists = [":PreprocessedInfoPlist"],
    minimum_os_version = DEFAULT_MINIMUM_WATCHOS_VERSION,
    resources = glob([
        "Assets.xcassets/**",
    ]),
    version = "//examples/ios/App:version",
    visibility = ["//visibility:public"],
    deps = [":WatchKitExtensionLib"],
)

swift_library(
    name = "WatchKitExtensionLib",
    srcs = glob(["**/*.swift"]),
    module_name = "WatchKitExtension",
)

apple_preprocessed_plist(
    name = "PreprocessedInfoPlist",
    src = "Info.plist",
    out = "Info-Preprocessed.plist",
    substitutions = EXTENSION_INFO_PLIST_DICT,
)
