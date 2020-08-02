module RadioButtons

using Redux
using CImGui

# actions
abstract type AbstractRadioButtonAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change radio button's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractRadioButtonAction
    label::String
    new_label::String
end

"""
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractRadioButtonAction
    label::String
    is_triggered::Bool
end

"""
    SetActiveTo(label, is_active)
Set radio button's state to `is_active`.
"""
struct SetActiveTo <: AbstractRadioButtonAction
    label::String
    is_active::Bool
end

"""
    AddButton(label::AbstractString, is_active = false)
Add a [`RadioButton`](@ref).
"""
struct AddButton <: AbstractRadioButtonAction
    label::String
    is_active::Bool
end
AddButton(label::AbstractString) = AddButton(label, false)

"""
    DeleteButton(label::AbstractString)
Delete the [`RadioButton`](@ref).
"""
struct DeleteButton <: AbstractRadioButtonAction
    label::String
end

"""
    OnlySetThisOneToActive(label::AbstractString)
Clear all the `is_active` states in the button list and only set the `label`'s `is_active` state to active.  
"""
struct OnlySetThisOneToActive <: AbstractRadioButtonAction
    label::String
end

# state
abstract type AbstractRadioButtonState <: AbstractImmutableState end

"""
    RadioButtons.State(label::AbstractString, is_active = false, is_triggered = false)
A radio button state which contains a label a.k.a the identifier, a flag value `is_active` and 
a flag value `is_triggered` that records the state of the latest poll events.
"""
struct State <: AbstractRadioButtonState
    label::String
    is_active::Bool
    is_triggered::Bool
end
State(label::AbstractString, is_active = false) = State(label, is_active, false)

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.is_active, s.is_triggered)
reducer(s::State, a::SetActiveTo) = State(s.label, a.is_active, s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.is_active, a.is_triggered)

reducer(s::Dict{String,<:AbstractRadioButtonState}, a::AbstractRadioButtonAction) =
    Dict(k => (get_label(v) == a.label ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{State}, a::AbstractRadioButtonAction) = map(s) do s
    get_label(s) === a.label ? reducer(s, a) : s
end

reducer(s::Vector{State}, a::OnlySetThisOneToActive) = map(s) do s
    get_label(s) === a.label ? State(s.label, true, s.is_triggered) : State(s.label, false, s.is_triggered)
end

reducer(s::Vector{State}, a::AddButton) =
    State[s..., State(a.label, a.is_active, false)]
reducer(s::Vector{State}, a::DeleteButton) = filter(s -> s.label !== a.label, s)


# helper
"""
    RadioButton(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
`get_state` is a router function which tells how to find the target state from `store`.
"""
function RadioButton(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_triggered = CImGui.RadioButton(s.label, s.is_active)
    dispatch!(store, SetTriggeredTo(s.label, is_triggered))
    is_triggered && dispatch!(store, SetActiveTo(s.label, true))
    return is_triggered
end

get_label(s) = "__REDUX_IMGUI_RESERVED_DUMMY_LABEL"
get_label(s::State) = s.label

is_active(s::State) = s.is_active
is_triggered(s::State) = s.is_triggered


end # module
