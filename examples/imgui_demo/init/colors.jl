const IMGUI_DEMO_COLOR_EDIT_STATES = Dict(
    "basic_color_edit_no_alpha" =>
        ColorEdits.State("color 1", Cfloat[1.0, 0.0, 0.2, 0.0]),
    "basic_color_edit_with_alpha" =>
        ColorEdits.State("color 2", Cfloat[0.4, 0.7, 0.0, 0.5]),
)