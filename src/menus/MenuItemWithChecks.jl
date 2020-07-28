module MenuItems

using Redux
using CImGui
import ..ReduxImGui: get_label

# actions
abstract type AbstractMenuItemAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change widget's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractMenuItemAction
    label::String
    new_label::String
end

"""
    ChangeShortcut(label, shortcut)
Change shortcut string to `shortcut`.
"""
struct ChangeShortcut <: AbstractMenuItemAction
    label::String
    shortcut::String
end

"""
    SetSelectedTo(label, is_selected)
Set widget's selected state to `is_selected`.
"""
struct SetSelectedTo <: AbstractMenuItemAction
    label::String
    is_selected::Bool
end

"""
    SetClickedTo(label, is_clicked)
Set widget's clicked state to `is_clicked`.
"""
struct SetClickedTo <: AbstractMenuItemAction
    label::String
    is_clicked::Bool
end

"""
    Toggle(label)
Toggle the menu item `is_selected` state.
"""
struct Toggle <: AbstractMenuItemAction
    label::String
end

"""
    Enable(label)
Enable the menu item.
"""
struct Enable <: AbstractMenuItemAction
    label::String
end

"""
    Disable(label)
Disable the menu item.
"""
struct Disable <: AbstractMenuItemAction
    label::String
end

"""
    AddMenuItem(label::AbstractString, shortcut = "", is_selected = false, is_enabled = true)
Add a menu item.
"""
struct AddMenuItem <: AbstractMenuItemAction
    label::String
    shortcut::String
    is_selected::Bool
    is_enabled::Bool
end
AddMenuItem(label::AbstractString, shortcut = "", is_selected = false) =
    AddMenuItem(label, shortcut, is_selected, true)

"""
    DeleteMenuItem(label::AbstractString)
Delete the menu item.
"""
struct DeleteMenuItem <: AbstractMenuItemAction
    label::String
end

# state
struct State <: AbstractImmutableState
    label::String
    shortcut::String
    is_selected::Bool
    is_enabled::Bool
    is_clicked::Bool
end
State(
    label::AbstractString,
    shortcut = "",
    is_selected = false,
    is_enabled = true,
) = State(label, shortcut, is_selected, is_enabled, false)

# reducers
menu_item(state::AbstractState, action::AbstractAction) = state
menu_item(state::Vector{<:AbstractState}, action::AbstractAction) = state
menu_item(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

menu_item(s::State, a::Rename) =
    State(a.new_label, s.shortcut, s.is_selected, s.is_enabled, s.is_clicked)
menu_item(s::State, a::ChangeShortcut) =
    State(s.label, a.shortcut, s.is_selected, s.is_enabled, s.is_clicked)
menu_item(s::State, a::SetSelectedTo) =
    State(s.label, s.shortcut, a.is_selected, s.is_enabled, s.is_clicked)
menu_item(s::State, a::SetClickedTo) =
    State(s.label, s.shortcut, s.is_selected, s.is_enabled, a.is_clicked)
menu_item(s::State, a::Toggle) =
    State(s.label, s.shortcut, !s.is_selected, s.is_enabled, s.is_clicked)
menu_item(s::State, a::Enable) =
    State(s.label, s.shortcut, s.is_selected, true, s.is_clicked)
menu_item(s::State, a::Disable) =
    State(s.label, s.shortcut, s.is_selected, false, s.is_clicked)

menu_item(s::Vector{State}, a::AbstractMenuItemAction) = map(s) do s
    s.label === a.label ? menu_item(s, a) : s
end
menu_item(s::Vector{State}, a::AddMenuItem) =
    State[s..., State(a.label, a.shortcut, a.is_selected, a.enabled, false)]
menu_item(s::Vector{State}, a::DeleteMenuItem) = filter(s -> s.label !== a.label, s)

function menu_item(state::Dict{String,State}, action::AbstractMenuItemAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? menu_item(v, action) : v
    end
    return s
end

# helper
"""
    MenuItem(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when activated.
"""
function MenuItem(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_activated = CImGui.MenuItem(get_label(s), s.shortcut, s.is_selected, s.is_enabled)
    is_activated && dispatch!(store, Toggle(get_label(s)))
    return is_activated
end

get_label(s::State) = s.label


end # module
