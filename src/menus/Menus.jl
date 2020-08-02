module Menus

using Redux
using CImGui
using ..MenuItems
import ..MenuItems: AbstractMenuItemAction, AbstractMenuItemState, get_label
using ..MenuItemWithChecks

# actions
abstract type AbstractMenuAction <: AbstractSyncAction end

get_label(a::AbstractMenuAction) = a.label

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
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractMenuAction
    label::String
    is_triggered::Bool
end

"""
    EditMenuItems(label, action::AbstractMenuItemAction)
Edit manu items.
"""
struct EditMenuItems{T<:AbstractSyncAction} <: AbstractMenuAction
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

"""
    AddMenu(label::AbstractString, items = [], is_enabled = true)
Add a [`Menu`](@ref).
"""
struct AddMenu <: AbstractMenuAction
    label::String
    items::Vector{MenuItems.State}
    is_enabled::Bool
end
AddMenu(label::AbstractString, items = []) = AddMenu(label, items, true)

"""
    DeleteMenu(label::AbstractString)
Delete the [`Menu`](@ref).
"""
struct DeleteMenu <: AbstractMenuAction
    label::String
end

# state
abstract type AbstractMenuState <: AbstractImmutableState end

"""
    Menus.State(label::AbstractString, items = [], is_enabled = true)
A menu state which contains a label a.k.a the identifier, a list of menu items, 
a flag value `is_enabled` and a flag value `is_triggered` that records the state of
the latest poll events.
"""
struct State <: AbstractMenuState
    label::String
    items::Vector{MenuItems.AbstractMenuItemState}
    is_enabled::Bool
    is_triggered::Bool
end
State(label::AbstractString, items = [], is_enabled = true) = 
    State(label, items, is_enabled, false)

get_label(s::State) = s.label
is_enabled(s::State) = s.is_enabled
is_triggered(s::State) = s.is_triggered

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.items, s.is_enabled, s.is_triggered)
reducer(s::State, a::Enable) = State(s.label, s.items, true, s.is_triggered)
reducer(s::State, a::Disable) = State(s.label, s.items, false, s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.items, s.is_enabled, a.is_triggered)

function reducer(s::State, a::EditMenuItems)
    new_items = MenuItems.reducer(s.items, a.action)
    new_items = MenuItemWithChecks.reducer(new_items, a.action)
    State(s.label, new_items, s.is_enabled, s.is_triggered)
end

reducer(s::Dict{String,<:AbstractMenuState}, a::AbstractMenuAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractMenuState}, a::AbstractMenuAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end
reducer(s::Vector{<:AbstractMenuState}, a::AddMenu) = [s..., State(a.label, a.items, a.is_enabled, false)]
reducer(s::Vector{<:AbstractMenuState}, a::DeleteMenu) = filter(s -> s.label !== get_label(a), s)

# helper
"""
    Menu(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered/activated.
`get_state` is a router function which tells how to find the target state from `store`.
"""
function Menu(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_activated = CImGui.BeginMenu(s.label, s.is_enabled)
    dispatch!(store, SetTriggeredTo(s.label, is_activated))
    !is_activated && return false
    for item in s.items
        if MenuItems.has_is_selected(item)
            x = CImGui.MenuItem(item.label, item.shortcut, item.is_selected, item.is_enabled)
            x && dispatch!(store, MenuItemWithChecks.Toggle(item.label))
        else
            x = CImGui.MenuItem(item.label, item.shortcut, false, item.is_enabled)
        end
        dispatch!(store, MenuItems.SetTriggeredTo(item.label, x))
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

end # module
