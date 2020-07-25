module AppBasic

using ReduxImGui
using ReduxImGui.Redux

include("RigRepeater.jl")
using .RigRepeater

# state
struct State <: AbstractImmutableState
    buttons::Dict{String,Buttons.State}
    checkboxes::Dict{String,Checkboxes.State}
    radio_buttons::Dict{String,RadioButtons.State}
    color_buttons::Dict{String,ColorButtons.State}
    repeaters::Dict{String,RigRepeater.State}
    combos::Dict{String,Combos.State}
    input_texts::Dict{String,InputTexts.State}
    input_text_with_hints::Dict{String,InputTextWithHints.State}
    input_ints::Dict{String,InputInts.State}
    input_floats::Dict{String,InputFloats.State}
    input_doubles::Dict{String,InputDoubles.State}
    drag_ints::Dict{String,DragInts.State}
    drag_floats::Dict{String,DragFloats.State}
    slider_ints::Dict{String,SliderInts.State}
    slider_floats::Dict{String,SliderFloats.State}
    slider_angles::Dict{String,SliderAngles.State}
    slider_strings::Dict{String,SliderStrings.State}
    color_edits::Dict{String,ColorEdits.State}
end

# reducers
function app_basic(state::AbstractState, action::AbstractAction)
    next_button_state = Buttons.button(state.buttons, action)
    next_checkbox_state = Checkboxes.checkbox(state.checkboxes, action)
    next_radio_button_state = RadioButtons.radio_button(state.radio_buttons, action)
    next_color_button_state = ColorButtons.color_button(state.color_buttons, action)
    next_repeater_state = RigRepeater.repeater(state.repeaters, action)
    next_combo_state = Combos.combo(state.combos, action)
    next_input_text_state = InputTexts.input_text(state.input_texts, action)
    next_input_text_with_hint_state = InputTextWithHints.input_text_with_hint(state.input_text_with_hints, action)
    next_input_int_state = InputInts.input_int(state.input_ints, action)
    next_input_float_state = InputFloats.input_float(state.input_floats, action)
    next_input_double_state = InputDoubles.input_double(state.input_doubles, action)
    next_drag_int_state = DragInts.drag_int(state.drag_ints, action)
    next_drag_float_state = DragFloats.drag_float(state.drag_floats, action)
    next_slider_int_state = SliderInts.slider_int(state.slider_ints, action)
    next_slider_float_state = SliderFloats.slider_float(state.slider_floats, action)
    next_slider_angle_state = SliderAngles.slider_angle(state.slider_angles, action)
    next_slider_string_state = SliderStrings.slider_string(state.slider_strings, action)
    next_color_edit_state = ColorEdits.color_edit(state.color_edits, action)
    return State(next_button_state,
                 next_checkbox_state,
                 next_radio_button_state,
                 next_color_button_state,
                 next_repeater_state,
                 next_combo_state,
                 next_input_text_state,
                 next_input_text_with_hint_state,
                 next_input_int_state,
                 next_input_float_state,
                 next_input_double_state,
                 next_drag_int_state,
                 next_drag_float_state,
                 next_slider_int_state,
                 next_slider_float_state,
                 next_slider_angle_state,
                 next_slider_string_state,
                 next_color_edit_state)
end

end # module
