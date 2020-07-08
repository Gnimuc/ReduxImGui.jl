using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_combo(store::AbstractStore)
    if ReduxImGui.Combo(store, s->get_state(s).combos["basic_combo"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
    CImGui.SameLine()
    ShowHelpMarker("Refer to the \"Combo\" section below for an explanation of the full BeginCombo/EndCombo API, and demonstration of various flags.\n")
end
