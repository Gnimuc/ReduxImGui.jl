module RigCheckbox

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
    SetTo(label, is_check)
Set checkbox state to `is_check`.
"""
struct SetTo <: AbstractCheckboxAction
    label::String
    is_check::Bool
end

# state
struct State <: AbstractImmutableState
    label::String
    is_check::Bool
end
State(label::AbstractString) = State(label, false)

# reducers
checkbox(state::AbstractState, action::AbstractAction) = state
checkbox(state::Vector{<:AbstractState}, action::AbstractAction) = state
checkbox(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function checkbox(state::Dict{String,State}, action::AbstractCheckboxAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = v.label == action.label ? checkbox(v, action) : v
    end
    return s
end

checkbox(s::State, a::Rename) = State(a.new_label, s.is_check)
checkbox(s::State, a::Toggle) = State(s.label, !s.is_check)
checkbox(s::State, a::Check) = State(s.label, true)
checkbox(s::State, a::Uncheck) = State(s.label, false)
checkbox(s::State, a::SetTo) = State(s.label, a.is_check)

# helper
"""
    Checkbox(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when pressed. See also [`is_check`](@ref).
"""
function Checkbox(store::AbstractStore, get_state=Redux.get_state)
    state = get_state(store)
    check_ref = Ref(state.is_check)
    is_pressed = CImGui.Checkbox(state.label, check_ref)
    is_pressed && dispatch!(store, SetTo(state.label, check_ref[]))
    return is_pressed
end

"""
    is_check(s::State) -> Bool
Return `true` when the checkbox is checked.
"""
is_check(s::State) = s.is_check

end # module
