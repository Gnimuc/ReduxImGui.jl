module RigRadioButton

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
    SetTo(label, is_active)
Set radio button's state to `is_active`.
"""
struct SetTo <: AbstractRadioButtonAction
    label::String
    is_active::Bool
end

# state
struct State <: AbstractImmutableState
    label::String
    is_active::Bool
end
State(label::AbstractString) = State(label, false)

# reducers
radio_button(state::AbstractState, action::AbstractAction) = state
radio_button(state::Vector{<:AbstractState}, action::AbstractAction) = state
radio_button(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function radio_button(state::Dict{String,State}, action::AbstractRadioButtonAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = v.label == action.label ? radio_button(v, action) : v
    end
    return s
end

radio_button(s::State, a::Rename) = State(a.new_label, s.size, s.is_active)
radio_button(s::State, a::SetTo) = State(s.label, a.is_active)

# helper
"""
    RadioButton(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when pressed and sets itself to be active.
See also [`is_active`](@ref).
"""
function RadioButton(store::AbstractStore, get_state=Redux.get_state)
    state = get_state(store)
    is_clicked = CImGui.RadioButton(state.label, state.is_active)
    is_clicked && dispatch!(store, SetTo(state.label, true))
    return is_clicked
end

"""
    is_active(s::State) -> Bool
Return `true` when the radio button is active.
"""
is_active(s::State) = s.is_active

end # module
