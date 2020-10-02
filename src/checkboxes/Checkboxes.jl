module Checkboxes

Base.Experimental.@optlevel 1

using Redux
using CImGui

# actions
abstract type AbstractCheckboxAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change checkbox's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractCheckboxAction
    label::String
    new_label::String
end

"""
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractCheckboxAction
    label::String
    is_triggered::Bool
end

"""
    Toggle(label)
Toggle checkbox.
"""
struct Toggle <: AbstractCheckboxAction
    label::String
end

"""
    Check(label)
Set checkbox to be checked.
"""
struct Check <: AbstractCheckboxAction
    label::String
end

"""
    Uncheck(label)
Set checkbox to be unchecked.
"""
struct Uncheck <: AbstractCheckboxAction
    label::String
end

"""
    SetCheckedTo(label, is_check)
Set checkbox state to `is_check`.
"""
struct SetCheckedTo <: AbstractCheckboxAction
    label::String
    is_check::Bool
end

"""
    AddCheckbox(label::AbstractString, is_check = false)
Add a [`Checkbox`](@ref).
"""
struct AddCheckbox <: AbstractCheckboxAction
    label::String
    is_check::Bool
end
AddCheckbox(label::AbstractString) = AddCheckbox(label, false)

"""
    DeleteCheckbox(label::AbstractString)
Delete the [`Checkbox`](@ref).
"""
struct DeleteCheckbox <: AbstractCheckboxAction
    label::String
end

# state
abstract type AbstractCheckboxState <: AbstractImmutableState end

"""
    Checkboxes.State(label::AbstractString)
    Checkboxes.State(label::AbstractString, is_check)
    Checkboxes.State(label::AbstractString, is_check, is_triggered)
A simple checkbox state which contains a label a.k.a the identifier, a flag value that 
marks whether the widget is checked and a flag value `is_triggered` that records the 
state of the latest poll events.
"""
struct State <: AbstractCheckboxState
    label::String
    is_check::Bool
    is_triggered::Bool
end
State(label::AbstractString, is_check = false) = State(label, is_check, false)

# reducers
# reducer(state::AbstractState, action::AbstractAction) = state
# reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
# reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.is_check, s.is_triggered)
reducer(s::State, a::Toggle) = State(s.label, !s.is_check, s.is_triggered)
reducer(s::State, a::Check) = State(s.label, true, s.is_triggered)
reducer(s::State, a::Uncheck) = State(s.label, false, s.is_triggered)
reducer(s::State, a::SetCheckedTo) = State(s.label, a.is_check, s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.is_check, a.is_triggered)

reducer(s::Dict{String,<:AbstractCheckboxState}, a::AbstractCheckboxAction) =
    Dict(k => (get_label(v) == a.label ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{State}, a::AbstractCheckboxAction) = map(s) do s
    get_label(s) == a.label ? reducer(s, a) : s
end

reducer(s::Vector{State}, a::AddCheckbox) =
    State[s..., State(a.label, a.is_check, false)]
reducer(s::Vector{State}, a::DeleteCheckbox) = filter(s -> s.label !== a.label, s)


# helper
"""
    Checkbox(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
`get_state` is a router function that tells how to find the target state from `store`. `chain_action` is for chaining upstream actions.
"""
function Checkbox(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    check_ref = Ref(s.is_check)
    is_triggered = CImGui.Checkbox(s.label, check_ref)
    dispatch!(store, SetTriggeredTo(s.label, is_triggered))
    is_triggered && dispatch!(store, SetCheckedTo(s.label, check_ref[]))
    return is_triggered
end

get_label(s) = "__REDUX_IMGUI_RESERVED_DUMMY_LABEL"
get_label(s::State) = s.label

is_checked(s::State) = s.is_checked
is_triggered(s::State) = s.is_triggered

end # module
