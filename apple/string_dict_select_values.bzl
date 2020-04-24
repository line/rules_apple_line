def string_dict_select_values(values):
    select_values = []

    for value in values:
        if type(value) == type(""):
            select_values += [value]
        else:
            select_values += select(_wrap_dict_values_in_array(value))

    return select_values

def _wrap_dict_values_in_array(d):
    retval = {}
    for key, value in d.items():
        retval[key] = [value]
    return retval
