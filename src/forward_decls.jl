"""
    get_label(s) -> String
Return the label/identifier.
"""
function get_label end

"""
    get_values(s) -> Vector
Return the current values.
"""
function get_values end

"""
    get_value(s)
Return `first(get_values(s))`.
"""
get_value(s) = first(get_values(s))
