# LINE's Apple rules for Bazel ![](https://github.com/line/bazel_rules_apple/workflows/build/badge.svg)

This repository contains additional rules for Bazel that can be used to bundle
applications and frameworks for Apple platforms.

## Overview

[Bazel](http://bazel.build)'s official rules for Apple platforms lack many of
the features that are conventionally important in the Apple community in
general, notably: supports for header maps, Clang modules and mixed language
targets. This repository implements those features and exposes them as drop-in
replacements for the official Apple rules.

These are open references of what are used to build the LINE iOS app. They may
not work with certain revisions of `rules_apple` or `rules_swift` due to
their breaking changes. If they don't work out-of-the-box for you, use them as
references for your custom rule's implementation.

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
* [pkg_dsym](docs/README.md#pkg_dsym)
* [swiftgen](docs/README.md#swiftgen)

## Requirements

Bazel 4.0+

## Setup

- Setup [rules_apple](https://github.com/bazelbuild/rules_apple#quick-setup).

- Add the following to your `WORKSPACE` file, replacing `<commit>` with the
  commit you wish to depend on and `<sha256>` with the expected SHA-256 of the
  zip file.

```starlark
RULES_APPLE_LINE_COMMIT = "<commit>"

http_archive(
    name = "rules_apple_line",
    sha256 = "<sha256>",
    strip_prefix = "rules_apple_line-%s" % RULES_APPLE_LINE_COMMIT,
    url = "https://github.com/line/rules_apple_line/archive/%s.zip" % RULES_APPLE_LINE_COMMIT,
)

load(
    "@rules_apple_line//apple:repositories.bzl",
    "rules_apple_line_dependencies",
)

rules_apple_line_dependencies()
```

## Examples

See the [examples](examples) directory.

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
