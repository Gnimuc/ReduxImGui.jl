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

APP_BASIC_STATE = AppBasic.State(
    APP_BASIC_BUTTON_STATE,
    APP_BASIC_CHECKBOX_STATE,
    APP_BASIC_RADIOBUTTON_STATE,
    APP_BASIC_COLORBUTTON_STATE,
    APP_BASIC_REPEATER_STATE,
    APP_BASIC_COMBO_STATE,
)
