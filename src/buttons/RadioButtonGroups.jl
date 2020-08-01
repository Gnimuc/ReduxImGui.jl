module RadioButtonGroups

using Redux
using CImGui
using ..RadioButtons
import ..RadioButtons: AbstractRadioButtonAction, AbstractRadioButtonState

# actions
abstract type AbstractRadioButtonGroupAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change radio button group's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractRadioButtonGroupAction
    label::String
    new_label::String
end

"""
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractRadioButtonGroupAction
    label::String
    is_triggered::Bool
end

"""
    EditButtons(label::AbstractString, action)
Edit radio buttons in the radio button group.
"""
struct EditButtons{T<:AbstractRadioButtonAction} <: AbstractRadioButtonGroupAction
    label::String
    action::T
end

# state
abstract type AbstractRadioButtonGroupstate <: AbstractImmutableState end

"""
    RadioButtonGroups.State(label::AbstractString, is_active = false, is_triggered = false)
A radio button state which contains a label a.k.a the identifier, a list of radio buttons and
a flag value `is_triggered` that records the state of the latest poll events.
"""
struct State <: AbstractRadioButtonState
    label::String
    buttons::Vector{RadioButtons.State}
    is_triggered::Bool
end
State(label::AbstractString, buttons = []) = State(label, buttons, false)

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.buttons, s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.buttons, a.is_triggered)
reducer(s::State, a::EditButtons) = 
    State(s.label, RadioButtons.reducer(s.buttons, a.action), s.is_triggered)

reducer(s::Dict{String,<:AbstractRadioButtonState}, a::AbstractRadioButtonGroupAction) =
    Dict(k => (get_label(v) == a.label ? reducer(v, a) : v) for (k, v) in s)

# helper
"""
    RadioButtonGroup(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
`get_state` is a router function which tells how to find the target button
state from `store`.
"""
function RadioButtonGroup(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_triggered = false
    for rb in s.buttons
        flag = CImGui.RadioButton(rb.label, rb.is_active)
        dispatch!(store, EditButtons(s.label, RadioButtons.SetTriggeredTo(rb.label, flag)))
        if flag
            dispatch!(store, EditButtons(s.label, RadioButtons.OnlySetThisOneToActive(rb.label)))
            is_triggered = true
        end
        CImGui.SameLine()
    end
    CImGui.NewLine()
    return is_triggered
end

get_label(s) = "__REDUX_IMGUI_RESERVED_DUMMY_LABEL"
get_label(s::State) = s.label

is_triggered(s::State) = s.is_triggered


end # module
