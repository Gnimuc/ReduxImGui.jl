module RigInputFloat

using Redux
using CImGui
import ..ReduxImGui: get_label, get_values, get_value

# actions
abstract type AbstractInputFloatAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractInputFloatAction
    label::String
    new_label::String
end

"""
    ChangeSize(label, size)
Change widget size to `size`.
Note changing size also changes widget appearance. If the old size is bigger,
the old states are left intact.
"""
struct ChangeSize <: AbstractInputFloatAction
    size::Int
end

"""
    ChangeStep(label, step)
Change value's moving step to `step`.
This only takes effect when the widget size is 1.
"""
struct ChangeStep <: AbstractInputFloatAction
    step::Cfloat
end

"""
    ChangeSpeed(label, speed)
Change value's moving speed to `speed`.
This only takes effect when the widget size is 1.
"""
struct ChangeSpeed <: AbstractInputFloatAction
    speed::Cfloat
end

"""
    ChangeFormat(label, format)
Change value's format to `format`, e.g. "%.3f".
"""
struct ChangeFormat <: AbstractInputFloatAction
    format::String
end

# state
struct State <: AbstractImmutableState
    label::String
    vals::Vector{Cfloat}
    size::Int
    step::Cfloat
    speed::Cfloat
    format::String
    flags::CImGui.ImGuiInputTextFlags_
end
State(
    label::AbstractString;
    vals::Vector{Cfloat} = Cfloat[0, 0, 0, 0],
    size = 1,
    step = 0.0f0,
    speed = 0.0f0,
    format = "%.3f",
    flags = CImGui.ImGuiInputTextFlags_None,
) = State(label, vals, size, step, speed, format, flags)

State(label::AbstractString, val::AbstractFloat; args...) =
    State(label; vals = Cfloat[val, 0, 0, 0], args...)


# reducers
input_float(state::AbstractState, action::AbstractAction) = state
input_float(state::Vector{<:AbstractState}, action::AbstractAction) = state
input_float(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function input_float(state::Dict{String,State}, action::AbstractInputFloatAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? input_float(v, action) : v
    end
    return s
end

input_float(s::State, a::Rename) = State(a.new_label, s.vals, s.size, s.step, s.speed, s.flags)
input_float(s::State, a::ChangeSize) = State(s.label, s.vals, a.size, s.step, s.speed, s.flags)
input_float(s::State, a::ChangeStep) = State(s.label, s.vals, s.size, a.step, s.speed, s.flags)
input_float(s::State, a::ChangeSpeed) = State(s.label, s.vals, s.size, s.step, a.speed, s.flags)
input_float(s::State, a::ChangeFormat) = State(s.label, s.vals, s.size, s.step, s.speed, s.format)

# helper
"""
    InputFloat(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function InputFloat(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    if s.size == 1
        is_triggered = CImGui.InputFloat(get_label(s), s.vals, s.step, s.speed, s.format, s.flags)
    elseif s.size == 2
        is_triggered = CImGui.InputFloat2(get_label(s), s.vals, s.format, s.flags)
    elseif s.size == 3
        is_triggered = CImGui.InputFloat3(get_label(s), s.vals, s.format, s.flags)
    elseif s.size == 4
        is_triggered = CImGui.InputFloat4(get_label(s), s.vals, s.format, s.flags)
    else
        is_triggered = false
    end
    return is_triggered
end

get_label(s::State) = s.label
get_values(s::State) = s.vals

end # module
