module Menus

using Redux
using CImGui
using ..MenuItems
import ..MenuItems: AbstractMenuItemAction
import ..ReduxImGui: get_label

# actions
abstract type AbstractMenuAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change widget's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractMenuAction
    label::String
    new_label::String
end

"""
    EditMenuItems(label, action::AbstractMenuItemAction)
Edit manu items.
"""
struct EditMenuItems{T<:AbstractMenuItemAction} <: AbstractMenuAction
    label::String
    action::T
end

"""
    Enable(label)
Enable the menu.
"""
struct Enable <: AbstractMenuAction
    label::String
end

"""
    Disable(label)
Disable the menu.
"""
struct Disable <: AbstractMenuAction
    label::String
end

# state
struct State <: AbstractImmutableState
    label::String
    items::Vector{MenuItems.State}
    is_enabled::Bool
end
State(label::AbstractString, items) = State(label, items, true)

# reducers
menu(state::AbstractState, action::AbstractAction) = state
menu(state::Vector{<:AbstractState}, action::AbstractAction) = state
menu(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

menu(s::State, a::Rename) = State(a.new_label, s.items, s.is_enabled)
menu(s::State, a::Enable) = State(s.label, s.items, true)
menu(s::State, a::Disable) = State(s.label, s.items, false)
menu(s::State, a::EditMenuItems) =
    State(s.label, MenuItems.menu_item(s.items, a.action), s.is_enabled)

function menu(state::Dict{String,State}, action::AbstractMenuAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? menu(v, action) : v
    end
    return s
end

# helper
"""
    Menu(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when activated.
"""
function Menu(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_activated = CImGui.BeginMenu(s.label, s.is_enabled)
    is_activated || return false
    for x in s.items
        if isempty(x.label)
            CImGui.Separator()
        elseif CImGui.MenuItem(x.label, x.shortcut, x.is_selected, x.is_enabled)
            dispatch!(store, Menus.EditMenuItems(s.label, MenuItems.SetClickedTo(x.label, true)))
            dispatch!(store, Menus.EditMenuItems(s.label, MenuItems.Toggle(x.label)))
        else
            dispatch!(store, MenuItems.SetClickedTo(x.label, false))
        end
    end
    CImGui.EndMenu()
    return true
end

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

get_label(s::State) = s.label
get_items(s::State) = s.items


end # module
