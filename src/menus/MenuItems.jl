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

# state
struct State <: AbstractImmutableState
    label::String
    shortcut::String
    is_selected::Bool
    is_enabled::Bool
end
State(label::AbstractString, shortcut = "", is_selected = false) =
    State(label, shortcut, is_selected, true)

# reducers
menu_item(state::AbstractState, action::AbstractAction) = state
menu_item(state::Vector{<:AbstractState}, action::AbstractAction) = state
menu_item(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function menu_item(state::Dict{String,State}, action::AbstractMenuItemAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? menu_item(v, action) : v
    end
    return s
end

menu_item(s::State, a::Rename) = State(a.new_label, s.shortcut, s.is_selected, s.is_enabled)
menu_item(s::State, a::ChangeShortcut) = State(s.label, a.shortcut, s.is_selected, s.is_enabled)
menu_item(s::State, a::SetSelectedTo) = State(s.label, s.shortcut, a.is_selected, s.is_enabled)
menu_item(s::State, a::Toggle) = State(s.label, s.shortcut, !s.is_selected, s.is_enabled)
menu_item(s::State, a::Enable) = State(s.label, s.shortcut, s.is_selected, true)
menu_item(s::State, a::Disable) = State(s.label, s.shortcut, s.is_selected, false)

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
