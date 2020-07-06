using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_checkbox(store::AbstractStore)
    if ReduxImGui.Checkbox(store, get_state(store).checkboxes["checkbox"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
end
