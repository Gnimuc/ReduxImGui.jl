using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

function naive_sliders(store::AbstractStore)
    if ReduxImGui.SliderInt(store, s->get_state(s).slider_ints["basic_slider_int"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).slider_ints["basic_slider_int"])
        @info "Current value: $v"
    end
    CImGui.SameLine()
    ShowHelpMarker("CTRL+click to input value.")

    if ReduxImGui.SliderFloat(store, s->get_state(s).slider_floats["basic_slider_float"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).slider_floats["basic_slider_float"])
        @info "Current value: $v"
    end

    if ReduxImGui.SliderFloat(store, s->get_state(s).slider_floats["basic_slider_float_curve"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).slider_floats["basic_slider_float_curve"])
        @info "Current value: $v"
    end

    if ReduxImGui.SliderAngle(store, s->get_state(s).slider_angles["basic_slider_angle"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        v = ReduxImGui.get_value(get_state(store).slider_angles["basic_slider_angle"])
        @info "Current value: $v"
    end

    if ReduxImGui.SliderString(store, s->get_state(s).slider_strings["basic_slider_string"])
        @info "This triggers $(@__FILE__):$(@__LINE__)."
        s = ReduxImGui.get_string(get_state(store).slider_strings["basic_slider_string"])
        @info "Current string: $s"
    end
    CImGui.SameLine()
    ShowHelpMarker("Using the format string parameter to display a name instead of the underlying integer.")
end
