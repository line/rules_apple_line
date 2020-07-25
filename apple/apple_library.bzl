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

load(":mixed_static_framework.bzl", "mixed_static_framework")

def apple_library(**kwargs):
    """Compiles and links Objective-C and Swift code into a static library.

    To use this rule in your BUILD files, load it with:

    ```starlark
    load("@rules_apple_line//apple:apple_library.bzl", "apple_library")
    ```

    See [mixed_static_framework](#mixed_static_framework) for the documentation
    of each attribute.
    """
    mixed_static_framework(**kwargs)
