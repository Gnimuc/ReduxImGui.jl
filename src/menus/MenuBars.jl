module MenuBars

Base.Experimental.@optlevel 1

using Redux
using CImGui
using ..MenuItems
using ..ToggleMenuItems
using ..Menus
import ..Menus: AbstractMenuAction, AbstractMenuState, get_label

# actions
abstract type AbstractMenuBarAction <: AbstractSyncAction end

get_label(a::AbstractMenuBarAction) = a.label

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

# state
abstract type AbstractMenuBarState <: AbstractImmutableState end

"""
    MenuBars.State(label::AbstractString, menus = [], is_hidden = false)
A menu state which contains a label a.k.a the identifier, a list of menus, 
a flag value `is_hidden` and a flag value `is_triggered` that records the state of
the latest poll events.
"""
struct State <: AbstractMenuBarState
    label::String
    menus::Vector{Menu}
    is_hidden::Bool
    is_triggered::Bool
end
State(label::AbstractString, menus = [], is_hidden = false) = 
    State(label, menus, is_hidden, false)

get_label(s::State) = s.label
is_hidden(s::State) = s.is_hidden
is_triggered(s::State) = s.is_triggered

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.menus, s.is_hidden, s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.menus, s.is_hidden, a.is_triggered)
reducer(s::State, a::Show) = State(s.label, s.menus, false, s.is_triggered)
reducer(s::State, a::Hide) = State(s.label, s.menus, true, s.is_triggered)

reducer(s::State, a::EditMenus) =
    State(s.label, Menus.reducer(s.menus, a.action), s.is_hidden, s.is_triggered)

# helper
"""
    MenuBar(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when `ImGuiWindowFlags_MenuBar` is setted on the parent window.
`get_state` is a router function that tells how to find the target state from `store`. `chain_action` is for chaining upstream actions.
"""
function MenuBar(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_activated = CImGui.BeginMenuBar()
    dispatch!(store, SetTriggeredTo(s.label, is_activated))
    if is_activated && !s.is_hidden
        for i = 1:length(s.menus)
            Menus.Menu(store, s->get_state(s).menus[i])
        end
        CImGui.EndMenuBar()
    end
    return is_activated
end

"""
    MenuBar(f::Function)
Create a menu bar.
"""
function MenuBar(f::Function)
    if CImGui.BeginMenuBar()
        f()
        CImGui.EndMenuBar()
    end
    return nothing
end

end # module
