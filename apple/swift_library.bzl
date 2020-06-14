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

load(":swift_static_framework.bzl", "swift_static_framework")

def swift_library(**kwargs):
    """Compiles and links Swift code into a static library and Swift module.

    A drop-in replacement of the official
    [swift_library](https://github.com/bazelbuild/rules_swift/blob/master/doc/rules.md#swift_library)
    rule, with added supports for header maps, and better integration with other
    rules in this repository.

    To use this rule in your BUILD files, load it with:

    ```starlark
    load("@com_linecorp_bazel_rules_apple//apple:objc_library.bzl", "objc_library")
    ```

    See [swift_static_framework](#swift_static_framework) for the documentation
    of each attribute.
    """
    swift_static_framework(**kwargs)
