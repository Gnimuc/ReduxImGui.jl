module OnOffButtons

Base.Experimental.@optlevel 1

using Redux
using CImGui
using ..Buttons
import ..Buttons: AbstractButtonAction, AbstractButtonState, get_label

# actions
const Rename = Buttons.Rename 
const SetTriggeredTo = Buttons.SetTriggeredTo
const Resize = Buttons.Resize 
const ChangeWidth = Buttons.ChangeWidth 
const ChangeHeight = Buttons.ChangeHeight 

"""
    Toggle(label)
Toggle button's `is_on` state.
"""
struct Toggle <: AbstractButtonAction
    label::String
end

"""
    AddButton(label::AbstractString, size = (0,0))
Add a [`OnOffButton`](@ref).
"""
struct AddButton <: AbstractButtonAction
    button::Buttons.State
    is_on::Bool
end
AddButton(label::AbstractString, size) = AddButton(Buttons.State(label, size, false), false)
AddButton(label::AbstractString) = AddButton(label, (0,0))

get_label(a::AddButton) = a.button.label

"""
    DeleteButton(label::AbstractString)
Delete the [`OnOffButton`](@ref).
"""
struct DeleteButton <: AbstractButtonAction
    label::String
end

"""
    OnOffButtons.State(label::AbstractString)
    OnOffButtons.State(label::AbstractString, size)
    OnOffButtons.State(label::AbstractString, size, is_on)
A on/off button state which contains a common button plus a flag value `is_on`.
"""
struct State <: AbstractButtonState
    button::Buttons.State
    is_on::Bool
end
State(label::AbstractString, size) = State(Buttons.State(label, size, false), false)
State(label::AbstractString) = State(label, (0,0))

get_label(s::State) = s.button.label
get_size(s::State) = s.button.size
is_triggered(s::State) = s.button.is_triggered
is_on(s::State) = s.is_on

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::AbstractButtonAction) = State(Buttons.reducer(s.button, a), s.is_on)
reducer(s::State, a::Toggle) = State(s.button, !s.is_on)

reducer(s::Dict{String,<:AbstractButtonState}, a::AbstractButtonAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractButtonState}, a::AbstractButtonAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end

reducer(s::Vector{<:AbstractButtonState}, a::AddButton) = [s..., State(a.button, a.is_on)]
reducer(s::Vector{<:AbstractButtonState}, a::DeleteButton) = filter(s -> get_label(s) !== get_label(a), s)

# helper
"""
    OnOffButton(store::AbstractStore, get_state=Redux.get_state) -> Bool
A wrapper over [`Buttons.Button`](@ref) with an additional on/off state.
"""
function OnOffButton(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_triggered = CImGui.Button(get_label(s), CImGui.ImVec2(get_size(s)...))
    dispatch!(store, Buttons.SetTriggeredTo(get_label(s), is_triggered))
    is_triggered && dispatch!(store, Toggle(get_label(s)))
    return is_triggered
end

end # module
