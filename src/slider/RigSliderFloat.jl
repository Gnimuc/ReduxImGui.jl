module RigSliderFloat

using Redux
using CImGui
import ..ReduxImGui: get_label, get_values, get_value

# actions
abstract type AbstractSliderFloatAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractSliderFloatAction
    label::String
    new_label::String
end

"""
    ChangeSize(label, size)
Change widget size to `size`.
Note changing size also changes widget appearance. If the old size is bigger,
the old states are left intact.
"""
struct ChangeSize <: AbstractSliderFloatAction
    size::Int
end

"""
    ChangeRange(label, range)
Change widget range to `range`.
"""
struct ChangeRange <: AbstractSliderFloatAction
    range::Tuple{Cfloat,Cfloat}
end

"""
    ChangeRangeMaxTo(label, max)
Change widget max range to `max`.
"""
struct ChangeRangeMaxTo <: AbstractSliderFloatAction
    max::Cfloat
end

"""
    ChangeRangeMinTo(label, min)
Change widget min range to `min`.
"""
struct ChangeRangeMinTo <: AbstractSliderFloatAction
    min::Cfloat
end

"""
    ChangeFormat(label, format)
Change value's format to `format`, e.g. "%d".
"""
struct ChangeFormat <: AbstractSliderFloatAction
    format::String
end

"""
    ChangePower(label, pow)
Change power to `pow`, e.g. "%d".
"""
struct ChangePower <: AbstractSliderFloatAction
    power::Cfloat
end

# state
struct State <: AbstractImmutableState
    label::String
    vals::Vector{Cfloat}
    size::Int
    range::Tuple{Cfloat,Cfloat}
    format::String
    power::Cfloat
end
State(
    label::AbstractString;
    vals::Vector{Cfloat} = Cfloat[0, 0, 0, 0],
    size = 1,
    range = (0.0f0,0.0f0),
    format = "%.3f",
    power = 1.0f0,
) = State(label, vals, size, range, format, power)

State(label::AbstractString, val::AbstractFloat; args...) =
    State(label; vals = Cfloat[val, 0, 0, 0], args...)

# reducers
slider_float(state::AbstractState, action::AbstractAction) = state
slider_float(state::Vector{<:AbstractState}, action::AbstractAction) = state
slider_float(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function slider_float(state::Dict{String,State}, action::AbstractSliderFloatAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? slider_float(v, action) : v
    end
    return s
end

slider_float(s::State, a::Rename) = State(a.new_label, s.vals, s.size, s.range, s.format, s.power)
slider_float(s::State, a::ChangeSize) = State(s.label, s.vals, a.size, s.range, s.format, s.power)
slider_float(s::State, a::ChangeRange) = State(s.label, s.vals, s.size, a.range, s.format, s.power)
slider_float(s::State, a::ChangeRangeMaxTo) = State(s.label, s.vals, s.size, (s.range[1], a.max), s.format, s.power)
slider_float(s::State, a::ChangeRangeMinTo) = State(s.label, s.vals, s.size, (a.min, s.range[2]), s.format, s.power)
slider_float(s::State, a::ChangeFormat) = State(s.label, s.vals, s.size, s.range, a.format, s.power)
slider_float(s::State, a::ChangePower) = State(s.label, s.vals, s.size, s.range, s.format, a.power)

# helper
"""
    SliderFloat(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function SliderFloat(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    min, max = s.range
    if s.size == 1
        is_triggered = CImGui.SliderFloat(get_label(s), s.vals, min, max, s.format, s.power)
    elseif s.size == 2
        is_triggered = CImGui.SliderFloat2(get_label(s), s.vals, min, max, s.format, s.power)
    elseif s.size == 3
        is_triggered = CImGui.SliderFloat3(get_label(s), s.vals, min, max, s.format, s.power)
    elseif s.size == 4
        is_triggered = CImGui.SliderFloat4(get_label(s), s.vals, min, max, s.format, s.power)
    else
        is_triggered = false
    end
    return is_triggered
end

get_label(s::State) = s.label
get_values(s::State) = s.vals
get_value(s::State) = first(s.vals)

end # module
