def _clang_config_file_content(module_maps):
    """Returns the contents of a Clang configuration file given a depset of module maps."""

    content = ""
    for map in module_maps.to_list():
        path = map.path

        # Ignore module maps from the prebuilt frameworks. These are redundant
        # because those frameworks are already being imported via the framework
        # search paths flag (`-F`).
        if ".framework" in path:
            continue

        # Ignore the auto-generated module maps by Bazel. We use our
        # `module_map` rule to generate module maps instead of relying on
        # Bazel's autogerated ones (they are only generated when being directly
        # depended on a `swift_library` target, which is uncontrollable).
        # Bazel's auto-generated module maps follow the naming convention
        # `target_name.modulemaps/module.modulemap`.
        if ".modulemaps" in path:
            continue

        content += "-fmodule-map-file="
        content += path
        content += "\n"
    return content

def _get_transitive_module_maps(deps):
    """Returns a [depset](https://docs.bazel.build/versions/3.1.0/skylark/depsets.html) of transitive module maps given a depset of transitive dependencies.

    Args:
        deps: The cc_library, objc_library and swift_library dependencies.
    Returns:
        A depset of transitive module maps.
    """
    return depset(
        transitive = [
            dep[apple_common.Objc].module_map
            for dep in deps
            if apple_common.Objc in dep
        ],
    )

def _objc_module_map_config_impl(ctx):
    all_module_maps = _get_transitive_module_maps(ctx.attr.deps)
    output = ctx.outputs.out
    ctx.actions.write(
        content = _clang_config_file_content(all_module_maps),
        output = output,
    )

    return struct(
        providers = [
            DefaultInfo(
                files = depset([output]),
            ),
            apple_common.new_objc_provider(
                module_map = all_module_maps,
            ),
        ],
    )

objc_module_map_config = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "The dependencies from which to retrieve the list of module maps.",
            mandatory = True,
            providers = [CcInfo],
        ),
        "out": attr.output(
            doc = "The output filename of the Clang configuration file.",
            mandatory = True,
        ),
    },
    doc = """
Generates a Clang configuration file with all the `-fmodule-map-file` flags
for all direct and transitive module maps from dependencies.
""",
    implementation = _objc_module_map_config_impl,
)
