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


end

# @c CImGui.SliderInt("slider int", &i1, -1, 3)
#             CImGui.SameLine()
#             ShowHelpMarker("CTRL+click to input value.")
#
#             @c CImGui.SliderFloat("slider float", &f1, 0.0, 1.0, "ratio = %.3f")
#             @c CImGui.SliderFloat("slider float (curve)", &f2, -10.0, 10.0, "%.4f", 2.0)
#
#             @c CImGui.SliderAngle("slider angle", &angle)
# i1=Cint(0) f1=Cfloat(0.123) f2=Cfloat(0.0) angle=Cfloat(0.0)
