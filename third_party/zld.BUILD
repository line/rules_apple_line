load("@build_bazel_apple_support//lib:apple_support.bzl", "apple_support")
load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@rules_apple_line//apple:apple_linker_inputs.bzl", "apple_linker_inputs")
load("@rules_apple_line//apple:utils.bzl", "build_file_dirname")

# clang will look for a file `ld64.<linker-name>` in its search paths if we
# pass a linker name to it via the `-fuse-ld=<linker-name>` flag, or
# <linker-name> has to be an absolute path to a linker.
copy_file(
    name = "ld64_zld",
    src = "zld",
    out = "ld64.zld",
    is_executable = True,
)

apple_linker_inputs(
    name = "zld_linkopts",
    linker_inputs = [":ld64_zld"],
    linkopts = [
        # Add the containing directory to clang's search paths for binaries
        "-B$(BINDIR)/{}".format(
            build_file_dirname(
                repository_name = repository_name(),
                package_name = package_name(),
            ),
        ),
        "-fuse-ld=zld",
        "-Wl,-zld_original_ld_path,{}/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld".format(
            apple_support.path_placeholders.xcode(),
        ),
    ],
    visibility = ["//visibility:public"],
)
