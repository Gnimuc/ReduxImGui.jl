using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function radio_button_group(store::AbstractStore)
    state = get_state(store)
    if ReduxImGui.RadioButton(store, s->get_state(s).radio_buttons["basic_radio_button1"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        dispatch!(store, RigRadioButton.SetTo(state.radio_buttons["basic_radio_button2"].label, false))
        dispatch!(store, RigRadioButton.SetTo(state.radio_buttons["basic_radio_button3"].label, false))
    end
    CImGui.SameLine()
    state = get_state(store)
    if ReduxImGui.RadioButton(store, s->get_state(s).radio_buttons["basic_radio_button2"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        dispatch!(store, RigRadioButton.SetTo(state.radio_buttons["basic_radio_button1"].label, false))
        dispatch!(store, RigRadioButton.SetTo(state.radio_buttons["basic_radio_button3"].label, false))
    end
    CImGui.SameLine()
    state = get_state(store)
    if ReduxImGui.RadioButton(store, s->get_state(s).radio_buttons["basic_radio_button3"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        dispatch!(store, RigRadioButton.SetTo(state.radio_buttons["basic_radio_button1"].label, false))
        dispatch!(store, RigRadioButton.SetTo(state.radio_buttons["basic_radio_button2"].label, false))
    end
end
