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

"""Definitions for handling Bazel repositories used by the LINE Apple rules."""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def rules_apple_line_dependencies():
    """Fetches repositories that are dependencies of the `rules_apple_line` workspace.

    Users should call this macro in their `WORKSPACE` to ensure that all of the
    dependencies of the Apple rules are downloaded and that they are isolated from
    changes to those dependencies.
    """
    maybe(
        http_archive,
        name = "bazel_skylib",
        urls = [
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        ],
        sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
    )

    maybe(
        http_archive,
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.3.0/rules_pkg-0.3.0.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.3.0/rules_pkg-0.3.0.tar.gz",
        ],
        sha256 = "6b5969a7acd7b60c02f816773b06fcf32fbe8ba0c7919ccdc2df4f8fb923804a",
    )

    maybe(
        http_archive,
        name = "build_bazel_rules_apple",
        sha256 = "a5f00fd89eff67291f6cd3efdc8fad30f4727e6ebb90718f3f05bbf3c3dd5ed7",
        url = "https://github.com/bazelbuild/rules_apple/releases/download/0.33.0/rules_apple.0.33.0.tar.gz",
    )

    maybe(
        git_repository,
        name = "com_github_ob_rules_ios",
        commit = "7c0759d784a3f66032038a51c1c144e528c5d7a8",
        remote = "https://github.com/ob/rules_ios.git",
        # TODO: Update hmap rule
        patch_args = ["-p1"],
        patches = ["@rules_apple_line//third_party:rules_ios.patch"],
    )

    maybe(
        http_archive,
        name = "Commander",
        build_file = "//third_party:Commander.BUILD",
        sha256 = "4243b0227e51b8ea60345eac3ec4a3ff4385435e86011f2b60273e16806af9a8",
        strip_prefix = "Commander-0.9.1",
        url = "https://github.com/kylef/Commander/archive/0.9.1.tar.gz",
    )

    # SwiftGen dependencies
    maybe(
        http_archive,
        name = "Kanna",
        build_file = "//third_party:Kanna.BUILD",
        sha256 = "9aad278e9ec7069a4c06d638c8b21580587e93a67e93f488dabf0a51cd275265",
        strip_prefix = "Kanna-5.2.3",
        url = "https://github.com/tid-kijyun/Kanna/archive/5.2.3.tar.gz",
    )

    maybe(
        http_archive,
        name = "PathKit",
        build_file = "//third_party:PathKit.BUILD",
        sha256 = "6d45fb8153b047d21568b607ba7da851a52f59817f35441a4656490b37680c64",
        strip_prefix = "PathKit-1.0.0",
        url = "https://github.com/kylef/PathKit/archive/1.0.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "Stencil",
        build_file = "//third_party:Stencil.BUILD",
        sha256 = "1f20c356f9dd454517e1362df7ec5355aee9fa3c59b8d48cadc62019f905d8ec",
        strip_prefix = "Stencil-0.14.0",
        url = "https://github.com/stencilproject/Stencil/archive/0.14.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "StencilSwiftKit",
        build_file = "//third_party:StencilSwiftKit.BUILD",
        sha256 = "225f5c03051805d6bdb8f25f980bed83b03bb3c840278e9d7171d016c8b33fbd",
        strip_prefix = "StencilSwiftKit-fad4415a4c904a9845134b02fd66bd8464741427",
        url = "https://github.com/SwiftGen/StencilSwiftKit/archive/fad4415a4c904a9845134b02fd66bd8464741427.tar.gz",
    )

    maybe(
        http_archive,
        name = "SwiftGen",
        build_file = "//third_party:SwiftGen.BUILD",
        sha256 = "fa9377ebea5c0bea55d67671eb2f20491a49f3a3d90b086d75743bffc99507f0",
        strip_prefix = "SwiftGen-6.4.0",
        url = "https://github.com/SwiftGen/SwiftGen/archive/6.4.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "Yams",
        build_file = "//third_party:Yams.BUILD",
        sha256 = "1653e729419565b9a34b327e3a70f514254c9d73c46c18be2599cd271105079f",
        strip_prefix = "Yams-4.0.0",
        url = "https://github.com/jpsim/Yams/archive/4.0.0.tar.gz",
    )

def rules_apple_line_test_dependencies():
    """Fetches repositories that are dependencies for tests of the `rules_apple_line` workspace.
    """
    maybe(
        http_archive,
        name = "CardIO",
        build_file = "//third_party:CardIO.BUILD",
        url = "https://github.com/card-io/card.io-iOS-SDK/archive/5.4.1.tar.gz",
        sha256 = "ff3e1ddf3cb111b7dec15cb62811a9cfc22c33c9de9d6a0fb8e64ee9c64c5a04",
        strip_prefix = "card.io-iOS-SDK-5.4.1",
    )

    maybe(
        http_archive,
        name = "GoogleAnalytics",
        build_file = "//third_party:GoogleAnalytics.BUILD",
        sha256 = "5731a649759c1bd676a378e5caeb9e8ffb466a0c5aeab344ddd3800c9917e9ca",
        url = "https://www.gstatic.com/cpdc/5cd71dd2f756bb01/GoogleAnalytics-3.17.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "OHHTTPStubs",
        build_file = "//third_party:OHHTTPStubs.BUILD",
        sha256 = "6a5689f8b857d16f89e89ca0462b71c9b2c46eaf28d66f9e105b6f859d888cfb",
        strip_prefix = "OHHTTPStubs-9.0.0",
        url = "https://github.com/AliSoftware/OHHTTPStubs/archive/9.0.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "facebook_ios_sdk",
        build_file = "//third_party:facebook-ios-sdk.BUILD",
        sha256 = "2039e0c197e0cbda9824e7fda97904e88171ed3a5ced1f03f78408a624afdac8",
        strip_prefix = "facebook-ios-sdk-5.7.0",
        url = "https://github.com/facebook/facebook-ios-sdk/archive/v5.7.0.tar.gz",
    )

    maybe(
        http_archive,
        name = "FLEX",
        build_file = "//third_party:FLEX.BUILD",
        sha256 = "b91fc261697fa1f3233aa2ede9dfe2b5fcffb9dafdbcdaddb1edfc94df40275a",
        strip_prefix = "FLEX-4.1.1",
        url = "https://github.com/FLEXTool/FLEX/archive/4.1.1.tar.gz",
    )
