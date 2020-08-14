module Tooltips

Base.Experimental.@optlevel 1

using Redux
using CImGui

# helper
"""
    Tooltip(f::Function)
"""
function Tooltip(f::Function)
    CImGui.BeginTooltip()
        f()
    CImGui.EndTooltip()
    return nothing
end

end # module
