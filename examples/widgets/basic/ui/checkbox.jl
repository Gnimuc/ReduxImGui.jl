using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_checkbox(store::AbstractStore)
    if ReduxImGui.Checkbox(store, s->get_state(s).checkboxes["basic_checkbox"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
end
