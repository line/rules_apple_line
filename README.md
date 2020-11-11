# LINE's Apple rules for Bazel ![](https://github.com/line/bazel_rules_apple/workflows/build/badge.svg)

This repository contains additional rules for Bazel that can be used to bundle
applications for Apple platforms.

## Overview

[Bazel](http://bazel.build)'s official rules for Apple platforms lack many of
the features that are conventionally important in the Apple community in
general, notably: supports for header maps, Clang modules and mixed language
targets. This repository implements those features and exposes them as drop-in
replacements for the official Apple rules.

## Build Definitions

### Library Rules

* [apple_library](docs/README.md#apple_library)
* [metal_library](docs/README.md#metal_library)
* [objc_library](docs/README.md#objc_library)
* [swift_library](docs/README.md#swift_library)

### Bundling Rules

* [mixed_static_framework](docs/README.md#mixed_static_framework)
* [objc_static_framework](docs/README.md#objc_static_framework)
* [swift_static_framework](docs/README.md#swift_static_framework)

### Other Rules

* [apple_linker_inputs](docs/README.md#apple_linker_inputs)
* [apple_preprocessed_plist](docs/README.md#apple_preprocessed_plist)
* [apple_resource_bundle](docs/README.md#apple_resource_bundle)
* [module_map](docs/README.md#module_map)
* [pkg_dsym](docs/README.md#pkg_dsym)

## Requirements

The latest versions of **rules_apple** and **rules_swift** rulesets require
the usage of the [--incompatible_objc_compile_info_migration](https://docs.bazel.build/versions/master/command-line-reference.html#flag--incompatible_objc_compile_info_migration) flag to work correctly.

## Quick setup

Add the following to your `WORKSPACE` file to add the external repositories,
replacing the revision number in the `commit` attribute with the version of the
rules you wish to depend on:

```starlark
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "build_bazel_rules_apple",
    remote = "https://github.com/bazelbuild/rules_apple.git",
    commit = "[SOME_HASH_VALUE]",
)

git_repository(
    name = "build_bazel_rules_swift",
    remote = "https://github.com/bazelbuild/rules_swift.git",
    commit = "[SOME_HASH_VALUE]",
)

git_repository(
    name = "build_bazel_apple_support",
    remote = "https://github.com/bazelbuild/apple_support.git",
    commit = "[SOME_HASH_VALUE]",
)

git_repository(
    name = "rules_apple_line",
    remote = "https://github.com/line/rules_apple_line.git",
    commit = "[SOME_HASH_VALUE]",
)

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
    "@build_bazel_apple_support//lib:repositories.bzl",
    "apple_support_dependencies",
)

apple_support_dependencies()

load(
    "@rules_apple_line//apple:repositories.bzl",
    "rules_apple_line_dependencies",
)

# If you want to lock apple_support, rules_apple and rules_swift to specific
# versions, be sure to call this function after their repository rules.
rules_apple_line_dependencies()
```

## Examples

Minimal example:

```starlark
load("@rules_apple_line//apple:mixed_static_framework.bzl", "mixed_static_framework")

mixed_static_framework(
    name = "Mixed",
    srcs = glob([
        "**/*.m",
        "**/*.swift",
    ]),
    hdrs = glob([
        "**/*.h",
    ]),
)
```

See the [examples](examples) directory for more examples.

## License

```
Copyright 2020 LINE Corporation

LINE Corporation licenses this file to you under the Apache License,
version 2.0 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at:

   https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations
under the License.
```

See [LICENSE](LICENSE) for more detail.
