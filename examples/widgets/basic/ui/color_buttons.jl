using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function color_buttons(store::AbstractStore)
    i = 0
    for (k,v) in get_state(store).color_buttons
        label = ReduxImGui.get_label(v)
        dispatch!(store, RigColorButton.SetButtonColorTo(label, CImGui.HSV(i/7.0, 0.6, 0.6)))
        dispatch!(store, RigColorButton.SetHoveredColorTo(label, CImGui.HSV(i/7.0, 0.7, 0.7)))
        dispatch!(store, RigColorButton.SetActiveColorTo(label, CImGui.HSV(i/7.0, 0.8, 0.8)))
        if ReduxImGui.ColorButton(store, s->get_state(s).color_buttons[k])
            @info "This triggers $(@__FILE__):$(@__LINE__)."
        end
        CImGui.SameLine()
        i += 1
    end
    CImGui.NewLine()
end
