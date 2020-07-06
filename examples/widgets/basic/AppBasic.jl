module AppBasic

using ReduxImGui
using ReduxImGui.Redux

# state
struct State <: AbstractImmutableState
    buttons::Dict{String,ReduxButton.State}
    checkboxes::Dict{String,ReduxCheckbox.State}
end

# reducers
function app_basic(state::AbstractState, action::AbstractAction)
    next_button_state = ReduxButton.button(state.buttons, action)
    next_checkbox_state = ReduxCheckbox.checkbox(state.checkboxes, action)
    return State(next_button_state, next_checkbox_state)
end

end # module
