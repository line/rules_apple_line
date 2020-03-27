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

def swift_static_framework(
        name,
        copts = [],
        **kwargs):
    if kwargs.get("swift_copts"):
        fail("""There is no 'swift_copts' attribute in
             'swift_static_framework'. Maybe you want 'copts'?""")
    mixed_static_framework(name = name, swift_copts = copts, **kwargs)
