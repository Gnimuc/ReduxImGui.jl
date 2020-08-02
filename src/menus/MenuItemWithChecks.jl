module MenuItemWithChecks

using Redux
using CImGui
using ..MenuItems
import ..MenuItems: AbstractMenuItemAction, AbstractMenuItemState, get_label, has_is_selected

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
    menu_item::MenuItems.State
    is_selected::Bool
end
AddMenuItem(label::AbstractString, shortcut::AbstractString = "", is_selected = false, is_enabled = true) =
    AddMenuItem(MenuItems.State(label, shortcut, is_enabled, false), is_selected)

get_label(a::AddMenuItem) = a.menu_item.label

"""
    DeleteMenuItem(label::AbstractString)
Delete the menu item.
"""
struct DeleteMenuItem <: AbstractMenuItemAction
    label::String
end

# state
"""
    MenuItemWithChecks.State(label::AbstractString, shortcut::AbstractString = "", is_selected = false, is_enabled = true)
A manu item with a check state.
"""
struct State <: AbstractMenuItemState
    menu_item::MenuItems.State
    is_selected::Bool
end
State(label::AbstractString, shortcut::AbstractString = "", is_selected = false, is_enabled = true) =
    State(MenuItems.State(label, shortcut, is_enabled, false), is_selected)

get_label(s::State) = s.menu_item.label
get_shortcut(s::State) = s.menu_item.shortcut
is_triggered(s::State) = s.menu_item.is_triggered
is_enabled(s::State) = s.menu_item.is_enabled
is_selected(s::State) = s.is_selected
has_is_selected(s::State) = true

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::AbstractMenuItemAction) = State(MenuItems.reducer(s.menu_item, a), s.is_selected)
reducer(s::State, a::Toggle) = State(s.menu_item, !s.is_selected)
reducer(s::State, a::SetSelectedTo) = State(s.menu_item, a.is_selected)

reducer(s::Dict{String,<:AbstractMenuItemState}, a::AbstractMenuItemAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractMenuItemState}, a::AbstractMenuItemAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end

reducer(s::Vector{<:AbstractMenuItemState}, a::AddMenuItem) = [s..., State(a.menu_item, a.is_selected)]
reducer(s::Vector{<:AbstractMenuItemState}, a::DeleteMenuItem) = filter(s -> get_label(s) !== get_label(a), s)

# helper
"""
    MenuItemWithCheck(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered/activated.
`get_state` is a router function which tells how to find the target state from `store`.
"""
function MenuItemWithCheck(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_activated = CImGui.MenuItem(get_label(s), get_shortcut(s), s.is_selected, is_enabled(s))
    dispatch!(store, MenuItems.SetTriggeredTo(get_label(s), is_activated))
    is_activated && dispatch!(store, Toggle(get_label(s)))
    return is_activated
end

end # module
