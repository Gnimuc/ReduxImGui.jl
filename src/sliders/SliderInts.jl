module SliderInts

using Redux
using CImGui
import ..ReduxImGui: get_label, get_values, get_value

# actions
abstract type AbstractSliderIntAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractSliderIntAction
    label::String
    new_label::String
end

"""
    ChangeSize(label, size)
Change widget size to `size`.
Note changing size also changes widget appearance. If the old size is bigger,
those unused states are left intact.
"""
struct ChangeSize <: AbstractSliderIntAction
    label::String
    size::Int
end

"""
    ChangeRange(label, range)
Change widget range to `range`.
"""
struct ChangeRange <: AbstractSliderIntAction
    label::String
    range::Tuple{Cint,Cint}
end

"""
    ChangeRangeMaxTo(label, max)
Change widget max range to `max`.
"""
struct ChangeRangeMaxTo <: AbstractSliderIntAction
    label::String
    max::Cint
end

"""
    ChangeRangeMinTo(label, min)
Change widget min range to `min`.
"""
struct ChangeRangeMinTo <: AbstractSliderIntAction
    label::String
    min::Cint
end

"""
    ChangeFormat(label, format)
Change value's format to `format`, e.g. "%d".
"""
struct ChangeFormat <: AbstractSliderIntAction
    label::String
    format::String
end

# state
struct State <: AbstractImmutableState
    label::String
    vals::Vector{Cint}
    size::Int
    range::Tuple{Cint,Cint}
    format::String
end
State(
    label::AbstractString;
    vals::Vector{Cint} = Cint[0, 0, 0, 0],
    size = 1,
    range = (Cint(0),Cint(0)),
    format = "%d",
) = State(label, vals, size, range, format)

State(label::AbstractString, val::Integer; args...) =
    State(label; vals = Cint[val, 0, 0, 0], args...)

# reducers
slider_int(state::AbstractState, action::AbstractAction) = state
slider_int(state::Vector{<:AbstractState}, action::AbstractAction) = state
slider_int(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function slider_int(state::Dict{String,State}, action::AbstractSliderIntAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? slider_int(v, action) : v
    end
    return s
end

slider_int(s::State, a::Rename) = State(a.new_label, s.vals, s.size, s.range, s.format)
slider_int(s::State, a::ChangeSize) = State(s.label, s.vals, a.size, s.range, s.format)
slider_int(s::State, a::ChangeRange) = State(s.label, s.vals, s.size, a.range, s.format)
slider_int(s::State, a::ChangeRangeMaxTo) = State(s.label, s.vals, s.size, (s.range[1], a.max), s.format)
slider_int(s::State, a::ChangeRangeMinTo) = State(s.label, s.vals, s.size, (a.min, s.range[2]), s.format)
slider_int(s::State, a::ChangeFormat) = State(s.label, s.vals, s.size, s.range, a.format)

# helper
"""
    SliderInt(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function SliderInt(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    min, max = s.range
    if s.size == 1
        is_triggered = CImGui.SliderInt(get_label(s), s.vals, min, max, s.format)
    elseif s.size == 2
        is_triggered = CImGui.SliderInt2(get_label(s), s.vals, min, max, s.format)
    elseif s.size == 3
        is_triggered = CImGui.SliderInt3(get_label(s), s.vals, min, max, s.format)
    elseif s.size == 4
        is_triggered = CImGui.SliderInt4(get_label(s), s.vals, min, max, s.format)
    else
        is_triggered = false
    end
    return is_triggered
end

get_label(s::State) = s.label
get_values(s::State) = s.vals
get_value(s::State) = first(s.vals)

end # module
