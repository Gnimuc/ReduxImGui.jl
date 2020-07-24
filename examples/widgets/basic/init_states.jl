APP_BASIC_BUTTON_STATE = Dict("basic_button" => RigButton.State("Button"))

APP_BASIC_CHECKBOX_STATE =
    Dict("basic_checkbox" => RigCheckbox.State("checkbox"))

APP_BASIC_RADIOBUTTON_STATE = Dict(
    "basic_radio_button1" => RigRadioButton.State("radio a"),
    "basic_radio_button2" => RigRadioButton.State("radio b"),
    "basic_radio_button3" => RigRadioButton.State("radio c"),
)

APP_BASIC_COLORBUTTON_STATE = Dict(
    "basic_color_button1" => RigColorButton.State("click##1"),
    "basic_color_button2" => RigColorButton.State("click##2"),
    "basic_color_button3" => RigColorButton.State("click##3"),
    "basic_color_button4" => RigColorButton.State("click##4"),
    "basic_color_button5" => RigColorButton.State("click##5"),
    "basic_color_button6" => RigColorButton.State("click##6"),
    "basic_color_button7" => RigColorButton.State("click##7"),
)

APP_BASIC_REPEATER_STATE =
    Dict("basic_repeater" => AppBasic.RigRepeater.State("repeater"))

APP_BASIC_COMBO_STATE = Dict(
    "basic_combo" => RigCombo.State(
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

APP_BASIC_INPUTTEXT_STATE = Dict(
    "basic_input_text" => RigInputText.State(
        "input text",
        size = 280,
        buffer = "Hello, world!" * "\0"^267,
    ),
)

APP_BASIC_INPUTTEXTWITHHINT_STATE = Dict(
    "basic_input_text_with_hint" => RigInputTextWithHint.State(
        "input text (w/ hint)",
        "enter text here",
    ),
)

APP_BASIC_INPUTINT_STATE = Dict(
    "basic_input_int" => RigInputInt.State(
        "input int",
        123,
    ),
)

APP_BASIC_INPUTFLOAT_STATE = Dict(
    "basic_input_float" => RigInputFloat.State(
        "input float",
        0.001f0,
        step = 0.01f0,
        speed = 1.0f0,
        format = "%.3f",
    ),
    "basic_input_scientific" => RigInputFloat.State(
        "input scientific",
        Cfloat(1.e10),
        step = 0.0f0,
        speed = 0.0f0,
        format = "%e",
    ),
)

APP_BASIC_INPUTDOUBLE_STATE = Dict(
    "basic_input_double" => RigInputDouble.State(
        "input double",
        999999.00000001,
        step = 0.01f0,
        speed = 1.0f0,
        format = "%.8f",
    ),
)

APP_BASIC_DRAGINT_STATE = Dict(
    "basic_drag_int" => RigDragInt.State(
        "drag int",
        50,
        speed = 1,
    ),
    "basic_drag_int2" => RigDragInt.State(
        "drag int 0..100",
        42,
        speed = 1,
        range = (0,100),
        format = "%d%%",
    ),
)

APP_BASIC_DRAGFLOAT_STATE = Dict(
    "basic_drag_float" => RigDragFloat.State(
        "drag float",
        1.0f0,
        speed = 0.005,
    ),
    "basic_drag_small_float" => RigDragFloat.State(
        "drag small float",
        0.0067f0,
        speed = 0.0001,
        range = (0.0f0,0.0f0),
        format = "%.06f ns",
    ),
)

APP_BASIC_SLIDERINT_STATE = Dict(
    "basic_slider_int" => RigSliderInt.State(
        "slider int",
        0,
        range = (-1,3),
    ),
)

APP_BASIC_SLIDERFLOAT_STATE = Dict(
    "basic_slider_float" => RigSliderFloat.State(
        "slider float",
        0.123f0,
        range = (0.0f0,1.0f0),
        format = "ratio = %.3f",
    ),
    "basic_slider_float_curve" => RigSliderFloat.State(
        "slider float (curve)",
        0.0f0,
        range = (-10.0f0,10.0f0),
        format = "%.4f",
        power = 2.0,
    ),
)

APP_BASIC_SLIDERANGLE_STATE = Dict(
    "basic_slider_angle" => RigSliderAngle.State(
        "slider angle",
        0.0f0,
    ),
)

APP_BASIC_STATE = AppBasic.State(
    APP_BASIC_BUTTON_STATE,
    APP_BASIC_CHECKBOX_STATE,
    APP_BASIC_RADIOBUTTON_STATE,
    APP_BASIC_COLORBUTTON_STATE,
    APP_BASIC_REPEATER_STATE,
    APP_BASIC_COMBO_STATE,
    APP_BASIC_INPUTTEXT_STATE,
    APP_BASIC_INPUTTEXTWITHHINT_STATE,
    APP_BASIC_INPUTINT_STATE,
    APP_BASIC_INPUTFLOAT_STATE,
    APP_BASIC_INPUTDOUBLE_STATE,
    APP_BASIC_DRAGINT_STATE,
    APP_BASIC_DRAGFLOAT_STATE,
    APP_BASIC_SLIDERINT_STATE,
    APP_BASIC_SLIDERFLOAT_STATE,
    APP_BASIC_SLIDERANGLE_STATE,
)
