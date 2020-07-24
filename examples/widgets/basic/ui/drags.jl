using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_drag_int(store::AbstractStore)
    if ReduxImGui.DragInt(store, s->get_state(s).drag_ints["basic_drag_int"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).drag_ints["basic_drag_int"])
        @info "Current value: $v"
    end
    CImGui.SameLine()
    ShowHelpMarker("Click and drag to edit value.\nHold SHIFT/ALT for faster/slower edit.\nDouble-click or CTRL+click to input value.")
    if ReduxImGui.DragInt(store, s->get_state(s).drag_ints["basic_drag_int2"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).drag_ints["basic_drag_int2"])
        @info "Current value: $v"
    end
end
