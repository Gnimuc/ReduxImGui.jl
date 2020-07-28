using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_menus(store::AbstractStore, get_state=Redux.get_state)
    if ReduxImGui.Menu(store, s->get_state(s).menus["test_menu"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
    end

    for x in get_state(store).menus["test_menu"].items
        if x.is_clicked
            @info "This triggers $(@__FILE__):$(@__LINE__)."
        end
    end
end
