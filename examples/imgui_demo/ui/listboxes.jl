using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_listboxes(store::AbstractStore, get_state=Redux.get_state)
    if ReduxImGui.ListBox(store, s->get_state(s).listboxes["basic_listbox"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        item = ReduxImGui.get_item(get_state(store).listboxes["basic_listbox"])
        @info "Current item: $item"
    end
end
