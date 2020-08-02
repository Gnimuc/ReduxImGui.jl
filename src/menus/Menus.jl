module Menus

using Redux
using CImGui
using ..MenuItems
import ..MenuItems: AbstractMenuItemAction, AbstractMenuItemState

# actions
abstract type AbstractMenuAction <: AbstractSyncAction end

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
    EditMenuItems(label, action::AbstractMenuItemAction)
Edit manu items.
"""
struct EditMenuItems{T<:AbstractMenuItemAction} <: AbstractMenuAction
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
    items::Vector{MenuItems.State}
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

# state
abstract type AbstractMenuState <: AbstractImmutableState end

"""
    Menus.State(label::AbstractString, items = [], is_enabled = true)
A menu state which contains a label a.k.a the identifier, a list of menu items, 
a flag value `is_enabled` and a flag value `is_triggered` that records the state of
the latest poll events.
"""
struct State <: AbstractMenuState
    label::String
    items::Vector{MenuItems.State}
    is_enabled::Bool
    is_triggered::Bool
end
State(label::AbstractString, items = [], is_enabled = true) = 
    State(label, items, is_enabled, false)

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.items, s.is_enabled, s.is_triggered)
reducer(s::State, a::Enable) = State(s.label, s.items, true, s.is_triggered)
reducer(s::State, a::Disable) = State(s.label, s.items, false, s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.items, s.is_enabled, a.is_triggered)
reducer(s::State, a::EditMenuItems) =
    State(s.label, MenuItems.reducer(s.items, a.action), s.is_enabled, s.is_triggered)

reducer(s::Dict{String,<:AbstractMenuState}, a::AbstractMenuAction) =
    Dict(k => (get_label(v) == a.label ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{State}, a::AbstractMenuAction) = map(s) do s
    get_label(s) === a.label ? reducer(s, a) : s
end

reducer(s::Vector{State}, a::AddMenu) =
    State[s..., State(a.label, a.items, a.is_enabled, false)]
reducer(s::Vector{State}, a::DeleteMenu) = filter(s -> s.label !== a.label, s)

# helper
"""
    Menu(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when activated.
"""
function Menu(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_activated = CImGui.BeginMenu(s.label, s.is_enabled)
    if is_activated
        for item in s.items
            CImGui.MenuItem(item.label, item.shortcut, item.is_selected, item.is_enabled)
        end
        CImGui.EndMenu()
    end
    return is_activated
end

"""
    Menu(f::Function, label::AbstractString, enabled=true) -> Bool
Create a sub-menu entry.
"""
function Menu(f::Function, label::AbstractString, enabled=true)
    if CImGui.BeginMenu(label, enabled)
        f()
        CImGui.EndMenu()
    end
    return nothing
end

get_label(s) = "__REDUX_IMGUI_RESERVED_DUMMY_LABEL"
get_label(s::State) = s.label

is_enabled(s::State) = s.is_enabled
is_triggered(s::State) = s.is_triggered


end # module
