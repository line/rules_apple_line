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

load(":objc_static_framework.bzl", "objc_static_framework")

def objc_library(**kwargs):
    """Produces a static library from the given Objective-C source files.

    A drop-in replacement of the native
    [objc_library](https://docs.bazel.build/versions/3.2.0/be/objective-c.html#objc_library)
    rule, with added supports for header maps and modules.

    See [objc_static_framework](#objc_static_framework) for the documentation
    of each attribute.
    """
    objc_static_framework(**kwargs)
