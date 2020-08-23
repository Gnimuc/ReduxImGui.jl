module MainMenuBars

Base.Experimental.@optlevel 2

using Redux
using CImGui
using ..Menus
import ..Menus: AbstractMenuAction

## actions
"""
    AbstractGenericMainMenuBarAction <: AbstractSyncAction
Abstract supertype for all kinds of main menu bar actions. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMainMenuBarAction <: AbstractSyncAction end

"""
    AbstractMainMenuBarAction <: AbstractGenericMainMenuBarAction
Abstract supertype for all main menu bar actions. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMainMenuBarAction <: AbstractGenericMainMenuBarAction end

# for determining whether we should apply the reducer function to certain action types. 
struct Valid end
struct Invalid end

is_valid(a::AbstractSyncAction) = Invalid
is_valid(a::AbstractGenericMainMenuBarAction) = Invalid
is_valid(a::AbstractMainMenuBarAction) = Valid  

_get_label(a::AbstractSyncAction, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_ACTION_LABEL"
_get_label(a::AbstractSyncAction, ::Type{Valid}) = a.label
get_label(a::AbstractSyncAction) = _get_label(a, is_valid(a))

"""
    Rename(label, new_label)
Change widget's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractMainMenuBarAction
    label::String
    new_label::String
end

"""
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractMainMenuBarAction
    label::String
    is_triggered::Bool
end

"""
    EditMenus(label, action::AbstractMenuAction)
Edit manus.
"""
struct EditMenus{T<:AbstractMenuAction} <: AbstractMainMenuBarAction
    label::String
    action::T
end

"""
    Show(label)
Show the menubar.
"""
struct Show <: AbstractMainMenuBarAction
    label::String
end

"""
    Hide(label)
Hide the menubar.
"""
struct Hide <: AbstractMainMenuBarAction
    label::String
end

## state
"""
    AbstractGenericMainMenuBar <: AbstractImmutableState
Abstract supertype for all kinds of main menu bars. Literally, its subtype could be anything.
"""
abstract type AbstractGenericMainMenuBar <: AbstractImmutableState end

"""
    AbstractMainMenuBar <: AbstractGenericMainMenuBar
Abstract supertype for all main menu bars. Any subtypes of this type should has a 
`label` field or at least `x.label` should work.
"""
abstract type AbstractMainMenuBar <: AbstractGenericMainMenuBar end

is_valid(s::AbstractImmutableState) = Invalid
is_valid(s::AbstractGenericMainMenuBar) = Invalid
is_valid(s::AbstractMainMenuBar) = Valid

_get_label(s::AbstractImmutableState, ::Type{Invalid}) = "___REDUXIMGUI_RESERVED_DUMMY_STATE_LABEL"
_get_label(s::AbstractImmutableState, ::Type{Valid}) = s.label
get_label(s::AbstractImmutableState) = _get_label(s, is_valid(s))

"""
    MainMenuBar(label::AbstractString, menus = [], is_hidden = false)
A main menu bar state which contains a label a.k.a the identifier, a list of menus, 
a flag value `is_hidden` and a flag value `is_triggered` that records the state of
the latest poll events.
"""
struct MainMenuBar <: AbstractMainMenuBar
    label::String
    menus::Vector{Menus.Menu}
    is_hidden::Bool
    is_triggered::Bool
end
MainMenuBar(label::AbstractString, menus = [], is_hidden = false) = 
    MainMenuBar(label, menus, is_hidden, false)

is_hidden(s::MainMenuBar) = s.is_hidden
is_triggered(s::MainMenuBar) = s.is_triggered

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::MainMenuBar, a::Rename) = MainMenuBar(a.new_label, s.menus, s.is_hidden, s.is_triggered)
reducer(s::MainMenuBar, a::SetTriggeredTo) = MainMenuBar(s.label, s.menus, s.is_hidden, a.is_triggered)
reducer(s::MainMenuBar, a::Show) = MainMenuBar(s.label, s.menus, false, s.is_triggered)
reducer(s::MainMenuBar, a::Hide) = MainMenuBar(s.label, s.menus, true, s.is_triggered)

reducer(s::MainMenuBar, a::EditMenus) =
    MainMenuBar(s.label, Menus.reducer(s.menus, a.action), s.is_hidden, s.is_triggered)

## UI
"""
    (::MainMenuBar)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity) -> Bool
Return `true` when triggered/activated.
`get_state` is a router function that tells how to find the target state from `store`. 
`chain_action` is for chaining upstream actions.
"""
function (::MainMenuBar)(store::AbstractStore, get_state=Redux.get_state, chain_action=identity)
    s = get_state(store)
    is_activated = CImGui.BeginMainMenuBar()
    dispatch!(
        store, 
        SetTriggeredTo(s.label, is_activated) |> chain_action,
    )
    if is_activated && !s.is_hidden
        for (i, menu) in enumerate(s.menus)
            menu(
                store, 
                x->get_state(x).menus[i],
                x->EditMenus(s.label, x) |> chain_action,
            )
        end
        CImGui.EndMainMenuBar()
    end
    return is_activated
end

end # module
