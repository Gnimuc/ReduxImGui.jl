module SliderAngles

using Redux
using CImGui
import ..ReduxImGui: get_label, get_values, get_value

# actions
abstract type AbstractSliderAngleAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractSliderAngleAction
    label::String
    new_label::String
end

"""
    ChangeRange(label, range)
Change widget range to `range`.
"""
struct ChangeRange <: AbstractSliderAngleAction
    label::String
    range::Tuple{Cfloat,Cfloat}
end

"""
    ChangeRangeMaxTo(label, max)
Change widget max range to `max`.
"""
struct ChangeRangeMaxTo <: AbstractSliderAngleAction
    label::String
    max::Cfloat
end

"""
    ChangeRangeMinTo(label, min)
Change widget min range to `min`.
"""
struct ChangeRangeMinTo <: AbstractSliderAngleAction
    label::String
    min::Cfloat
end

"""
    ChangeFormat(label, format)
Change value's format to `format`, e.g. "%d".
"""
struct ChangeFormat <: AbstractSliderAngleAction
    label::String
    format::String
end

# state
struct State <: AbstractImmutableState
    label::String
    vals::Vector{Cfloat}
    range::Tuple{Cfloat,Cfloat}
    format::String
end
State(
    label::AbstractString;
    vals::Vector{Cfloat} = Cfloat[0],
    range = (-360.0f0,360.0f0),
    format = "%.0f deg",
) = State(label, vals, range, format)

State(label::AbstractString, val::AbstractFloat; args...) =
    State(label; vals = Cfloat[val], args...)

# reducers
slider_angle(state::AbstractState, action::AbstractAction) = state
slider_angle(state::Vector{<:AbstractState}, action::AbstractAction) = state
slider_angle(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function slider_angle(state::Dict{String,State}, action::AbstractSliderAngleAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? slider_angle(v, action) : v
    end
    return s
end

slider_angle(s::State, a::Rename) = State(a.new_label, s.vals, s.range, s.format)
slider_angle(s::State, a::ChangeRange) = State(s.label, s.vals, a.range, s.format)
slider_angle(s::State, a::ChangeRangeMaxTo) = State(s.label, s.vals, (s.range[1], a.max), s.format)
slider_angle(s::State, a::ChangeRangeMinTo) = State(s.label, s.vals, (a.min, s.range[2]), s.format)
slider_angle(s::State, a::ChangeFormat) = State(s.label, s.vals, s.range, a.format)

# helper
"""
    SliderAngle(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function SliderAngle(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    min, max = s.range
    is_triggered = CImGui.SliderAngle(get_label(s), s.vals, min, max, s.format)
    return is_triggered
end

get_label(s::State) = s.label
get_values(s::State) = s.vals
get_value(s::State) = first(s.vals)

end # module
