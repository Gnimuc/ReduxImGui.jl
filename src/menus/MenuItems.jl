module MenuItems

Base.Experimental.@optlevel 1

using Redux
using CImGui

## actions
"""
    AbstractGenericMenuItemAction <: AbstractSyncAction
Abstract supertype for all kinds of menu item actions. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMenuItemAction <: AbstractSyncAction end

"""
    AbstractMenuItemAction <: AbstractGenericMenuItemAction
Abstract supertype for all menu item actions. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMenuItemAction <: AbstractGenericMenuItemAction end

# for determining whether we should apply the reducer function to certain action types. 
struct Valid end
struct Invalid end

is_valid(a::AbstractSyncAction) = Invalid
is_valid(a::AbstractGenericMenuItemAction) = Invalid
is_valid(a::AbstractMenuItemAction) = Valid  

_get_label(a::AbstractSyncAction, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_ACTION_LABEL"
_get_label(a::AbstractSyncAction, ::Type{Valid}) = a.label
get_label(a::AbstractSyncAction) = _get_label(a, is_valid(a))

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

## state
"""
    AbstractGenericMenuItem <: AbstractImmutableState
Abstract supertype for all kinds of menu items. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMenuItem <: AbstractImmutableState end

"""
    AbstractMenuItem <: AbstractGenericMenuItem
Abstract supertype for all menu items. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMenuItem <: AbstractGenericMenuItem end

is_valid(s::AbstractImmutableState) = Invalid
is_valid(s::AbstractGenericMenuItem) = Invalid
is_valid(s::AbstractMenuItem) = Valid

_get_label(s::AbstractImmutableState, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_STATE_LABEL"
_get_label(s::AbstractImmutableState, ::Type{Valid}) = s.label
get_label(s::AbstractImmutableState) = _get_label(s, is_valid(s))

"""
    MenuItem(label::AbstractString, shortcut = "", is_enabled = true)
A menu item state which contains a label a.k.a the identifier, a shortcut string,
a flag value `is_enabled` and a flag value `is_triggered` that records the state of the latest poll events.
"""
struct MenuItem <: AbstractMenuItem
    label::String
    shortcut::String
    is_enabled::Bool
    is_triggered::Bool
end
MenuItem(label::AbstractString, shortcut = "", is_enabled = true) =
    MenuItem(label, shortcut, is_enabled, false)

get_shortcut(s::MenuItem) = s.shortcut
is_triggered(s::MenuItem) = s.is_triggered
is_enabled(s::MenuItem) = s.is_enabled

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::MenuItem, a::Rename) = MenuItem(a.new_label, s.shortcut, s.is_enabled, s.is_triggered)
reducer(s::MenuItem, a::ChangeShortcut) = MenuItem(s.label, a.shortcut, s.is_enabled, s.is_triggered)
reducer(s::MenuItem, a::Enable) = MenuItem(s.label, s.shortcut, true, s.is_triggered)
reducer(s::MenuItem, a::Disable) = MenuItem(s.label, s.shortcut, false, s.is_triggered)
reducer(s::MenuItem, a::SetTriggeredTo) = MenuItem(s.label, s.shortcut, s.is_enabled, a.is_triggered)

reducer(s::Dict{String,<:AbstractImmutableState}, a::AbstractMenuItemAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractImmutableState}, a::AbstractMenuItemAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end
reducer(s::Vector{<:AbstractImmutableState}, a::AddMenuItem) = 
    [s..., MenuItem(a.label, a.shortcut, a.is_enabled, false)]
reducer(s::Vector{<:AbstractImmutableState}, a::DeleteMenuItem) = 
    filter(s -> get_label(s) != get_label(a), s)

# UI
"""
    (::MenuItem)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity) -> Bool
Return `true` when triggered/activated.
`get_state` is a router function that tells how to find the target state from `store`. 
`chain_action` is for chaining upstream actions.
"""
function (::MenuItem)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity)
    s = get_state(store)
    is_activated = CImGui.MenuItem(get_label(s), s.shortcut, false, s.is_enabled)
    dispatch!(
        store, 
        SetTriggeredTo(get_label(s), is_activated) |> chain_action,
    )
    return is_activated
end

end # module
