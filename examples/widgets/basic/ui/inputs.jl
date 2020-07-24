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

function naive_input_text_with_hint(store::AbstractStore)
    if ReduxImGui.InputTextWithHint(store, s->get_state(s).input_text_with_hints["basic_input_text_with_hint"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
end

function naive_input_int(store::AbstractStore)
    if ReduxImGui.InputInt(store, s->get_state(s).input_ints["basic_input_int"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_values(get_state(store).input_ints["basic_input_int"]) |> first
        @info "Current value: $v"
    end
    CImGui.SameLine()
    ShowHelpMarker("You can apply arithmetic operators +,*,/ on numerical values.\n  e.g. [ 100 ], input \'*2\', result becomes [ 200 ]\nUse +- to subtract.\n")
end

function float_and_double_inputs(store::AbstractStore)
    if ReduxImGui.InputFloat(store, s->get_state(s).input_floats["basic_input_float"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).input_floats["basic_input_float"])
        @info "Current value: $v"
    end
    if ReduxImGui.InputDouble(store, s->get_state(s).input_doubles["basic_input_double"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).input_doubles["basic_input_double"])
        @info "Current value: $v"
    end
    if ReduxImGui.InputFloat(store, s->get_state(s).input_floats["basic_input_scientific"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).input_floats["basic_input_scientific"])
        @info "Current value: $v"
    end
    CImGui.SameLine()
    ShowHelpMarker("You can input value using the scientific notation,\n  e.g. \"1e+8\" becomes \"100000000\".\n")
end
