const IMGUI_DEMO_SLIDER_INT_STATES = Dict(
    "basic_slider_int" => SliderInts.State(
        "slider int",
        0,
        range=(-1, 3),
    ),
)

const IMGUI_DEMO_SLIDER_FLOAT_STATES = Dict(
    "basic_slider_float" => SliderFloats.State(
        "slider float",
        0.123f0,
        range=(0.0f0, 1.0f0),
        format="ratio = %.3f",
    ),
    "basic_slider_float_curve" => SliderFloats.State(
        "slider float (curve)",
        0.0f0,
        range=(-10.0f0, 10.0f0),
        format="%.4f",
        power=2.0,
    ),
)

const IMGUI_DEMO_SLIDER_ANGLE_STATES = Dict(
    "basic_slider_angle" => SliderAngles.State(
        "slider angle",
        0.0f0,
    ),
)

const IMGUI_DEMO_SLIDER_STRING_STATES = Dict(
    "basic_slider_string" => SliderStrings.State(
        "slider enum",
        ["Fire", "Earth", "Air", "Water"],
    ),
)