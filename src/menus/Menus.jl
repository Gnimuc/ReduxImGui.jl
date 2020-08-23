module Menus

Base.Experimental.@optlevel 2

using Redux
using CImGui
using ..MenuItems
import ..MenuItems: AbstractMenuItemAction, AbstractGenericMenuItem, AbstractMenuItem
using ..ToggleMenuItems
import ..ToggleMenuItems: ToggleMenuItem

## actions
"""
    AbstractGenericMenuAction <: AbstractSyncAction
Abstract supertype for all kinds of menu actions. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMenuAction <: AbstractSyncAction end

"""
    AbstractMenuAction <: AbstractGenericMenuAction
Abstract supertype for all menu actions. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMenuAction <: AbstractGenericMenuAction end

# for determining whether we should apply the reducer function to certain action types. 
struct Valid end
struct Invalid end

is_valid(a::AbstractSyncAction) = Invalid
is_valid(a::AbstractGenericMenuAction) = Invalid
is_valid(a::AbstractMenuAction) = Valid  

_get_label(a::AbstractSyncAction, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_ACTION_LABEL"
_get_label(a::AbstractSyncAction, ::Type{Valid}) = a.label
get_label(a::AbstractSyncAction) = _get_label(a, is_valid(a))

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
    EditMenuItems(label, action::AbstractSyncAction)
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
    items::Vector{AbstractImmutableState}
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

## state
"""
    AbstractGenericMenu <: AbstractImmutableState
Abstract supertype for all kinds of menus. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMenu <: AbstractImmutableState end

"""
    AbstractMenu <: AbstractGenericMenu
Abstract supertype for all menus. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMenu <: AbstractGenericMenu end

is_valid(s::AbstractImmutableState) = Invalid
is_valid(s::AbstractGenericMenu) = Invalid
is_valid(s::AbstractMenu) = Valid

_get_label(s::AbstractImmutableState, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_STATE_LABEL"
_get_label(s::AbstractImmutableState, ::Type{Valid}) = s.label
get_label(s::AbstractImmutableState) = _get_label(s, is_valid(s))


"""
    Menu(label::AbstractString, items = [], is_enabled = true)
A menu state which contains a label a.k.a the identifier, a list of menu items, 
a flag value `is_enabled` and a flag value `is_triggered` that records the state of
the latest poll events.
"""
struct Menu <: AbstractMenu
    label::String
    items::Vector{AbstractImmutableState}
    is_enabled::Bool
    is_triggered::Bool
end
Menu(label::AbstractString, items = [], is_enabled = true) = 
    Menu(label, items, is_enabled, false)

is_enabled(s::Menu) = s.is_enabled
is_triggered(s::Menu) = s.is_triggered

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::Menu, a::Rename) = Menu(a.new_label, s.items, s.is_enabled, s.is_triggered)
reducer(s::Menu, a::Enable) = Menu(s.label, s.items, true, s.is_triggered)
reducer(s::Menu, a::Disable) = Menu(s.label, s.items, false, s.is_triggered)
reducer(s::Menu, a::SetTriggeredTo) = Menu(s.label, s.items, s.is_enabled, a.is_triggered)

function reducer(s::Menu, a::EditMenuItems)
    new_items = MenuItems.reducer(s.items, a.action)
    new_items = ToggleMenuItems.reducer(new_items, a.action)
    new_items = map(new_items) do item
        item isa Menu ? Menus.reducer(item, a.action) : item
    end
    Menu(s.label, new_items, s.is_enabled, s.is_triggered)
end

reducer(s::Dict{String,<:AbstractImmutableState}, a::AbstractMenuAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractImmutableState}, a::AbstractMenuAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end
reducer(s::Vector{<:AbstractImmutableState}, a::AddMenu) = 
    [s..., Menu(a.label, a.items, a.is_enabled, false)]
reducer(s::Vector{<:AbstractImmutableState}, a::DeleteMenu) = 
    filter(s -> s.label !== get_label(a), s)

# UI
"""
    (::Menu)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity) -> Bool
Return `true` when triggered/activated.
`get_state` is a router function that tells how to find the target state from `store`. 
`chain_action` is for chaining upstream actions.

To render anything as an MenuItem, you could use functors, for example,
```
struct ItemSeparator <: AbstractGenericMenuItem end
(x::ItemSeparator)() = CImGui.Separator()
```
"""
function (::Menu)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity)
    s = get_state(store)
    is_activated = CImGui.BeginMenu(s.label, s.is_enabled)
    dispatch!(
        store, 
        SetTriggeredTo(s.label, is_activated) |> chain_action
    )
    !is_activated && return false
    for (i, item) in enumerate(s.items)
        if item isa Union{AbstractMenuItem, AbstractMenu}
            item(
                store, 
                x->get_state(x).items[i], 
                x->EditMenuItems(s.label, x) |> chain_action,
            )
        elseif item isa Union{AbstractGenericMenuItem, AbstractGenericMenu}
            item()
        else
            CImGui.Text("menu item type not supported! skip rendering...")
        end
    end
    CImGui.EndMenu()
    return true
end

end # module
