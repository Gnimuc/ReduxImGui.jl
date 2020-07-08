using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function arrow_buttons_with_repeater(store::AbstractStore)
    if AppBasic.ReduxRepeater.Repeater(store, s->get_state(s).repeaters["basic_repeater"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end
end
