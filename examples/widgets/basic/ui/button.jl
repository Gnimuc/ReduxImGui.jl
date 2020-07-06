using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function button_triggered_text(store::AbstractStore)
    if ReduxImGui.Button(store, get_state(store).buttons["Button"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
    # this works like a button with on/off state
    if ReduxImGui.is_on(get_state(store).buttons["Button"])
        CImGui.SameLine()
        CImGui.Text("Thanks for clicking me!")
    end
end
