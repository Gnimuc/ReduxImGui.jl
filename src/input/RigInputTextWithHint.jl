module RigInputTextWithHint

using Redux
using CImGui
using ..RigInputText
import ..RigInputText: AbstractInputTextAction, get_string, get_size
import ..ReduxImGui: get_label

# actions
abstract type AbstractInputTextWithHintAction <: AbstractInputTextAction end

"""
    SetHint(label, hint)
Set hint to `hint`.
"""
struct SetHint <: AbstractInputTextAction
    hint::String
end

# state
struct State <: AbstractImmutableState
    input_text::RigInputText.State
    hint::String
end
State(label::AbstractString, hint::AbstractString; varargs...) =
    State(RigInputText.State(label, varargs...), hint)

# reducers
input_text_with_hint(state::AbstractState, action::AbstractAction) = state
input_text_with_hint(state::Vector{<:AbstractState}, action::AbstractAction) = state
input_text_with_hint(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function input_text_with_hint(state::Dict{String,State}, action::AbstractInputTextAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? RigInputText.input_text(v, action) : v
    end
    return s
end

function input_text_with_hint(state::Dict{String,State}, action::AbstractInputTextWithHintAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? input_text_with_hint(v, action) : v
    end
    return s
end

input_text_with_hint(s::State, a::SetHint) = State(s.input_text, a.hint)

# helper
"""
    InputTextWithHint(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function InputTextWithHint(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_triggered = CImGui.InputTextWithHint(get_label(s), s.hint, get_string(s), get_size(s))
    return is_triggered
end

get_label(s::State) = get_label(s.input_text)
get_size(s::State) = get_size(s.input_text)

"""
    get_string(s::State) -> String
Return the current string.
"""
get_string(s::State) = get_string(s.input_text)

end # module
