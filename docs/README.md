<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a name="#metal_library"></a>

## metal_library

<pre>
metal_library(<a href="#metal_library-name">name</a>, <a href="#metal_library-out">out</a>, <a href="#metal_library-srcs">srcs</a>)
</pre>

Compiles Metal Shading Language source code into a Metal library.

To use this rule in your BUILD files, load it with:

```starlark
load("@rules_apple_line//apple:metal_library.bzl", "metal_library")
```


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a name="metal_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a name="metal_library-out"></a>out |  An output <code>.metallib</code> filename. Defaults to <code>default.metallib</code> if unspecified.   | String | optional | "default.metallib" |
| <a name="metal_library-srcs"></a>srcs |  A list of <code>.metal</code> source files that will be compiled into the library.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |


<a name="#module_map"></a>

## module_map

<pre>
module_map(<a href="#module_map-name">name</a>, <a href="#module_map-add_to_provider">add_to_provider</a>, <a href="#module_map-deps">deps</a>, <a href="#module_map-hdrs">hdrs</a>, <a href="#module_map-module_name">module_name</a>, <a href="#module_map-textual_hdrs">textual_hdrs</a>)
</pre>

Generates a module map given a list of header files.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a name="module_map-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a name="module_map-add_to_provider"></a>add_to_provider |  Whether to add the generated module map to the returning provider. Targets imported via <code>apple_static_framework_import</code> or <code>apple_dynamic_framework_import</code> already have their module maps provided to swift_library targets depending on them. Set this to <code>False</code> in that case to avoid duplicate modules.   | Boolean | optional | True |
| <a name="module_map-deps"></a>deps |  The list of swift_library targets.  A <code>${module_name}.Swift</code> submodule will be generated if non-empty.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a name="module_map-hdrs"></a>hdrs |  The list of C, C++, Objective-C, and Objective-C++ header files used to construct the module map.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |
| <a name="module_map-module_name"></a>module_name |  The name of the module.   | String | required |  |
| <a name="module_map-textual_hdrs"></a>textual_hdrs |  The list of C, C++, Objective-C, and Objective-C++ header files used to construct the module map. Unlike hdrs, these will be declared as 'textual header' in the module map.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | optional | [] |


<a name="#objc_module_map_config"></a>

## objc_module_map_config

<pre>
objc_module_map_config(<a href="#objc_module_map_config-name">name</a>, <a href="#objc_module_map_config-deps">deps</a>, <a href="#objc_module_map_config-out">out</a>)
</pre>


Generates a Clang configuration file with all the `-fmodule-map-file` flags
for all direct and transitive module maps from dependencies.


**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a name="objc_module_map_config-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/docs/build-ref.html#name">Name</a> | required |  |
| <a name="objc_module_map_config-deps"></a>deps |  The dependencies from which to retrieve the list of module maps.   | <a href="https://bazel.build/docs/build-ref.html#labels">List of labels</a> | required |  |
| <a name="objc_module_map_config-out"></a>out |  The output filename of the Clang configuration file.   | <a href="https://bazel.build/docs/build-ref.html#labels">Label</a> | required |  |


<a name="#apple_library"></a>

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
| <a name="apple_library-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a name="#apple_preprocessed_plist"></a>

## apple_preprocessed_plist

<pre>
apple_preprocessed_plist(<a href="#apple_preprocessed_plist-name">name</a>, <a href="#apple_preprocessed_plist-src">src</a>, <a href="#apple_preprocessed_plist-out">out</a>, <a href="#apple_preprocessed_plist-substitutions">substitutions</a>, <a href="#apple_preprocessed_plist-kwargs">kwargs</a>)
</pre>



**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a name="apple_preprocessed_plist-name"></a>name |  <p align="center"> - </p>   |  none |
| <a name="apple_preprocessed_plist-src"></a>src |  <p align="center"> - </p>   |  none |
| <a name="apple_preprocessed_plist-out"></a>out |  <p align="center"> - </p>   |  none |
| <a name="apple_preprocessed_plist-substitutions"></a>substitutions |  <p align="center"> - </p>   |  none |
| <a name="apple_preprocessed_plist-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a name="#mixed_static_framework"></a>

## mixed_static_framework

<pre>
mixed_static_framework(<a href="#mixed_static_framework-name">name</a>, <a href="#mixed_static_framework-srcs">srcs</a>, <a href="#mixed_static_framework-non_arc_srcs">non_arc_srcs</a>, <a href="#mixed_static_framework-hdrs">hdrs</a>, <a href="#mixed_static_framework-textual_hdrs">textual_hdrs</a>, <a href="#mixed_static_framework-enable_modules">enable_modules</a>, <a href="#mixed_static_framework-includes">includes</a>,
                       <a href="#mixed_static_framework-copts">copts</a>, <a href="#mixed_static_framework-objc_copts">objc_copts</a>, <a href="#mixed_static_framework-swift_copts">swift_copts</a>, <a href="#mixed_static_framework-swiftc_inputs">swiftc_inputs</a>, <a href="#mixed_static_framework-objc_deps">objc_deps</a>, <a href="#mixed_static_framework-swift_deps">swift_deps</a>,
                       <a href="#mixed_static_framework-avoid_deps">avoid_deps</a>, <a href="#mixed_static_framework-deps">deps</a>, <a href="#mixed_static_framework-data">data</a>, <a href="#mixed_static_framework-umbrella_header">umbrella_header</a>, <a href="#mixed_static_framework-visibility">visibility</a>, <a href="#mixed_static_framework-minimum_os_version">minimum_os_version</a>,
                       <a href="#mixed_static_framework-kwargs">kwargs</a>)
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
| <a name="mixed_static_framework-name"></a>name |  A unique name for this target. This will be the name of the     library target that the framework depends on. The framework target     will be named <code>${name}Framework</code>.   |  none |
| <a name="mixed_static_framework-srcs"></a>srcs |  The list of Objective-C and Swift source files to compile.   |  none |
| <a name="mixed_static_framework-non_arc_srcs"></a>non_arc_srcs |  The Objective-C source files to compile that do not use     ARC. Provide both <code>srcs</code> and <code>non_arc_srcs</code> explicitly if both kinds     of source files should be included.   |  <code>[]</code> |
| <a name="mixed_static_framework-hdrs"></a>hdrs |  The list of C, C++, Objective-C, and Objective-C++ header files     published by this library to be included by sources in dependent     rules. These headers describe the public interface for the library     and will be made available for inclusion by sources in this rule or     in dependent rules. Headers not meant to be included by a client of     this library should be listed in the <code>srcs</code> attribute instead.  These     will be compiled separately from the source if modules are enabled.   |  <code>[]</code> |
| <a name="mixed_static_framework-textual_hdrs"></a>textual_hdrs |  The list of C, C++, Objective-C, and Objective-C++ files     that are included as headers by source files in this rule or by users     of this library. Unlike <code>hdrs</code>, these will not be compiled separately     from the sources.   |  <code>[]</code> |
| <a name="mixed_static_framework-enable_modules"></a>enable_modules |  Enables clang module support (via <code>-fmodules</code>).<br><br>    Note: This is <code>True</code> by default. Changing this to <code>False</code> might no     longer work. This attribute is here because there are still targets     which are referencing to it.   |  <code>True</code> |
| <a name="mixed_static_framework-includes"></a>includes |  List of header search paths to add to this target and all     depending targets. Unlike <code>copts</code>, these flags are added for this     rule and every rule that depends on it. (Note: not the rules it     depends upon!) Be very careful, since this may have far-reaching     effects. When in doubt, add "-iquote" flags to <code>copts</code> instead.<br><br>    Usage of this is rarely necessary because all headers will be visible     to their depended targets with the help of header maps.   |  <code>[]</code> |
| <a name="mixed_static_framework-copts"></a>copts |  Additional compiler options that should be passed to <code>clang</code> and     <code>swiftc</code>.   |  <code>[]</code> |
| <a name="mixed_static_framework-objc_copts"></a>objc_copts |  Additional compiler options that should be passed to <code>clang</code>.   |  <code>[]</code> |
| <a name="mixed_static_framework-swift_copts"></a>swift_copts |  Additional compiler options that should be passed to <code>swiftc</code>.   |  <code>[]</code> |
| <a name="mixed_static_framework-swiftc_inputs"></a>swiftc_inputs |  Additional files that are referenced using <code>$(rootpath     ...)</code> and <code>$(execpath ...)</code> in attributes that support location     expansion (e.g. <code>copts</code>).   |  <code>[]</code> |
| <a name="mixed_static_framework-objc_deps"></a>objc_deps |  Dependencies of the underlying <code>objc_library</code> target.   |  <code>[]</code> |
| <a name="mixed_static_framework-swift_deps"></a>swift_deps |  Dependencies of the underlying <code>swift_library</code> target.   |  <code>[]</code> |
| <a name="mixed_static_framework-avoid_deps"></a>avoid_deps |  A list of <code>objc_library</code> and <code>swift_library</code> targets on which     this framework depends in order to compile, but the transitive     closure of which will not be linked into the framework's binary. By     default this is the same as <code>deps</code>, that is none of the     depependencies will be linked into the framework's binary. For     example, providing an empty list (<code>[]</code>) here will result in a fully     static link binary.   |  <code>None</code> |
| <a name="mixed_static_framework-deps"></a>deps |  Dependencies of the both <code>objc_library</code> and <code>swift_library</code> targets.   |  <code>[]</code> |
| <a name="mixed_static_framework-data"></a>data |  The list of files needed by this rule at runtime. These will be     bundled to the top level directory of the bundling target (<code>.app</code> or     <code>.framework</code>).   |  <code>[]</code> |
| <a name="mixed_static_framework-umbrella_header"></a>umbrella_header |  An optional single <code>.h</code> file to use as the umbrella     header for this framework. Usually, this header will have the same name     as this target, so that clients can load the header using the #import     <code>&lt;MyFramework/MyFramework.h&gt;</code> format. If this attribute is not specified     (the common use case), an umbrella header will be generated under the     same name as this target.   |  <code>None</code> |
| <a name="mixed_static_framework-visibility"></a>visibility |  The visibility specifications for this target.   |  <code>["//visibility:public"]</code> |
| <a name="mixed_static_framework-minimum_os_version"></a>minimum_os_version |  <p align="center"> - </p>   |  <code>"11.0"</code> |
| <a name="mixed_static_framework-kwargs"></a>kwargs |  Additional arguments being passed through.   |  none |


<a name="#objc_library"></a>

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
| <a name="objc_library-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a name="#objc_static_framework"></a>

## objc_static_framework

<pre>
objc_static_framework(<a href="#objc_static_framework-name">name</a>, <a href="#objc_static_framework-srcs">srcs</a>, <a href="#objc_static_framework-non_arc_srcs">non_arc_srcs</a>, <a href="#objc_static_framework-hdrs">hdrs</a>, <a href="#objc_static_framework-archives">archives</a>, <a href="#objc_static_framework-deps">deps</a>, <a href="#objc_static_framework-avoid_deps">avoid_deps</a>, <a href="#objc_static_framework-data">data</a>, <a href="#objc_static_framework-module_name">module_name</a>,
                      <a href="#objc_static_framework-textual_hdrs">textual_hdrs</a>, <a href="#objc_static_framework-includes">includes</a>, <a href="#objc_static_framework-testonly">testonly</a>, <a href="#objc_static_framework-enable_modules">enable_modules</a>, <a href="#objc_static_framework-minimum_os_version">minimum_os_version</a>, <a href="#objc_static_framework-pch">pch</a>,
                      <a href="#objc_static_framework-visibility">visibility</a>, <a href="#objc_static_framework-umbrella_header">umbrella_header</a>, <a href="#objc_static_framework-kwargs">kwargs</a>)
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
| <a name="objc_static_framework-name"></a>name |  A unique name for this target. This will be the name of the     <code>objc_library</code> target that the framework depends on. The framework     target will be named <code>${name}Framework</code>.   |  none |
| <a name="objc_static_framework-srcs"></a>srcs |  The Objective-C source files to compile.   |  <code>[]</code> |
| <a name="objc_static_framework-non_arc_srcs"></a>non_arc_srcs |  The Objective-C source files to compile that do not use     ARC. Provide both <code>srcs</code> and <code>non_arc_srcs</code> explicitly if both kinds     of source files should be included.   |  <code>[]</code> |
| <a name="objc_static_framework-hdrs"></a>hdrs |  The list of C, C++, Objective-C, and Objective-C++ header files     published by this library to be included by sources in dependent     rules.  These headers describe the public interface for the library     and will be made available for inclusion by sources in this rule or     in dependent rules. Headers not meant to be included by a client of     this library should be listed in the <code>srcs</code> attribute instead.  These     will be compiled separately from the source if modules are enabled.   |  <code>[]</code> |
| <a name="objc_static_framework-archives"></a>archives |  The list of <code>.a</code> files provided to Objective-C targets that     depend on this target.   |  <code>[]</code> |
| <a name="objc_static_framework-deps"></a>deps |  Dependencies of the <code>objc_library</code> target being compiled.   |  <code>[]</code> |
| <a name="objc_static_framework-avoid_deps"></a>avoid_deps |  A list of <code>objc_library</code> and <code>swift_library</code> targets on which     this framework depends in order to compile, but you don't want to link to     the framework binary. Defaults to <code>deps</code> if not specified.   |  <code>None</code> |
| <a name="objc_static_framework-data"></a>data |  The list of files needed by this rule at runtime. These will be     bundled to the top level directory of the bundling target (<code>.app</code> or     <code>.framework</code>).   |  <code>[]</code> |
| <a name="objc_static_framework-module_name"></a>module_name |  The name of the module being built. If not     provided, the <code>name</code> is used.   |  <code>None</code> |
| <a name="objc_static_framework-textual_hdrs"></a>textual_hdrs |  The list of C, C++, Objective-C, and Objective-C++ files     that are included as headers by source files in this rule or by users     of this library. Unlike <code>hdrs</code>, these will not be compiled separately     from the sources.   |  <code>[]</code> |
| <a name="objc_static_framework-includes"></a>includes |  List of header search paths to add to this target and all     depending targets. Unlike <code>copts</code>, these flags are added for this     rule and every rule that depends on it. (Note: not the rules it     depends upon!) Be very careful, since this may have far-reaching     effects. When in doubt, add "-iquote" flags to <code>copts</code> instead.   |  <code>[]</code> |
| <a name="objc_static_framework-testonly"></a>testonly |  If <code>True</code>, only testonly targets (such as tests) can depend     on the <code>objc_library</code> target. The default is <code>False</code>.   |  <code>False</code> |
| <a name="objc_static_framework-enable_modules"></a>enable_modules |  Enables clang module support (via <code>-fmodules</code>). Setting     this to <code>True</code> will allow you to @import system headers and other     targets).   |  <code>False</code> |
| <a name="objc_static_framework-minimum_os_version"></a>minimum_os_version |  The minimum OS version supported by the framework.   |  <code>"11.0"</code> |
| <a name="objc_static_framework-pch"></a>pch |  Header file to prepend to every source file being compiled (both arc     and non-arc). Use of pch files is actively discouraged in BUILD files,     and this should be considered deprecated. Since pch files are not     actually precompiled this is not a build-speed enhancement, and instead     is just a global dependency. From a build efficiency point of view you     are actually better including what you need directly in your sources     where you need it.   |  <code>None</code> |
| <a name="objc_static_framework-visibility"></a>visibility |  The visibility specifications for this target.   |  <code>["//visibility:public"]</code> |
| <a name="objc_static_framework-umbrella_header"></a>umbrella_header |  An optional single <code>.h</code> file to use as the umbrella     header for this framework. Usually, this header will have the same name     as this target, so that clients can load the header using the #import     &lt;MyFramework/MyFramework.h&gt; format. If this attribute is not specified     (the common use case), an umbrella header will be generated under the     same name as this target.   |  <code>None</code> |
| <a name="objc_static_framework-kwargs"></a>kwargs |  Additional arguments being passed through to the underlying     <code>objc_library</code> rule.   |  none |


<a name="#swift_library"></a>

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
| <a name="swift_library-kwargs"></a>kwargs |  <p align="center"> - </p>   |  none |


<a name="#swift_static_framework"></a>

## swift_static_framework

<pre>
swift_static_framework(<a href="#swift_static_framework-name">name</a>, <a href="#swift_static_framework-srcs">srcs</a>, <a href="#swift_static_framework-copts">copts</a>, <a href="#swift_static_framework-swiftc_inputs">swiftc_inputs</a>, <a href="#swift_static_framework-deps">deps</a>, <a href="#swift_static_framework-avoid_deps">avoid_deps</a>, <a href="#swift_static_framework-data">data</a>, <a href="#swift_static_framework-visibility">visibility</a>,
                       <a href="#swift_static_framework-minimum_os_version">minimum_os_version</a>, <a href="#swift_static_framework-kwargs">kwargs</a>)
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
| <a name="swift_static_framework-name"></a>name |  A unique name for this target. This will be the name of the     library target that the framework depends on. The framework target     will be named <code>${name}Framework</code>.   |  none |
| <a name="swift_static_framework-srcs"></a>srcs |  The list of Swift source files to compile.   |  none |
| <a name="swift_static_framework-copts"></a>copts |  Additional compiler options that should be passed to <code>swiftc</code>.   |  <code>[]</code> |
| <a name="swift_static_framework-swiftc_inputs"></a>swiftc_inputs |  Additional files that are referenced using <code>$(rootpath     ...)</code> and <code>$(execpath ...)</code> in attributes that support location     expansion (e.g. <code>copts</code>).   |  <code>[]</code> |
| <a name="swift_static_framework-deps"></a>deps |  A list of targets that are dependencies of the target being built.     Note that, by default, none of these and all of their transitive     dependencies will be linked into the final binary when building the     <code>${name}Framework</code> target.   |  <code>[]</code> |
| <a name="swift_static_framework-avoid_deps"></a>avoid_deps |  A list of <code>objc_library</code> and <code>swift_library</code> targets on which     this framework depends in order to compile, but the transitive     closure of which will not be linked into the framework's binary. By     default this is the same as <code>deps</code>, that is none of the     depependencies will be linked into the framework's binary. For     example, providing an empty list (<code>[]</code>) here will result in a fully     static link binary.   |  <code>None</code> |
| <a name="swift_static_framework-data"></a>data |  The list of files needed by this rule at runtime. These will be     bundled to the top level directory of the bundling target (<code>.app</code> or     <code>.framework</code>).   |  <code>[]</code> |
| <a name="swift_static_framework-visibility"></a>visibility |  The visibility specifications for this target.   |  <code>["//visibility:public"]</code> |
| <a name="swift_static_framework-minimum_os_version"></a>minimum_os_version |  <p align="center"> - </p>   |  <code>"11.0"</code> |
| <a name="swift_static_framework-kwargs"></a>kwargs |  Additional arguments being passed through.   |  none |


