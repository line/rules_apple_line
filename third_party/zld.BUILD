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

load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@rules_apple_line//apple:apple_linker_inputs.bzl", "apple_linker_inputs")
load("@rules_apple_line//apple:utils.bzl", "build_file_dirname")

# clang will look for a file `ld64.<linker-name>` in its search paths if we
# pass a linker name to it via the `-fuse-ld=<linker-name>` flag, or
# <linker-name> has to be an absolute path to a linker.
copy_file(
    name = "ld64_zld",
    src = "zld",
    out = "ld64.zld",
    is_executable = True,
)

apple_linker_inputs(
    name = "zld_linkopts",
    linker_inputs = [":ld64_zld"],
    linkopts = [
        # Add the containing directory to clang's search paths for binaries
        "-B$(BINDIR)/{}".format(
            build_file_dirname(
                repository_name(),
                package_name(),
            ),
        ),
        "-fuse-ld=zld",
        "-Wl,-zld_original_ld_path,__BAZEL_XCODE_DEVELOPER_DIR__/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld",
    ],
    visibility = ["//visibility:public"],
)
