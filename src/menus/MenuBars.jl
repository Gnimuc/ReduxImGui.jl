module MenuBars

Base.Experimental.@optlevel 2

using Redux
using CImGui
using ..Menus
import ..Menus: AbstractMenuAction

## actions
"""
    AbstractGenericMenuBarAction <: AbstractSyncAction
Abstract supertype for all kinds of menu bar actions. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMenuBarAction <: AbstractSyncAction end

"""
    AbstractMenuBarAction <: AbstractGenericMenuBarAction
Abstract supertype for all menu bar actions. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMenuBarAction <: AbstractGenericMenuBarAction end

# for determining whether we should apply the reducer function to certain action types. 
struct Valid end
struct Invalid end

is_valid(a::AbstractSyncAction) = Invalid
is_valid(a::AbstractGenericMenuBarAction) = Invalid
is_valid(a::AbstractMenuBarAction) = Valid  

_get_label(a::AbstractSyncAction, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_ACTION_LABEL"
_get_label(a::AbstractSyncAction, ::Type{Valid}) = a.label
get_label(a::AbstractSyncAction) = _get_label(a, is_valid(a))

"""
    Rename(label, new_label)
Change widget's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractMenuBarAction
    label::String
    new_label::String
end

"""
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractMenuBarAction
    label::String
    is_triggered::Bool
end

"""
    EditMenus(label, action::AbstractMenuAction)
Edit manus.
"""
struct EditMenus{T<:AbstractMenuAction} <: AbstractMenuBarAction
    label::String
    action::T
end

"""
    Show(label)
Show the menubar.
"""
struct Show <: AbstractMenuBarAction
    label::String
end

"""
    Hide(label)
Hide the menubar.
"""
struct Hide <: AbstractMenuBarAction
    label::String
end

## state
"""
    AbstractGenericMenuBar <: AbstractImmutableState
Abstract supertype for all kinds of menu bars. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMenuBar <: AbstractImmutableState end

"""
    AbstractMenuBar <: AbstractGenericMenuBar
Abstract supertype for all menu bars. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMenuBar <: AbstractGenericMenuBar end

is_valid(s::AbstractImmutableState) = Invalid
is_valid(s::AbstractGenericMenuBar) = Invalid
is_valid(s::AbstractMenuBar) = Valid

_get_label(s::AbstractImmutableState, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_STATE_LABEL"
_get_label(s::AbstractImmutableState, ::Type{Valid}) = s.label
get_label(s::AbstractImmutableState) = _get_label(s, is_valid(s))

"""
    MenuBar(label::AbstractString, menus = [], is_hidden = false)
A menu bar state which contains a label a.k.a the identifier, a list of menus, 
a flag value `is_hidden` and a flag value `is_triggered` that records the state of
the latest poll events.
"""
struct MenuBar <: AbstractMenuBar
    label::String
    menus::Vector{Menus.Menu}
    is_hidden::Bool
    is_triggered::Bool
end
MenuBar(label::AbstractString, menus = [], is_hidden = false) = 
    MenuBar(label, menus, is_hidden, false)

is_hidden(s::MenuBar) = s.is_hidden
is_triggered(s::MenuBar) = s.is_triggered

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::MenuBar, a::Rename) = MenuBar(a.new_label, s.menus, s.is_hidden, s.is_triggered)
reducer(s::MenuBar, a::SetTriggeredTo) = MenuBar(s.label, s.menus, s.is_hidden, a.is_triggered)
reducer(s::MenuBar, a::Show) = MenuBar(s.label, s.menus, false, s.is_triggered)
reducer(s::MenuBar, a::Hide) = MenuBar(s.label, s.menus, true, s.is_triggered)

reducer(s::MenuBar, a::EditMenus) =
    MenuBar(s.label, Menus.reducer(s.menus, a.action), s.is_hidden, s.is_triggered)

## UI
"""
    (::MenuBar)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity) -> Bool
Return `true` when `ImGuiWindowFlags_MenuBar` is setted on the parent window.
`get_state` is a router function that tells how to find the target state from `store`. 
`chain_action` is for chaining upstream actions.
"""
function MenuBar(store::AbstractStore, get_state=Redux.get_state, chain_action=identity)
    s = get_state(store)
    is_activated = CImGui.BeginMenuBar()
    dispatch!(
        store, 
        SetTriggeredTo(s.label, is_activated) |> chain_action
    )
    if is_activated && !s.is_hidden
        for (i, menu) in enumerate(s.menus)
            menu(
                store, 
                x->get_state(x).menus[i],
                x->EditMenus(s.label, x) |> chain_action,
            )
        end
        CImGui.EndMenuBar()
    end
    return is_activated
end

end # module
