using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_input_int(store::AbstractStore)
    if ReduxImGui.InputInt(store, s->get_state(s).input_ints["basic_input_int"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_values(get_state(store).input_ints["basic_input_int"]) |> first
        @info "Current value: $v"
    end
    CImGui.SameLine()
    ShowHelpMarker("You can apply arithmetic operators +,*,/ on numerical values.\n  e.g. [ 100 ], input \'*2\', result becomes [ 200 ]\nUse +- to subtract.\n")
end
