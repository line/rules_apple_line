# LINE's Apple rules for Bazel ![](https://github.com/line/bazel_rules_apple/workflows/build/badge.svg)

This repository contains additional rules for Bazel that can be used to bundle
applications for Apple platforms.

## Why?

[Bazel](http://bazel.build) is a build system with advanced support for local
and distributed caching. It has been adopted for many large and
complex software projects. It has been supporting building for Apple platforms
for a long time, and is being used at multiple companies to build fairly large
iOS apps.  However, due to the differences in conventions and assumptions
between how Bazel and Xcode build apps, the migration path from Xcode to Bazel
has not been very straightforward.  In most cases, to adopt Bazel for a typical
iOS project, you would have to do a lot of initial work, including but not
limited to: changing your code to follow Bazel's conventions, adding support
for header maps, adding support for mixed Swift & Objective-C modules, etc.

We have been going through many of those problems, and this repository is how
we are solving them.  We hope open-sourcing our implementation of these Bazel
rules could help more developers find it easier to adopt Bazel to build your
apps.

## Reference documentation

[Click here](docs) for the reference documentation for the rules and other
definitions in this repository.

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
    name = "com_linecorp_bazel_rules_apple",
    remote = "https://github.com/line/bazel_rules_apple.git",
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
    "@com_linecorp_bazel_rules_apple//apple:repositories.bzl",
    "linecorp_rules_apple_dependencies",
)

# If you want to lock apple_support, rules_apple and rules_swift to specific
# versions, be sure to call this function after their repository rules.
linecorp_rules_apple_dependencies()
```

## Examples

Minimal example:

```starlark
load("@com_linecorp_bazel_rules_apple//apple:mixed_static_framework.bzl", "mixed_static_framework")

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
