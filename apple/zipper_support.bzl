def swiftmodule_zipper_arg_format(framework, module_name, cpu, extension):
    return "{framework}/Modules/{module_name}.swiftmodule/{cpu}.{extension}=%s".format(
        framework = framework,
        module_name = module_name,
        cpu = cpu,
        extension = extension,
    )
