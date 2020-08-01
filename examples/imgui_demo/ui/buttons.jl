using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui
using ReduxImGui.OnOffButtons

function basic_button(store::AbstractStore, get_state=Redux.get_state)
    if ReduxImGui.OnOffButton(store, s->get_state(s).buttons["basic_button"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
    # this works like a button with on/off state
    if OnOffButtons.is_on(get_state(store).buttons["basic_button"])
        CImGui.SameLine()
        CImGui.Text("Thanks for clicking me!")
    end
end

function radio_button_group(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    if ReduxImGui.RadioButtonGroup(store, s->get_state(s).radio_button_group)
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
end

function color_buttons(store::AbstractStore, get_state=Redux.get_state)
    for (i, cb) in enumerate(get_state(store).colorful_buttons)
        label = ReduxImGui.ColorButtons.get_label(cb)
        dispatch!(store, ColorButtons.SetButtonColorTo(label, CImGui.HSV((i-1)/7.0, 0.6, 0.6)))
        dispatch!(store, ColorButtons.SetHoveredColorTo(label, CImGui.HSV((i-1)/7.0, 0.7, 0.7)))
        dispatch!(store, ColorButtons.SetActiveColorTo(label, CImGui.HSV((i-1)/7.0, 0.8, 0.8)))
        if ReduxImGui.ColorButton(store, s->get_state(s).colorful_buttons[i])
            @info "This triggers $(@__FILE__):$(@__LINE__)."
        end
        CImGui.SameLine()
    end
    CImGui.NewLine()
end


