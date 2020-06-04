"""Implementation of unique_symbol_file rule."""

def _string_to_c_symbol(string):
    """Converts a string to a valid C symbol

    Args:
      string: The string to convert

    Returns:
      The converted string
    """
    out = ""
    for character in string.elems():
        if character.isalnum():
            out += character
        else:
            out += "_"
    return out

def _label_to_c_symbol(label):
    """Converts a label to a valid C symbol

    Args:
      label: The label to convert

    Returns:
      The converted string
    """
    workspace = _string_to_c_symbol(label.workspace_root)
    package = _string_to_c_symbol(label.package)
    name = _string_to_c_symbol(label.name)

    return "{workspace}{package}_{name}".format(
        workspace = workspace,
        package = package,
        name = name,
    )

def _unique_symbol_file_impl(ctx):
    output = ctx.outputs.out
    label = _label_to_c_symbol(ctx.label)

    content = """\
__attribute__((visibility("default"))) char k{}ExportToSuppressLibToolWarning = 0;
""".format(label)

    ctx.actions.write(
        output = output,
        content = content,
    )

unique_symbol_file = rule(
    implementation = _unique_symbol_file_impl,
    attrs = {
        "out": attr.output(
            doc = "The name of the generated file.",
            mandatory = True,
        ),
    },
    doc = """
Creates a source file with a unique symbol in it so that the linker does not
generate warnings at link time for static libraries with no symbols in them.
""",
)
