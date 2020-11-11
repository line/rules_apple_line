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

"""Utility functions for rules_apple_line."""

def build_file_dirname(repository_name, package_name):
    """Returns path to the directory containing BUILD file for this rule,
    relative to the source root."""
    dirs = []
    if repository_name != "@":
        dirs.append("external")
        dirs.append(repository_name.lstrip("@"))
    if package_name:
        dirs.append(package_name)
    return "/".join(dirs)
