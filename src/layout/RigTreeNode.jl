module RigTreeNode

using Redux
using CImGui

# helpers
"""
    TreeNode(f::Function, label::AbstractString) -> Bool
Return `true` when the node is open.
"""
function TreeNode(f::Function, label::AbstractString)
    is_open = CImGui.TreeNode(label)
    if is_open
        f()
        CImGui.TreePop()
    end
    return is_open
end

"""
    TreeNodeEx(f::Function, label::AbstractString, flags=0) -> Bool
Return `true` when the node is open.
"""
function TreeNodeEx(f::Function, label::AbstractString, flags=0)
    is_open = CImGui.TreeNodeEx(label, flags)
    if is_open
        f()
        CImGui.TreePop()
    end
    return is_open
end

end # module
