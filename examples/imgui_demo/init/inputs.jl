const IMGUI_DEMO_INPUT_TEXT_STATES = Dict(
    "basic_input_text" => InputTexts.State(
        "input text",
        size=280,
        buffer="Hello, world!" * "\0"^267,
    ),
)

const IMGUI_DEMO_INPUT_TEXT_WITH_HINT_STATES = Dict(
    "basic_input_text_with_hint" => InputTextWithHints.State(
        "input text (w/ hint)",
        "enter text here",
    ),
)

const IMGUI_DEMO_INPUT_INT_STATES = Dict(
    "basic_input_int" => InputInts.State(
        "input int",
        123,
    ),
)

const IMGUI_DEMO_INPUT_FLOAT_STATES = Dict(
    "basic_input_float" => InputFloats.State(
        "input float",
        0.001f0,
        step=0.01f0,
        speed=1.0f0,
        format="%.3f",
    ),
    "basic_input_scientific" => InputFloats.State(
        "input scientific",
        Cfloat(1.e10),
        step=0.0f0,
        speed=0.0f0,
        format="%e",
    ),
)

const IMGUI_DEMO_INPUT_DOUBLE_STATES = Dict(
    "basic_input_double" => InputDoubles.State(
        "input double",
        999999.00000001,
        step=0.01f0,
        speed=1.0f0,
        format="%.8f",
    ),
)