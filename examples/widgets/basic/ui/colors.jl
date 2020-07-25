using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_color_edits(store::AbstractStore)
    if ReduxImGui.ColorEdit(store, s->get_state(s).color_edits["basic_color_edit_no_alpha"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
    CImGui.SameLine()
    ShowHelpMarker("Click on the colored square to open a color picker.\nClick and hold to use drag and drop.\nRight-click on the colored square to show options.\nCTRL+click on individual component to input value.\n")
    if ReduxImGui.ColorEdit(store, s->get_state(s).color_edits["basic_color_edit_with_alpha"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
end
