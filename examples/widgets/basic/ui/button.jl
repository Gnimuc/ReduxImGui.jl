using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function button_triggered_text(store::AbstractStore, get_state=Redux.get_state)
    if ReduxImGui.Button(store, get_state(store).button)
        # @show "This triggers everytime if clicked."
    end
    # this works like a button with on/off state
    if ReduxImGui.is_on(get_state(store).button)
        CImGui.SameLine()
        CImGui.Text("Thanks for clicking me!")
    end
end
