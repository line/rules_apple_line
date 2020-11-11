load("@bazel_skylib//rules:copy_file.bzl", "copy_file")
load("@rules_apple_line//apple:apple_linker_inputs.bzl", "apple_linker_inputs")

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
        # These will be passed to clang in reversed order
        "-Wl,-zld_original_ld_path,__BAZEL_XCODE_DEVELOPER_DIR__/Toolchains/XcodeDefault.xctoolchain/usr/bin/ld",
        "-fuse-ld=zld",
        # Add the containing directory to clang's search paths for binaries
        "-B$(BINDIR)/external/zld",
    ],
)

# A dummy target that propagates extra linker flags for zld. Add this to your
# application/extension targets' `deps` to tell Bazel to use zld to link your
# executables.
objc_library(
    name = "zld_linkopts_lib",
    visibility = ["//visibility:public"],
    deps = [":zld_linkopts"],
)
