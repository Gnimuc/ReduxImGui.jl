module MainMenuBars

using Redux
using CImGui

# helpers
"""
    MainMenuBar(f::Function)
Create a menu bar at the top of the screen.
"""
function MainMenuBar(f::Function)
    if CImGui.BeginMainMenuBar()
        f()
        CImGui.EndMainMenuBar()
    end
    return nothing
end

end # module
