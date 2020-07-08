APP_BASIC_BUTTON_STATE = Dict("basic_button" => ReduxButton.State("Button"))

APP_BASIC_CHECKBOX_STATE =
    Dict("basic_checkbox" => ReduxCheckbox.State("checkbox"))

APP_BASIC_RADIOBUTTON_STATE = Dict(
    "basic_radio_button1" => ReduxRadioButton.State("radio a"),
    "basic_radio_button2" => ReduxRadioButton.State("radio b"),
    "basic_radio_button3" => ReduxRadioButton.State("radio c"),
)

APP_BASIC_COLORBUTTON_STATE = Dict(
    "basic_color_button1" => ReduxColorButton.State("click##1"),
    "basic_color_button2" => ReduxColorButton.State("click##2"),
    "basic_color_button3" => ReduxColorButton.State("click##3"),
    "basic_color_button4" => ReduxColorButton.State("click##4"),
    "basic_color_button5" => ReduxColorButton.State("click##5"),
    "basic_color_button6" => ReduxColorButton.State("click##6"),
    "basic_color_button7" => ReduxColorButton.State("click##7"),
)

APP_BASIC_REPEATER_STATE =
    Dict("basic_repeater" => AppBasic.ReduxRepeater.State("repeater"))

APP_BASIC_COMBO_STATE = Dict(
    "basic_combo" => ReduxCombo.State(
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
