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

workspace(name = "rules_apple_line")

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//apple:repositories.bzl", "rules_apple_line_dependencies")

rules_apple_line_dependencies()

load(
    "@build_bazel_apple_support//lib:repositories.bzl",
    "apple_support_dependencies",
)

apple_support_dependencies()

load(
    "@build_bazel_rules_apple//apple:repositories.bzl",
    "apple_rules_dependencies",
)

apple_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:repositories.bzl",
    "swift_rules_dependencies",
)

swift_rules_dependencies()

load(
    "@build_bazel_rules_swift//swift:extras.bzl",
    "swift_rules_extra_dependencies",
)

swift_rules_extra_dependencies()

load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

bazel_skylib_workspace()

git_repository(
    name = "io_bazel_stardoc",
    commit = "247c2097e7346778ac8d03de5a4770d6b9890dc5",
    remote = "https://github.com/bazelbuild/stardoc.git",
)

load("@io_bazel_stardoc//:setup.bzl", "stardoc_repositories")

stardoc_repositories()

http_archive(
    name = "io_bazel_rules_go",
    sha256 = "b9aa86ec08a292b97ec4591cf578e020b35f98e12173bbd4a921f84f583aebd9",
    url = "https://github.com/bazelbuild/rules_go/releases/download/v0.20.2/rules_go-v0.20.2.tar.gz",
)

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains()

http_archive(
    name = "com_github_bazelbuild_buildtools",
    sha256 = "66e047cd1804e3115447fcb64870a9e721ced8c0e500a906824e3ae8af912e78",
    strip_prefix = "buildtools-3.2.0",
    urls = ["https://github.com/bazelbuild/buildtools/archive/3.2.0.tar.gz"],
)

http_archive(
    name = "zld",
    build_file = "//third_party:zld.BUILD",
    sha256 = "96fc20e552795a06edccf53445f88fb448687509c51348fa6c27cce823c23f5e",
    url = "https://github.com/michaeleisel/zld/releases/download/1.2.1/zld.zip",
)
