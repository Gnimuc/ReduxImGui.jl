module RigRepeater

using ReduxImGui.Redux
using ReduxImGui.CImGui
using ReduxImGui.RigArrowButton

# actions
abstract type AbstractRepeaterAction <: AbstractSyncAction end

"""
    Increment(id)
Increment counter.
"""
struct Increment <: AbstractRepeaterAction
    id::String
end

"""
    Decrement(id)
Decrement counter.
"""
struct Decrement <: AbstractRepeaterAction
    id::String
end

"""
    ChangeArrowToUpDown(id)
Change arrow direction to up-down.
"""
struct ChangeArrowToUpDown <: AbstractRepeaterAction
    id::String
end

# state
struct State <: AbstractImmutableState
    id::String
    counter::Int
    button1::RigArrowButton.State
    button2::RigArrowButton.State
end
State(id::AbstractString, counter) = State(
    id,
    counter,
    RigArrowButton.State("##left", CImGui.ImGuiDir_Left),
    RigArrowButton.State("##right", CImGui.ImGuiDir_Right),
)
State(id::AbstractString) = State(id, 0)

# reducers
repeater(state::AbstractState, action::AbstractAction) = state
repeater(state::Vector{<:AbstractState}, action::AbstractAction) = state
repeater(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function repeater(state::Dict{String,State}, action::AbstractRepeaterAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = v.id == action.id ? repeater(v, action) : v
    end
    return s
end

repeater(s::State, a::Increment) = State(s.id, s.counter + 1, s.button1, s.button2)
repeater(s::State, a::Decrement) = State(s.id, s.counter - 1, s.button1, s.button2)
repeater(s::State, a::ChangeArrowToUpDown) = State(
    s.id,
    s.counter,
    RigArrowButton.State("##up", CImGui.ImGuiDir_Up),
    RigArrowButton.State("##down", CImGui.ImGuiDir_Down),
)

# helper
"""
    Repeater(store::AbstractStore, get_state=s->Redux.get_state(s)) -> Bool
Return `true` when pressed.
"""
function Repeater(store::AbstractStore, get_state=s->Redux.get_state(s))
    is_pressed = false
    spacing = CImGui.GetStyle().ItemInnerSpacing.x
    CImGui.PushButtonRepeat(true)
    if RigArrowButton.ArrowButton(store, s->get_state(s).button1)
        dispatch!(store, Decrement(get_state(store).id))
        is_pressed = true
    end
    CImGui.SameLine(0.0, spacing)
    if RigArrowButton.ArrowButton(store, s->get_state(s).button2)
        dispatch!(store, Increment(get_state(store).id))
        is_pressed = true
    end
    CImGui.PopButtonRepeat()
    CImGui.SameLine()
    CImGui.Text("$(get_state(store).counter)")
    return is_pressed
end

end
