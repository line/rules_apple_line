<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#apple_linker_inputs"></a>

## apple_linker_inputs

<pre>
apple_linker_inputs(<a href="#apple_linker_inputs-name">name</a>, <a href="#apple_linker_inputs-linker_inputs">linker_inputs</a>, <a href="#apple_linker_inputs-linkopts">linkopts</a>)
</pre>


Provides additional inputs to Apple rules' linker action.

Unlike C++ rules like `cc_binary` and `cc_test`, Apple rules don't have any
mechanism to allow providing additional inputs to the linker action. This
little rule helps mitigate that.

To use this rule in your BUILD files, load it with:

```starlark
load("@rules_apple_line//apple:apple_linker_inputs.bzl", "apple_linker_inputs")
```


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="apple_linker_inputs-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="apple_linker_inputs-linker_inputs"></a>linker_inputs |  Extra files to be passed to the linker action.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="apple_linker_inputs-linkopts"></a>linkopts |  Extra flags to be passed to Clang's linker command. Subject to ["Make" variable](https://docs.bazel.build/versions/master/be/make-variables.html) substitution and [label expansion](https://docs.bazel.build/versions/master/be/common-definitions.html#label-expansion).   | List of strings | optional | [] |


<a id="#metal_library"></a>

## metal_library

<pre>
metal_library(<a href="#metal_library-name">name</a>, <a href="#metal_library-hdrs">hdrs</a>, <a href="#metal_library-includes">includes</a>, <a href="#metal_library-out">out</a>, <a href="#metal_library-srcs">srcs</a>)
</pre>

Compiles Metal Shading Language source code into a Metal library.
To use this rule in your BUILD files, load it with:
```starlark
load("@rules_apple_line//apple:metal_library.bzl", "metal_library")
```


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="metal_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="metal_library-hdrs"></a>hdrs |  A list of headers that you need import to metal source.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="metal_library-includes"></a>includes |  A list of header search paths.   | List of strings | optional | [] |
| <a id="metal_library-out"></a>out |  An output <code>.metallib</code> filename. Defaults to <code>default.metallib</code> if unspecified.   | String | optional | "default.metallib" |
| <a id="metal_library-srcs"></a>srcs |  A list of <code>.metal</code> source files that will be compiled into the library.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |


<a id="#pkg_dsym"></a>

## pkg_dsym

<pre>
pkg_dsym(<a href="#pkg_dsym-name">name</a>, <a href="#pkg_dsym-mode">mode</a>, <a href="#pkg_dsym-out">out</a>, <a href="#pkg_dsym-srcs">srcs</a>, <a href="#pkg_dsym-timestamp">timestamp</a>)
</pre>

Creates a `.dSYM.zip` file given targets that produce dSYMs.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="pkg_dsym-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="pkg_dsym-mode"></a>mode |  Set the mode of files added by the <code>srcs</code> attribute.   | String | optional | "0555" |
| <a id="pkg_dsym-out"></a>out |  The output filename.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | optional |  |
| <a id="pkg_dsym-srcs"></a>srcs |  A list of executable targets that produce dSYM, and/or a list of imported dSYMs if they're prebuilt.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a id="pkg_dsym-timestamp"></a>timestamp |  The time to use for every file in the zip, expressed as seconds since Unix Epoch, RFC 3339.<br><br>Due to limitations in the format of zip files, values before Jan 1, 1980 will be rounded up and the precision in the zip file is limited to a granularity of 2 seconds.   | Integer | optional | 315532800 |


<a id="#swiftgen"></a>

## swiftgen

<pre>
swiftgen(<a href="#swiftgen-name">name</a>, <a href="#swiftgen-out">out</a>, <a href="#swiftgen-srcs">srcs</a>, <a href="#swiftgen-template_file">template_file</a>, <a href="#swiftgen-template_params">template_params</a>)
</pre>

Generates Swift code from the given resource files.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="swiftgen-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a id="swiftgen-out"></a>out |  The output Swift filename.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="swiftgen-srcs"></a>srcs |  The list of input resource files.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |
| <a id="swiftgen-template_file"></a>template_file |  The template file which will be used to generate Swift code.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |
| <a id="swiftgen-template_params"></a>template_params |  An optional dictionary of parameters that you want to pass to the template.   | <a href="https://bazel.build/docs/skylark/lib/dict.html">Dictionary: String -> String</a> | optional | {} |


<a id="#apple_library"></a>

## apple_library

<pre>
apple_library(<a href="#apple_library-kwargs">kwargs</a>)
</pre>

Compiles and links Objective-C and Swift code into a static library.

To use this rule in your BUILD files, load it with:

```starlark
load("@rules_apple_line//apple:apple_library.bzl", "apple_library")
```

See [mixed_static_framework](#mixed_static_framework) for the documentation
of each attribute.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="apple_library-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="#apple_preprocessed_plist"></a>

## apple_preprocessed_plist

<pre>
apple_preprocessed_plist(<a href="#apple_preprocessed_plist-name">name</a>, <a href="#apple_preprocessed_plist-src">src</a>, <a href="#apple_preprocessed_plist-out">out</a>, <a href="#apple_preprocessed_plist-substitutions">substitutions</a>, <a href="#apple_preprocessed_plist-kwargs">kwargs</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="apple_preprocessed_plist-name"></a>name |  <p align="center"> - </p>   |  none |
| <a id="apple_preprocessed_plist-src"></a>src |  <p align="center"> - </p>   |  none |
| <a id="apple_preprocessed_plist-out"></a>out |  <p align="center"> - </p>   |  none |
| <a id="apple_preprocessed_plist-substitutions"></a>substitutions |  <p align="center"> - </p>   |  none |
| <a id="apple_preprocessed_plist-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="#mixed_static_framework"></a>

## mixed_static_framework

<pre>
mixed_static_framework(<a href="#mixed_static_framework-name">name</a>, <a href="#mixed_static_framework-srcs">srcs</a>, <a href="#mixed_static_framework-non_arc_srcs">non_arc_srcs</a>, <a href="#mixed_static_framework-hdrs">hdrs</a>, <a href="#mixed_static_framework-textual_hdrs">textual_hdrs</a>, <a href="#mixed_static_framework-enable_modules">enable_modules</a>, <a href="#mixed_static_framework-includes">includes</a>,
                       <a href="#mixed_static_framework-copts">copts</a>, <a href="#mixed_static_framework-objc_copts">objc_copts</a>, <a href="#mixed_static_framework-swift_copts">swift_copts</a>, <a href="#mixed_static_framework-use_defines">use_defines</a>, <a href="#mixed_static_framework-swiftc_inputs">swiftc_inputs</a>, <a href="#mixed_static_framework-objc_deps">objc_deps</a>,
                       <a href="#mixed_static_framework-swift_deps">swift_deps</a>, <a href="#mixed_static_framework-avoid_deps">avoid_deps</a>, <a href="#mixed_static_framework-deps">deps</a>, <a href="#mixed_static_framework-data">data</a>, <a href="#mixed_static_framework-umbrella_header">umbrella_header</a>, <a href="#mixed_static_framework-visibility">visibility</a>,
                       <a href="#mixed_static_framework-minimum_os_version">minimum_os_version</a>, <a href="#mixed_static_framework-features">features</a>, <a href="#mixed_static_framework-kwargs">kwargs</a>)
</pre>

Builds and bundles a static framework for Xcode consumption or third-party distribution.

This supports Swift only targets and mixed language targets. If your target
only contains Objective-C source code, use `objc_static_framework` rule
instead.

This rule in general is very similar to `build_bazel_rules_apple`'s
`ios_static_framework` rule, with some differences:

* It supports Swift as well as mixed Objective-C and Swift targets.
* It supports bundling a swift_library target that depend transitively on
    any other swift_library targets. By default, it will not link any of
    its dependencies into the final framework binary - the same way Xcode
    does when it builds frameworks - which means you can prebuild your
    dependencies as static frameworks for Xcode consumption.
* It supports header maps out of the box--you don't need to change your
    imports to make your code build with Bazel.
* It always collects the Swift generated header and bundles a
    `module.modulemap` file. For a mixed language target, the module map
    file is an extended module map.
* It bundles `swiftmodule` and `swiftdoc` files (`ios_static_framework`
    rule bundles `swiftinterface` instead of `swiftmodule` file).

This rule uses the native `objc_library` rule and `rules_swift`'s
`swift_library` in its implementation. Even if you're not building a static
framework for Xcode consumption or third-party distribution, this can still
be used as a convenient way to declare a library target that compiles mixed
Objective-C and Swift source code.

The macro contains 3 underlying rules--given `name` is `Greet`:

* `Greet_swift`: a `swift_library` target. This target has private
    visibility by default, hence it can't be a dependency of any other
    target. It should not be used directly.
* `GreetModule`: a `module_map` target. This has the same visibility as
    `Greet`. The common use-case is using it in an `objc_library`'s
    `copts` attribute to import the generated module map file (e.g.
    `-fmodule-map-file=$(execpath //path/to/package:GreetModule)`). This
    will be done automatically if the dependent target is also a
    `mixed_static_framework` target.
* `Greet`: an `objc_library` target. This is the wrapper library target.
    This can be depended on any `objc_library` or `swift_library` target.

### Examples

```starlark
load("@rules_apple_line//apple:mixed_static_framework.bzl", "mixed_static_framework")

mixed_static_framework(
    name = "Mixed",
    srcs = glob([
        "*.m",
        "*.swift",
    ]),
    hdrs = glob(["*.h"]),
)
```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="mixed_static_framework-name"></a>name |  A unique name for this target. This will be the name of the     library target that the framework depends on. The framework target     will be named <code>${name}Framework</code>.   |  none |
| <a id="mixed_static_framework-srcs"></a>srcs |  The list of Objective-C and Swift source files to compile.   |  none |
| <a id="mixed_static_framework-non_arc_srcs"></a>non_arc_srcs |  The Objective-C source files to compile that do not use     ARC. Provide both <code>srcs</code> and <code>non_arc_srcs</code> explicitly if both kinds     of source files should be included.   |  <code>[]</code> |
| <a id="mixed_static_framework-hdrs"></a>hdrs |  The list of C, C++, Objective-C, and Objective-C++ header files     published by this library to be included by sources in dependent     rules. These headers describe the public interface for the library     and will be made available for inclusion by sources in this rule or     in dependent rules. Headers not meant to be included by a client of     this library should be listed in the <code>srcs</code> attribute instead.  These     will be compiled separately from the source if modules are enabled.   |  <code>[]</code> |
| <a id="mixed_static_framework-textual_hdrs"></a>textual_hdrs |  The list of C, C++, Objective-C, and Objective-C++ files     that are included as headers by source files in this rule or by users     of this library. Unlike <code>hdrs</code>, these will not be compiled separately     from the sources.   |  <code>[]</code> |
| <a id="mixed_static_framework-enable_modules"></a>enable_modules |  Enables clang module support (via <code>-fmodules</code>).<br><br>    Note: This is <code>True</code> by default. Changing this to <code>False</code> might no     longer work. This attribute is here because there are still targets     which are referencing to it.   |  <code>True</code> |
| <a id="mixed_static_framework-includes"></a>includes |  List of header search paths to add to this target and all     depending targets. Unlike <code>copts</code>, these flags are added for this     rule and every rule that depends on it. (Note: not the rules it     depends upon!) Be very careful, since this may have far-reaching     effects. When in doubt, add "-iquote" flags to <code>copts</code> instead.<br><br>    Usage of this is rarely necessary because all headers will be visible     to their depended targets with the help of header maps.   |  <code>[]</code> |
| <a id="mixed_static_framework-copts"></a>copts |  Additional compiler options that should be passed to <code>clang</code> and     <code>swiftc</code>.   |  <code>[]</code> |
| <a id="mixed_static_framework-objc_copts"></a>objc_copts |  Additional compiler options that should be passed to <code>clang</code>.   |  <code>[]</code> |
| <a id="mixed_static_framework-swift_copts"></a>swift_copts |  Additional compiler options that should be passed to <code>swiftc</code>.   |  <code>[]</code> |
| <a id="mixed_static_framework-use_defines"></a>use_defines |  <p align="center"> - </p>   |  <code>None</code> |
| <a id="mixed_static_framework-swiftc_inputs"></a>swiftc_inputs |  Additional files that are referenced using <code>$(rootpath     ...)</code> and <code>$(execpath ...)</code> in attributes that support location     expansion (e.g. <code>copts</code>).   |  <code>[]</code> |
| <a id="mixed_static_framework-objc_deps"></a>objc_deps |  Dependencies of the underlying <code>objc_library</code> target.   |  <code>[]</code> |
| <a id="mixed_static_framework-swift_deps"></a>swift_deps |  Dependencies of the underlying <code>swift_library</code> target.   |  <code>[]</code> |
| <a id="mixed_static_framework-avoid_deps"></a>avoid_deps |  A list of <code>objc_library</code> and <code>swift_library</code> targets on which     this framework depends in order to compile, but the transitive     closure of which will not be linked into the framework's binary. By     default this is the same as <code>deps</code>, that is none of the     depependencies will be linked into the framework's binary. For     example, providing an empty list (<code>[]</code>) here will result in a fully     static link binary.   |  <code>None</code> |
| <a id="mixed_static_framework-deps"></a>deps |  Dependencies of the both <code>objc_library</code> and <code>swift_library</code> targets.   |  <code>[]</code> |
| <a id="mixed_static_framework-data"></a>data |  The list of files needed by this rule at runtime. These will be     bundled to the top level directory of the bundling target (<code>.app</code> or     <code>.framework</code>).   |  <code>[]</code> |
| <a id="mixed_static_framework-umbrella_header"></a>umbrella_header |  An optional single <code>.h</code> file to use as the umbrella     header for this framework. Usually, this header will have the same name     as this target, so that clients can load the header using the #import     <code>&lt;MyFramework/MyFramework.h&gt;</code> format. If this attribute is not specified     (the common use case), an umbrella header will be generated under the     same name as this target.   |  <code>None</code> |
| <a id="mixed_static_framework-visibility"></a>visibility |  The visibility specifications for this target.   |  <code>["//visibility:public"]</code> |
| <a id="mixed_static_framework-minimum_os_version"></a>minimum_os_version |  Minimum os version.   |  <code>"11.0"</code> |
| <a id="mixed_static_framework-features"></a>features |  Features of the underlying <code>swift_library</code> target.   |  <code>[]</code> |
| <a id="mixed_static_framework-kwargs"></a>kwargs |  Additional arguments being passed through.   |  none |


<a id="#objc_library"></a>

## objc_library

<pre>
objc_library(<a href="#objc_library-kwargs">kwargs</a>)
</pre>

Produces a static library from the given Objective-C source files.

A drop-in replacement of the native
[objc_library](https://docs.bazel.build/versions/3.2.0/be/objective-c.html#objc_library)
rule, with added supports for header maps and modules.

To use this rule in your BUILD files, load it with:

```starlark
load("@rules_apple_line//apple:objc_library.bzl", "objc_library")
```

See [objc_static_framework](#objc_static_framework) for the documentation
of each attribute.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="objc_library-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="#objc_static_framework"></a>

## objc_static_framework

<pre>
objc_static_framework(<a href="#objc_static_framework-name">name</a>, <a href="#objc_static_framework-srcs">srcs</a>, <a href="#objc_static_framework-non_arc_srcs">non_arc_srcs</a>, <a href="#objc_static_framework-hdrs">hdrs</a>, <a href="#objc_static_framework-archives">archives</a>, <a href="#objc_static_framework-deps">deps</a>, <a href="#objc_static_framework-avoid_deps">avoid_deps</a>, <a href="#objc_static_framework-data">data</a>, <a href="#objc_static_framework-use_defines">use_defines</a>,
                      <a href="#objc_static_framework-module_name">module_name</a>, <a href="#objc_static_framework-textual_hdrs">textual_hdrs</a>, <a href="#objc_static_framework-includes">includes</a>, <a href="#objc_static_framework-testonly">testonly</a>, <a href="#objc_static_framework-enable_modules">enable_modules</a>,
                      <a href="#objc_static_framework-minimum_os_version">minimum_os_version</a>, <a href="#objc_static_framework-pch">pch</a>, <a href="#objc_static_framework-visibility">visibility</a>, <a href="#objc_static_framework-umbrella_header">umbrella_header</a>, <a href="#objc_static_framework-kwargs">kwargs</a>)
</pre>

Builds and bundles a Objective-C static framework for Xcode consumption or third-party distribution.

This rule in general is very similar to `build_bazel_rules_apple`'s
`ios_static_framework` rule, with support for modules and header maps out
of the box--which means you don't need to change your imports to make your
code build with Bazel. Note that, unlike `build_bazel_rules_apple`'s
`ios_static_framework`, by default, it will not link any of its
dependencies into the final framework binary - the same way Xcode does when
it builds frameworks.


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="objc_static_framework-name"></a>name |  A unique name for this target. This will be the name of the     <code>objc_library</code> target that the framework depends on. The framework     target will be named <code>${name}Framework</code>.   |  none |
| <a id="objc_static_framework-srcs"></a>srcs |  The Objective-C source files to compile.   |  <code>[]</code> |
| <a id="objc_static_framework-non_arc_srcs"></a>non_arc_srcs |  The Objective-C source files to compile that do not use     ARC. Provide both <code>srcs</code> and <code>non_arc_srcs</code> explicitly if both kinds     of source files should be included.   |  <code>[]</code> |
| <a id="objc_static_framework-hdrs"></a>hdrs |  The list of C, C++, Objective-C, and Objective-C++ header files     published by this library to be included by sources in dependent     rules.  These headers describe the public interface for the library     and will be made available for inclusion by sources in this rule or     in dependent rules. Headers not meant to be included by a client of     this library should be listed in the <code>srcs</code> attribute instead.  These     will be compiled separately from the source if modules are enabled.   |  <code>[]</code> |
| <a id="objc_static_framework-archives"></a>archives |  The list of <code>.a</code> files provided to Objective-C targets that     depend on this target.   |  <code>[]</code> |
| <a id="objc_static_framework-deps"></a>deps |  Dependencies of the <code>objc_library</code> target being compiled.   |  <code>[]</code> |
| <a id="objc_static_framework-avoid_deps"></a>avoid_deps |  A list of <code>objc_library</code> and <code>swift_library</code> targets on which     this framework depends in order to compile, but you don't want to link to     the framework binary. Defaults to <code>deps</code> if not specified.   |  <code>None</code> |
| <a id="objc_static_framework-data"></a>data |  The list of files needed by this rule at runtime. These will be     bundled to the top level directory of the bundling target (<code>.app</code> or     <code>.framework</code>).   |  <code>[]</code> |
| <a id="objc_static_framework-use_defines"></a>use_defines |  <p align="center"> - </p>   |  <code>None</code> |
| <a id="objc_static_framework-module_name"></a>module_name |  The name of the module being built. If not     provided, the <code>name</code> is used.   |  <code>None</code> |
| <a id="objc_static_framework-textual_hdrs"></a>textual_hdrs |  The list of C, C++, Objective-C, and Objective-C++ files     that are included as headers by source files in this rule or by users     of this library. Unlike <code>hdrs</code>, these will not be compiled separately     from the sources.   |  <code>[]</code> |
| <a id="objc_static_framework-includes"></a>includes |  List of header search paths to add to this target and all     depending targets. Unlike <code>copts</code>, these flags are added for this     rule and every rule that depends on it. (Note: not the rules it     depends upon!) Be very careful, since this may have far-reaching     effects. When in doubt, add "-iquote" flags to <code>copts</code> instead.   |  <code>[]</code> |
| <a id="objc_static_framework-testonly"></a>testonly |  If <code>True</code>, only testonly targets (such as tests) can depend     on the <code>objc_library</code> target. The default is <code>False</code>.   |  <code>False</code> |
| <a id="objc_static_framework-enable_modules"></a>enable_modules |  Enables clang module support (via <code>-fmodules</code>). Setting     this to <code>True</code> will allow you to @import system headers and other     targets).   |  <code>False</code> |
| <a id="objc_static_framework-minimum_os_version"></a>minimum_os_version |  The minimum OS version supported by the framework.   |  <code>"11.0"</code> |
| <a id="objc_static_framework-pch"></a>pch |  Header file to prepend to every source file being compiled (both arc     and non-arc). Use of pch files is actively discouraged in BUILD files,     and this should be considered deprecated. Since pch files are not     actually precompiled this is not a build-speed enhancement, and instead     is just a global dependency. From a build efficiency point of view you     are actually better including what you need directly in your sources     where you need it.   |  <code>None</code> |
| <a id="objc_static_framework-visibility"></a>visibility |  The visibility specifications for this target.   |  <code>["//visibility:public"]</code> |
| <a id="objc_static_framework-umbrella_header"></a>umbrella_header |  An optional single <code>.h</code> file to use as the umbrella     header for this framework. Usually, this header will have the same name     as this target, so that clients can load the header using the #import     &lt;MyFramework/MyFramework.h&gt; format. If this attribute is not specified     (the common use case), an umbrella header will be generated under the     same name as this target.   |  <code>None</code> |
| <a id="objc_static_framework-kwargs"></a>kwargs |  Additional arguments being passed through to the underlying     <code>objc_library</code> rule.   |  none |


<a id="#swift_library"></a>

## swift_library

<pre>
swift_library(<a href="#swift_library-kwargs">kwargs</a>)
</pre>

Compiles and links Swift code into a static library and Swift module.

A drop-in replacement of the official
[swift_library](https://github.com/bazelbuild/rules_swift/blob/master/doc/rules.md#swift_library)
rule, with added supports for header maps, and better integration with other
rules in this repository.

To use this rule in your BUILD files, load it with:

```starlark
load("@rules_apple_line//apple:swift_library.bzl", "swift_library")
```

See [swift_static_framework](#swift_static_framework) for the documentation
of each attribute.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="swift_library-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a id="#swift_static_framework"></a>

## swift_static_framework

<pre>
swift_static_framework(<a href="#swift_static_framework-name">name</a>, <a href="#swift_static_framework-srcs">srcs</a>, <a href="#swift_static_framework-copts">copts</a>, <a href="#swift_static_framework-use_defines">use_defines</a>, <a href="#swift_static_framework-swiftc_inputs">swiftc_inputs</a>, <a href="#swift_static_framework-deps">deps</a>, <a href="#swift_static_framework-avoid_deps">avoid_deps</a>, <a href="#swift_static_framework-data">data</a>,
                       <a href="#swift_static_framework-visibility">visibility</a>, <a href="#swift_static_framework-minimum_os_version">minimum_os_version</a>, <a href="#swift_static_framework-features">features</a>, <a href="#swift_static_framework-kwargs">kwargs</a>)
</pre>

Builds and bundles a Swift static framework for Xcode consumption or third-party distribution.

This rule in general is very similar to `build_bazel_rules_apple`'s
`ios_static_framework` rule, with some differences:

* It supports bundling a swift_library target that depend transitively on
    any other swift_library targets. By default, it will not link any of
    its dependencies into the final framework binary - the same way Xcode
    does when it builds frameworks - which means you can prebuild your
    dependencies as static frameworks for Xcode consumption.
* It supports header maps out of the box--you don't need to change your
    imports to make your code build with Bazel.
* It always collects the Swift generated header and bundles a
    `module.modulemap` file.
* It bundles `swiftmodule` and `swiftdoc` files (`ios_static_framework`
    rule bundles `swiftinterface` instead of `swiftmodule` file).

Under the hood, this uses an `objc_library` target to wrap a
`swift_library` target -- so by a sense, it's still a mixed Obj-C and Swift
target - to make use of `objc_library`'s configuration transition.

### Examples

```starlark
load("@rules_apple_line//apple:swift_static_framework.bzl", "swift_static_framework")

swift_static_framework(
    name = "MyLibrary",
    srcs = glob(["**/*.swift"]),
)
```


**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="swift_static_framework-name"></a>name |  A unique name for this target. This will be the name of the     library target that the framework depends on. The framework target     will be named <code>${name}Framework</code>.   |  none |
| <a id="swift_static_framework-srcs"></a>srcs |  The list of Swift source files to compile.   |  none |
| <a id="swift_static_framework-copts"></a>copts |  Additional compiler options that should be passed to <code>swiftc</code>.   |  <code>[]</code> |
| <a id="swift_static_framework-use_defines"></a>use_defines |  <p align="center"> - </p>   |  <code>None</code> |
| <a id="swift_static_framework-swiftc_inputs"></a>swiftc_inputs |  Additional files that are referenced using <code>$(rootpath     ...)</code> and <code>$(execpath ...)</code> in attributes that support location     expansion (e.g. <code>copts</code>).   |  <code>[]</code> |
| <a id="swift_static_framework-deps"></a>deps |  A list of targets that are dependencies of the target being built.     Note that, by default, none of these and all of their transitive     dependencies will be linked into the final binary when building the     <code>${name}Framework</code> target.   |  <code>[]</code> |
| <a id="swift_static_framework-avoid_deps"></a>avoid_deps |  A list of <code>objc_library</code> and <code>swift_library</code> targets on which     this framework depends in order to compile, but the transitive     closure of which will not be linked into the framework's binary. By     default this is the same as <code>deps</code>, that is none of the     depependencies will be linked into the framework's binary. For     example, providing an empty list (<code>[]</code>) here will result in a fully     static link binary.   |  <code>None</code> |
| <a id="swift_static_framework-data"></a>data |  The list of files needed by this rule at runtime. These will be     bundled to the top level directory of the bundling target (<code>.app</code> or     <code>.framework</code>).   |  <code>[]</code> |
| <a id="swift_static_framework-visibility"></a>visibility |  The visibility specifications for this target.   |  <code>["//visibility:public"]</code> |
| <a id="swift_static_framework-minimum_os_version"></a>minimum_os_version |  <p align="center"> - </p>   |  <code>"11.0"</code> |
| <a id="swift_static_framework-features"></a>features |  Features of the underlying <code>swift_library</code> target.   |  <code>[]</code> |
| <a id="swift_static_framework-kwargs"></a>kwargs |  Additional arguments being passed through.   |  none |


