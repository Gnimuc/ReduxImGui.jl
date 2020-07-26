module Menus

using Redux
using CImGui

# helpers
"""
    Menu(f::Function, label::AbstractString, enabled=true) -> Bool
Create a sub-menu entry.
"""
function Menu(f::Function, label::AbstractString, enabled=true)
    if CImGui.BeginMenu(label, enabled)
        f()
        CImGui.EndMenu()
    end
    return nothing
end

end # module
