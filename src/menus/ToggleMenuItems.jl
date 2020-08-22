module ToggleMenuItems

Base.Experimental.@optlevel 1

using Redux
using CImGui
using ..MenuItems
import ..MenuItems: AbstractMenuItemAction, AbstractGenericMenuItem, AbstractMenuItem, 
                    MenuItem, get_label

# actions
const Rename = MenuItems.Rename 
const SetTriggeredTo = MenuItems.SetTriggeredTo
const ChangeShortcut = MenuItems.ChangeShortcut
const Enable = MenuItems.Enable
const Disable = MenuItems.Disable

"""
    SetSelectedTo(label, is_selected)
Set widget selected state to `is_selected`.
"""
struct SetSelectedTo <: AbstractMenuItemAction
    label::String
    is_selected::Bool
end

"""
    Toggle(label)
Toggle the menu item `is_selected` state.
"""
struct Toggle <: AbstractMenuItemAction
    label::String
end

"""
    AddMenuItem(label::AbstractString, shortcut::AbstractString = "", is_selected = false, is_enabled = true)
Add a menu item.
"""
struct AddMenuItem <: AbstractMenuItemAction
    menu_item::MenuItem
    is_selected::Bool
end
AddMenuItem(label::AbstractString, shortcut::AbstractString = "", is_selected = false, is_enabled = true) =
    AddMenuItem(MenuItem(label, shortcut, is_enabled, false), is_selected)

# any subtypes of AbstractMenuItemAction should have a `label` field, so we fake it.
function Base.getproperty(obj::AddMenuItem, sym::Symbol)
    if sym === :label
        return obj.menu_item.label
    else
        return getfield(obj, sym)
    end
end

"""
    DeleteMenuItem(label::AbstractString)
Delete the menu item.
"""
struct DeleteMenuItem <: AbstractMenuItemAction
    label::String
end

# state
"""
    ToggleMenuItem(label::AbstractString, shortcut::AbstractString = "", is_selected = false, is_enabled = true)
A [`MenuItem`](@ref) with a toggle state.
"""
struct ToggleMenuItem <: AbstractMenuItem
    menu_item::MenuItem
    is_selected::Bool
end
ToggleMenuItem(label::AbstractString, shortcut::AbstractString = "", is_selected = false, is_enabled = true) =
    ToggleMenuItem(MenuItem(label, shortcut, is_enabled, false), is_selected)

# any subtypes of AbstractMenuItem should have a `label` field, so we fake it.
function Base.getproperty(obj::ToggleMenuItem, sym::Symbol)
    if sym === :label
        return obj.menu_item.label
    else
        return getfield(obj, sym)
    end
end

get_shortcut(s::ToggleMenuItem) = s.menu_item.shortcut
is_triggered(s::ToggleMenuItem) = s.menu_item.is_triggered
is_enabled(s::ToggleMenuItem) = s.menu_item.is_enabled
is_selected(s::ToggleMenuItem) = s.is_selected

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::ToggleMenuItem, a::AbstractMenuItemAction) = ToggleMenuItem(MenuItems.reducer(s.menu_item, a), s.is_selected)
reducer(s::ToggleMenuItem, a::Toggle) = ToggleMenuItem(s.menu_item, !s.is_selected)
reducer(s::ToggleMenuItem, a::SetSelectedTo) = ToggleMenuItem(s.menu_item, a.is_selected)

reducer(s::Dict{String,<:AbstractImmutableState}, a::AbstractMenuItemAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractImmutableState}, a::AbstractMenuItemAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end
reducer(s::Vector{<:AbstractImmutableState}, a::AddMenuItem) = 
    [s..., ToggleMenuItem(a.menu_item, a.is_selected)]
reducer(s::Vector{<:AbstractImmutableState}, a::DeleteMenuItem) = 
    filter(s -> get_label(s) !== get_label(a), s)

# UI
"""
    (::ToggleMenuItem)(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered/activated.
`get_state` is a router function that tells how to find the target state from `store`. 
`chain_action` is for chaining upstream actions.
"""
function (::ToggleMenuItem)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity)
    s = get_state(store)
    is_activated = CImGui.MenuItem(get_label(s), get_shortcut(s), s.is_selected, is_enabled(s))
    dispatch!(
        store, 
        SetTriggeredTo(get_label(s), is_activated) |> chain_action,
    )
    is_activated && dispatch!(
        store, 
        Toggle(get_label(s)) |> chain_action,
    )
    return is_activated
end

end # module
