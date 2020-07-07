module AppBasic

using ReduxImGui
using ReduxImGui.Redux

# state
struct State <: AbstractImmutableState
    buttons::Dict{String,ReduxButton.State}
    checkboxes::Dict{String,ReduxCheckbox.State}
    radio_buttons::Dict{String,ReduxRadioButton.State}
    color_buttons::Dict{String,ReduxColorButton.State}
end

# reducers
function app_basic(state::AbstractState, action::AbstractAction)
    next_button_state = ReduxButton.button(state.buttons, action)
    next_checkbox_state = ReduxCheckbox.checkbox(state.checkboxes, action)
    next_radio_button_state = ReduxRadioButton.radio_button(state.radio_buttons, action)
    next_color_button_state = ReduxColorButton.color_button(state.color_buttons, action)
    return State(next_button_state,
                 next_checkbox_state,
                 next_radio_button_state,
                 next_color_button_state)
end

end # module
