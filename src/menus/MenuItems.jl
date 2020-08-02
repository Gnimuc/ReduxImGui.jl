module MenuItems

using Redux
using CImGui

# actions
abstract type AbstractMenuItemAction <: AbstractSyncAction end

get_label(a::AbstractMenuItemAction) = a.label

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
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractMenuItemAction
    label::String
    is_triggered::Bool
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
    AddMenuItem(label::AbstractString, shortcut = "", is_enabled = true)
Add a menu item.
"""
struct AddMenuItem <: AbstractMenuItemAction
    label::String
    shortcut::String
    is_enabled::Bool
end
AddMenuItem(label::AbstractString, shortcut = "") = AddMenuItem(label, shortcut, true)

"""
    DeleteMenuItem(label::AbstractString)
Delete the menu item.
"""
struct DeleteMenuItem <: AbstractMenuItemAction
    label::String
end

# state
abstract type AbstractMenuItemState <: AbstractImmutableState end

get_label(s::AbstractMenuItemState) = s.label

"""
    MenuItems.State(label::AbstractString, shortcut = "", is_enabled = true)
A menu item state which contains a label a.k.a the identifier, a shortcut string,
a flag value `is_enabled` and a flag value `is_triggered` that records the state of the latest poll events.
"""
struct State <: AbstractMenuItemState
    label::String
    shortcut::String
    is_enabled::Bool
    is_triggered::Bool
end
State(label::AbstractString, shortcut = "", is_enabled = true) =
    State(label, shortcut, is_enabled, false)

get_shortcut(s::State) = s.shortcut
is_triggered(s::State) = s.is_triggered
is_enabled(s::State) = s.is_enabled

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.shortcut, s.is_enabled, s.is_triggered)
reducer(s::State, a::ChangeShortcut) = State(s.label, a.shortcut, s.is_enabled, s.is_triggered)
reducer(s::State, a::Enable) = State(s.label, s.shortcut, true, s.is_triggered)
reducer(s::State, a::Disable) = State(s.label, s.shortcut, false, s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.shortcut, s.is_enabled, a.is_triggered)

reducer(s::Dict{String,<:AbstractMenuItemState}, a::AbstractMenuItemAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractMenuItemState}, a::AbstractMenuItemAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end

reducer(s::Vector{<:AbstractMenuItemState}, a::AddMenuItem) =
    [s..., State(a.label, a.shortcut, a.is_enabled, false)]
reducer(s::Vector{<:AbstractMenuItemState}, a::DeleteMenuItem) = 
    filter(s -> get_label(s) !== get_label(a), s)

# helper
"""
    MenuItem(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered/activated.
`get_state` is a router function which tells how to find the target state from `store`.
"""
function MenuItem(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_activated = CImGui.MenuItem(get_label(s), s.shortcut, false, s.is_enabled)
    dispatch!(store, SetTriggeredTo(s.label, is_activated))
    return is_activated
end

end # module
