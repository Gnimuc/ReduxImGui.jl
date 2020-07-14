using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_input_text(store::AbstractStore)
    if ReduxImGui.InputText(store, s->get_state(s).input_texts["basic_input_text"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        @info "Current string: "*ReduxImGui.get_string(get_state(store).input_texts["basic_input_text"])
    end
    CImGui.SameLine()
    ShowHelpMarker("USER:\nHold SHIFT or use mouse to select text.\n"*"CTRL+Left/Right to word jump.\n"*"CTRL+A or double-click to select all.\n"*"CTRL+X,CTRL+C,CTRL+V clipboard.\n"*"CTRL+Z,CTRL+Y undo/redo.\n"*"ESCAPE to revert.")
end
