module AppBasic

using ReduxImGui
using ReduxImGui.Redux

include("RigRepeater.jl")
using .RigRepeater

# state
struct State <: AbstractImmutableState
    buttons::Dict{String,RigButton.State}
    checkboxes::Dict{String,RigCheckbox.State}
    radio_buttons::Dict{String,RigRadioButton.State}
    color_buttons::Dict{String,RigColorButton.State}
    repeaters::Dict{String,RigRepeater.State}
    combos::Dict{String,RigCombo.State}
    input_texts::Dict{String,RigInputText.State}
    input_text_with_hints::Dict{String,RigInputTextWithHint.State}
    input_ints::Dict{String,RigInputInt.State}
end

# reducers
function app_basic(state::AbstractState, action::AbstractAction)
    next_button_state = RigButton.button(state.buttons, action)
    next_checkbox_state = RigCheckbox.checkbox(state.checkboxes, action)
    next_radio_button_state = RigRadioButton.radio_button(state.radio_buttons, action)
    next_color_button_state = RigColorButton.color_button(state.color_buttons, action)
    next_repeater_state = RigRepeater.repeater(state.repeaters, action)
    next_combo_state = RigCombo.combo(state.combos, action)
    next_input_text_state = RigInputText.input_text(state.input_texts, action)
    next_input_text_with_hint_state = RigInputTextWithHint.input_text_with_hint(state.input_text_with_hints, action)
    next_input_int_state = RigInputInt.input_int(state.input_ints, action)
    return State(next_button_state,
                 next_checkbox_state,
                 next_radio_button_state,
                 next_color_button_state,
                 next_repeater_state,
                 next_combo_state,
                 next_input_text_state,
                 next_input_text_with_hint_state,
                 next_input_int_state)
end

end # module
