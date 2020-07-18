module RigInputInt

using Redux
using CImGui
import ..ReduxImGui: get_label

# actions
abstract type AbstractInputIntAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractInputIntAction
    label::String
    new_label::String
end

"""
    ChangeSize(label, size)
Change widget size to `size`.
Note changing size also changes widget appearance. If the old size is bigger,
the old states are left intact.
"""
struct ChangeSize <: AbstractInputIntAction
    size::Int
end

"""
    ChangeStep(label, step)
Change value's moving step to `step`.
This only takes effect when the widget size is 1.
"""
struct ChangeStep <: AbstractInputIntAction
    step::Int
end

"""
    ChangeSpeed(label, speed)
Change value's moving speed to `speed`.
This only takes effect when the widget size is 1.
"""
struct ChangeSpeed <: AbstractInputIntAction
    speed::Int
end

# state
struct State <: AbstractImmutableState
    label::String
    vals::Vector{Cint}
    size::Int
    step::Int
    speed::Int
    flags::CImGui.ImGuiInputTextFlags_
end
State(
    label::AbstractString;
    vals = Cint[0,0,0,0],
    size = 1,
    step = 1,
    speed = 100,
    flags = CImGui.ImGuiInputTextFlags_None,
) = State(label, vals, size, step, speed, flags)

# reducers
input_int(state::AbstractState, action::AbstractAction) = state
input_int(state::Vector{<:AbstractState}, action::AbstractAction) = state
input_int(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function input_int(state::Dict{String,State}, action::AbstractInputIntAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? input_int(v, action) : v
    end
    return s
end

input_int(s::State, a::Rename) = State(a.new_label, s.vals, s.size, s.step, s.speed, s.flags)
input_int(s::State, a::ChangeSize) = State(s.label, s.vals, a.size, s.step, s.speed, s.flags)
input_int(s::State, a::ChangeStep) = State(s.label, s.vals, s.size, a.step, s.speed, s.flags)
input_int(s::State, a::ChangeSpeed) = State(s.label, s.vals, s.size, s.step, a.speed, s.flags)

# helper
"""
    InputInt(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function InputInt(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    if s.size == 1
        is_triggered = CImGui.InputInt(get_label(s), s.vals, s.step, s.speed, s.flags)
    elseif s.size == 2
        is_triggered = CImGui.InputInt2(get_label(s), s.vals, s.flags)
    elseif s.size == 3
        is_triggered = CImGui.InputInt3(get_label(s), s.vals, s.flags)
    elseif s.size == 4
        is_triggered = CImGui.InputInt4(get_label(s), s.vals, s.flags)
    else
        is_triggered = false
    end
    return is_triggered
end

get_label(s::State) = s.label

"""
    get_values(s::State) -> String
Return the current values.
"""
get_values(s::State) = s.vals

end # module
