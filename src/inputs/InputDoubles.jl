module InputDoubles

using Redux
using CImGui
import ..ReduxImGui: get_label, get_value

# actions
abstract type AbstractInputDoubleAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractInputDoubleAction
    label::String
    new_label::String
end

"""
    ChangeStep(label, step)
Change value's moving step to `step`.
"""
struct ChangeStep <: AbstractInputDoubleAction
    label::String
    step::Cdouble
end

"""
    ChangeSpeed(label, speed)
Change value's moving speed to `speed`.
"""
struct ChangeSpeed <: AbstractInputDoubleAction
    label::String
    speed::Cdouble
end

"""
    ChangeFormat(label, format)
Change value's format to `format`, e.g. "%.6f".
"""
struct ChangeFormat <: AbstractInputDoubleAction
    label::String
    format::String
end

# state
struct State <: AbstractImmutableState
    label::String
    vals::Vector{Cdouble}
    step::Cdouble
    speed::Cdouble
    format::String
    flags::CImGui.ImGuiInputTextFlags_
end
State(
    label::AbstractString;
    vals::Vector{Cdouble} = Cdouble[0.0],
    step = 0.0,
    speed = 0.0,
    format = "%.6f",
    flags = CImGui.ImGuiInputTextFlags_None,
) = State(label, vals, step, speed, format, flags)

State(label::AbstractString, val::AbstractFloat; args...) =
    State(label; vals = Cdouble[val], args...)

# reducers
input_double(state::AbstractState, action::AbstractAction) = state
input_double(state::Vector{<:AbstractState}, action::AbstractAction) = state
input_double(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function input_double(state::Dict{String,State}, action::AbstractInputDoubleAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? input_double(v, action) : v
    end
    return s
end

input_double(s::State, a::Rename) = State(a.new_label, s.val, s.step, s.speed, s.format, s.flags)
input_double(s::State, a::ChangeStep) = State(s.label, s.val, a.step, s.speed, s.format, s.flags)
input_double(s::State, a::ChangeSpeed) = State(s.label, s.val, s.step, a.speed, s.format, s.flags)
input_double(s::State, a::ChangeFormat) = State(s.label, s.val, s.step, s.speed, a.format, s.flags)

# helper
"""
    InputDouble(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function InputDouble(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    is_triggered = CImGui.InputDouble(get_label(s), s.vals, s.step, s.speed, s.format, s.flags)
    return is_triggered
end

get_label(s::State) = s.label
get_values(s::State) = s.vals
get_value(s::State) = first(s.vals)

end # module
