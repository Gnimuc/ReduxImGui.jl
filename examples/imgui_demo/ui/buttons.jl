using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_button(store::AbstractStore, get_state=Redux.get_state)
    if ReduxImGui.Button(store, s->get_state(s).buttons["basic_button"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
    # this works like a button with on/off state
    if ReduxImGui.is_on(get_state(store).buttons["basic_button"])
        CImGui.SameLine()
        CImGui.Text("Thanks for clicking me!")
    end
end

function color_buttons(store::AbstractStore, get_state=Redux.get_state)
    i = 0
    for (k,v) in get_state(store).color_buttons
        label = ReduxImGui.get_label(v)
        dispatch!(store, ColorButtons.SetButtonColorTo(label, CImGui.HSV(i/7.0, 0.6, 0.6)))
        dispatch!(store, ColorButtons.SetHoveredColorTo(label, CImGui.HSV(i/7.0, 0.7, 0.7)))
        dispatch!(store, ColorButtons.SetActiveColorTo(label, CImGui.HSV(i/7.0, 0.8, 0.8)))
        if ReduxImGui.ColorButton(store, s->get_state(s).color_buttons[k])
            @info "This triggers $(@__FILE__):$(@__LINE__)."
        end
        CImGui.SameLine()
        i += 1
    end
    CImGui.NewLine()
end

function radio_button_group(store::AbstractStore, get_state=Redux.get_state)
    state = get_state(store)
    if ReduxImGui.RadioButton(store, s->get_state(s).radio_buttons["basic_radio_button1"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        b2 = state.radio_buttons["basic_radio_button2"]
        b3 = state.radio_buttons["basic_radio_button3"]
        dispatch!(store, RadioButtons.SetActiveTo(b2.label, false))
        dispatch!(store, RadioButtons.SetActiveTo(b3.label, false))
    end
    CImGui.SameLine()

    state = get_state(store)
    if ReduxImGui.RadioButton(store, s->get_state(s).radio_buttons["basic_radio_button2"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        b1 = state.radio_buttons["basic_radio_button1"]
        b3 = state.radio_buttons["basic_radio_button3"]
        dispatch!(store, RadioButtons.SetActiveTo(b1.label, false))
        dispatch!(store, RadioButtons.SetActiveTo(b3.label, false))
    end
    CImGui.SameLine()

    state = get_state(store)
    if ReduxImGui.RadioButton(store, s->get_state(s).radio_buttons["basic_radio_button3"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        b1 = state.radio_buttons["basic_radio_button1"]
        b2 = state.radio_buttons["basic_radio_button2"]
        dispatch!(store, RadioButtons.SetActiveTo(b1.label, false))
        dispatch!(store, RadioButtons.SetActiveTo(b2.label, false))
    end
end
