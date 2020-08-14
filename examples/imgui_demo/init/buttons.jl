IMGUI_DEMO_BUTTON_STATES = Dict(
    "basic_button" => OnOffButtons.State("Button"),
    "basic_button2" => Buttons.State("Button2"),
)

IMGUI_DEMO_RADIO_BUTTON_GROUP_STATES = 
    RadioButtonGroups.State("radio button group", 
                            [RadioButtons.State("radio a"),
                             RadioButtons.State("radio b"),
                             RadioButtons.State("radio c")])
                            
IMGUI_DEMO_COLOR_BUTTON_STATES = [
    ColorButtons.State("click##1"),
    ColorButtons.State("click##2"),
    ColorButtons.State("click##3"),
    ColorButtons.State("click##4"),
    ColorButtons.State("click##5"),
    ColorButtons.State("click##6"),
    ColorButtons.State("click##7"),
]