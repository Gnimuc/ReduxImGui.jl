module MenuBars

using Redux
using CImGui

# helpers
"""
    MenuBar(f::Function)
Create a menu bar.
"""
function MenuBar(f::Function)
    if CImGui.BeginMenuBar()
        f()
        CImGui.EndMenuBar()
    end
    return nothing
end

end # module
