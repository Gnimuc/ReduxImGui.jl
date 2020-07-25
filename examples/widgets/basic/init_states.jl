APP_BASIC_BUTTON_STATES = Dict("basic_button" => Buttons.State("Button"))

APP_BASIC_CHECKBOX_STATES =
    Dict("basic_checkbox" => Checkboxes.State("checkbox"))

APP_BASIC_RADIO_BUTTON_STATES = Dict(
    "basic_radio_button1" => RadioButtons.State("radio a"),
    "basic_radio_button2" => RadioButtons.State("radio b"),
    "basic_radio_button3" => RadioButtons.State("radio c"),
)

APP_BASIC_COLOR_BUTTON_STATES = Dict(
    "basic_color_button1" => ColorButtons.State("click##1"),
    "basic_color_button2" => ColorButtons.State("click##2"),
    "basic_color_button3" => ColorButtons.State("click##3"),
    "basic_color_button4" => ColorButtons.State("click##4"),
    "basic_color_button5" => ColorButtons.State("click##5"),
    "basic_color_button6" => ColorButtons.State("click##6"),
    "basic_color_button7" => ColorButtons.State("click##7"),
)

APP_BASIC_REPEATER_STATES =
    Dict("basic_repeater" => AppBasic.RigRepeater.State("repeater"))

APP_BASIC_COMBO_STATES = Dict(
    "basic_combo" => Combos.State(
        "combo",
        items = [
            "AAAA",
            "BBBB",
            "CCCC",
            "DDDD",
            "EEEE",
            "FFFF",
            "GGGG",
            "HHHH",
            "IIII",
            "JJJJ",
            "KKKK",
            "LLLLLLL",
            "MMMM",
            "OOOOOOO",
        ],
    ),
)

APP_BASIC_INPUT_TEXT_STATES = Dict(
    "basic_input_text" => InputTexts.State(
        "input text",
        size = 280,
        buffer = "Hello, world!" * "\0"^267,
    ),
)

APP_BASIC_INPUT_TEXT_WITH_HINT_STATES = Dict(
    "basic_input_text_with_hint" => InputTextWithHints.State(
        "input text (w/ hint)",
        "enter text here",
    ),
)

APP_BASIC_INPUT_INT_STATES = Dict(
    "basic_input_int" => InputInts.State(
        "input int",
        123,
    ),
)

APP_BASIC_INPUT_FLOAT_STATES = Dict(
    "basic_input_float" => InputFloats.State(
        "input float",
        0.001f0,
        step = 0.01f0,
        speed = 1.0f0,
        format = "%.3f",
    ),
    "basic_input_scientific" => InputFloats.State(
        "input scientific",
        Cfloat(1.e10),
        step = 0.0f0,
        speed = 0.0f0,
        format = "%e",
    ),
)

APP_BASIC_INPUT_DOUBLE_STATES = Dict(
    "basic_input_double" => InputDoubles.State(
        "input double",
        999999.00000001,
        step = 0.01f0,
        speed = 1.0f0,
        format = "%.8f",
    ),
)

APP_BASIC_DRAG_INT_STATES = Dict(
    "basic_drag_int" => DragInts.State(
        "drag int",
        50,
        speed = 1,
    ),
    "basic_drag_int2" => DragInts.State(
        "drag int 0..100",
        42,
        speed = 1,
        range = (0,100),
        format = "%d%%",
    ),
)

APP_BASIC_DRAG_FLOAT_STATES = Dict(
    "basic_drag_float" => DragFloats.State(
        "drag float",
        1.0f0,
        speed = 0.005,
    ),
    "basic_drag_small_float" => DragFloats.State(
        "drag small float",
        0.0067f0,
        speed = 0.0001,
        range = (0.0f0,0.0f0),
        format = "%.06f ns",
    ),
)

APP_BASIC_SLIDER_INT_STATES = Dict(
    "basic_slider_int" => SliderInts.State(
        "slider int",
        0,
        range = (-1,3),
    ),
)

APP_BASIC_SLIDER_FLOAT_STATES = Dict(
    "basic_slider_float" => SliderFloats.State(
        "slider float",
        0.123f0,
        range = (0.0f0,1.0f0),
        format = "ratio = %.3f",
    ),
    "basic_slider_float_curve" => SliderFloats.State(
        "slider float (curve)",
        0.0f0,
        range = (-10.0f0,10.0f0),
        format = "%.4f",
        power = 2.0,
    ),
)

APP_BASIC_SLIDER_ANGLE_STATES = Dict(
    "basic_slider_angle" => SliderAngles.State(
        "slider angle",
        0.0f0,
    ),
)

APP_BASIC_SLIDER_STRING_STATES = Dict(
    "basic_slider_string" => SliderStrings.State(
        "slider enum",
        ["Fire", "Earth", "Air", "Water"],
    ),
)

APP_BASIC_COLOR_EDIT_STATES = Dict(
    "basic_color_edit_no_alpha" =>
        ColorEdits.State("color 1", Cfloat[1.0, 0.0, 0.2, 0.0]),
    "basic_color_edit_with_alpha" =>
        ColorEdits.State("color 2", Cfloat[0.4, 0.7, 0.0, 0.5]),
)

APP_BASIC_STATE = AppBasic.State(
    APP_BASIC_BUTTON_STATES,
    APP_BASIC_CHECKBOX_STATES,
    APP_BASIC_RADIO_BUTTON_STATES,
    APP_BASIC_COLOR_BUTTON_STATES,
    APP_BASIC_REPEATER_STATES,
    APP_BASIC_COMBO_STATES,
    APP_BASIC_INPUT_TEXT_STATES,
    APP_BASIC_INPUT_TEXT_WITH_HINT_STATES,
    APP_BASIC_INPUT_INT_STATES,
    APP_BASIC_INPUT_FLOAT_STATES,
    APP_BASIC_INPUT_DOUBLE_STATES,
    APP_BASIC_DRAG_INT_STATES,
    APP_BASIC_DRAG_FLOAT_STATES,
    APP_BASIC_SLIDER_INT_STATES,
    APP_BASIC_SLIDER_FLOAT_STATES,
    APP_BASIC_SLIDER_ANGLE_STATES,
    APP_BASIC_SLIDER_STRING_STATES,
    APP_BASIC_COLOR_EDIT_STATES,
)
