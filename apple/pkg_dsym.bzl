"""Rule for packaging .dSYM.zip. Originally imported from
https://github.com/bazelbuild/rules_pkg/blob/cd2fd762be23a6cc672e6390f7b6ef3c1c7bfd4b/pkg/pkg.bzl
with modifications for dSYM specifics."""

def _quote(filename, protect = "="):
    """Quote the filename, by escaping = by \\= and \\ by \\\\"""
    return filename.replace("\\", "\\\\").replace(protect, "\\" + protect)

def _dest_path(path):
    """Returns the path, stripped of parent directories of .dSYM."""
    components = path.split("/")
    res_components = []
    found = False
    for c in components:
        # Find .dSYM directory and make it be at the root path
        if c.endswith(".dSYM"):
            found = True
        if found:
            res_components.append(c)
    return "/".join(res_components)

def _dsym_files(files):
    """Remove files that aren't dSYM files."""
    return [
        f
        for f in files
        if f.path.find(".dSYM") != -1
    ]

def _pkg_dsym_impl(ctx):
    args = ctx.actions.args()

    args.add("-o", ctx.outputs.out)
    args.add("-d", ctx.attr._package_dir)
    args.add("-t", ctx.attr.timestamp)
    args.add("-m", ctx.attr.mode)

    srcs = _dsym_files(ctx.files.srcs)
    for f in srcs:
        path = f.path
        arg = "%s=%s" % (
            _quote(path),
            _dest_path(path),
        )
        args.add(arg)

    args.set_param_file_format("multiline")
    args.use_param_file("@%s")

    ctx.actions.run(
        mnemonic = "PackageDsym",
        inputs = srcs,
        executable = ctx.executable._build_zip,
        arguments = [args],
        outputs = [ctx.outputs.out],
        env = {
            "LANG": "en_US.UTF-8",
            "LC_CTYPE": "UTF-8",
            "PYTHONIOENCODING": "UTF-8",
            "PYTHONUTF8": "1",
        },
        use_default_shell_env = True,
    )
    return OutputGroupInfo(out = [ctx.outputs.out])

pkg_dsym = rule(
    implementation = _pkg_dsym_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            doc = """
A list of executable targets that produce dSYM, and/or a list of imported dSYMs
if they're prebuilt.
""",
        ),
        "timestamp": attr.int(
            default = 315532800,
            doc = """
The time to use for every file in the zip, expressed as seconds since Unix
Epoch, RFC 3339.

Due to limitations in the format of zip files, values before Jan 1, 1980 will
be rounded up and the precision in the zip file is limited to a granularity of
2 seconds.
""",
        ),
        "mode": attr.string(
            default = "0555",
            doc = "Set the mode of files added by the `srcs` attribute.",
        ),
        "out": attr.output(
            doc = "The output filename.",
        ),
        # Implicit dependencies.
        "_build_zip": attr.label(
            default = Label("@rules_pkg//:build_zip"),
            cfg = "exec",
            executable = True,
            allow_files = True,
        ),
        "_package_dir": attr.string(default = "/"),
    },
    doc = "Creates a `.dSYM.zip` file given targets that produce dSYMs.",
)
