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

# Default attributes

DEFAULT_MINIMUM_OS_VERSION = "11.0"

DEFAULT_VISIBILITY = ["//visibility:public"]

# Shared compiler options

SHARED_COMPILER_OPTIONS = ["-DBAZEL"]

SHARED_OBJC_COMPILER_OPTIONS = SHARED_COMPILER_OPTIONS

SHARED_SWIFT_COMPILER_OPTIONS = SHARED_COMPILER_OPTIONS

# File types

CPP_FILE_TYPES = [".cc", ".cpp", ".mm", ".cxx", ".C"]

NON_CPP_FILE_TYPES = [".m", ".c"]

ASSEMBLY_FILE_TYPES = [".s", ".S", ".asm"]

OBJECT_FILE_FILE_TYPES = [".o"]

HEADERS_FILE_TYPES = [
    ".h",
    ".hh",
    ".hpp",
    ".ipp",
    ".hxx",
    ".h++",
    ".inc",
    ".inl",
    ".tlh",
    ".tli",
    ".H",
    ".hmap",
]

OBJC_FILE_TYPES = CPP_FILE_TYPES + \
                  NON_CPP_FILE_TYPES + \
                  ASSEMBLY_FILE_TYPES + \
                  OBJECT_FILE_FILE_TYPES + \
                  HEADERS_FILE_TYPES

SWIFT_FILE_TYPES = [".swift"]

METAL_FILE_TYPES = [".metal"]
