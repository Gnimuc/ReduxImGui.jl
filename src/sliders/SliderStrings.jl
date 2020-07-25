module SliderStrings

using Redux
using CImGui
import ..ReduxImGui: get_label, get_string

# actions
abstract type AbstractSliderStringAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractSliderStringAction
    label::String
    new_label::String
end

"""
    ChangeStrings(label, strs)
Change widget strings to `strs`.
"""
struct ChangeStrings <: AbstractSliderStringAction
    label::String
    strs::Vector{String}
end

"""
    ChangeIndex(label, idx)
Change current strings to the one indexed by `idx`.
"""
struct ChangeIndex <: AbstractSliderStringAction
    label::String
    idx::Cint
end

# state
struct State <: AbstractImmutableState
    label::String
    strs::Vector{String}
    idx::Ref{Cint}
end
State(label::AbstractString, strs::Vector{<:AbstractString}) = State(label, strs, Ref{Cint}(1))

# reducers
slider_string(state::AbstractState, action::AbstractAction) = state
slider_string(state::Vector{<:AbstractState}, action::AbstractAction) = state
slider_string(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function slider_string(state::Dict{String,State}, action::AbstractSliderStringAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? slider_string(v, action) : v
    end
    return s
end

slider_string(s::State, a::Rename) = State(a.new_label, s.strs, s.idx)
slider_string(s::State, a::ChangeStrings) = State(s.label, a.strs, s.idx)
slider_string(s::State, a::ChangeIndex) = State(s.label, s.strs, Ref{Cint}(a.idx))

# helper
"""
    SliderString(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function SliderString(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    min, max = 1, length(s.strs)
    # str = min ≤ s.idx[] ≤ max ? s.strs[s.idx[]] : "Unknown"
    is_triggered = CImGui.SliderInt(get_label(s), s.idx, min, max, get_string(s))
    return is_triggered
end

get_label(s::State) = s.label
get_string(s::State) = s.strs[s.idx[]]

end # module
