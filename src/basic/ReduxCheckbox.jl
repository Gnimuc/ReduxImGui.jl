module ReduxCheckbox

using Redux
using CImGui

# actions
"""
    RenameTo(label)
Change checkbox label to `label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct RenameTo <: AbstractSyncAction
    label::String
end

"""
    Toggle()
Toggle checkbox.
"""
struct Toggle <: AbstractSyncAction end

"""
    Check()
Set checkbox to be checked.
"""
struct Check <: AbstractSyncAction end

"""
    Uncheck()
Set checkbox to be unchecked.
"""
struct Uncheck <: AbstractSyncAction end

"""
    SetTo(is_check)
Set checkbox state to be the same as `is_check`.
"""
struct SetTo <: AbstractSyncAction
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
checkbox(s::State, a::RenameTo) = State(a.label, s.is_check)
checkbox(s::State, a::Toggle) = State(s.label, !s.is_check)
checkbox(s::State, a::Check) = State(s.label, true)
checkbox(s::State, a::Uncheck) = State(s.label, false)
checkbox(s::State, a::SetTo) = State(s.label, a.is_check)

# helper
function Checkbox(store::AbstractStore, state::State)
    check_ref = Ref(state.is_check)
    is_pressed = CImGui.Checkbox(state.label, check_ref)
    is_pressed && dispatch!(store, SetTo(check_ref[]))
    return is_pressed
end

end # module
