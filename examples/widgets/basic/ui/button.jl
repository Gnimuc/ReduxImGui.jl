using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_button(store::AbstractStore)
    if ReduxImGui.Button(store, s->get_state(s).buttons["basic_button"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
    # this works like a button with on/off state
    if ReduxImGui.is_on(get_state(store).buttons["basic_button"])
        CImGui.SameLine()
        CImGui.Text("Thanks for clicking me!")
    end
end
