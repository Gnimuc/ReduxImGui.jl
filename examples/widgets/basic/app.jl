using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

include("AppBasic.jl")
using .AppBasic

include("../../Renderer.jl")
using .Renderer

include("ui/button.jl")
include("ui/checkbox.jl")
include("ui/radio_button.jl")
include("ui/color_buttons.jl")
include("ui/arrow_button.jl")

## init states and create store
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

APP_BASIC_STATE = AppBasic.State(
    APP_BASIC_BUTTON_STATE,
    APP_BASIC_CHECKBOX_STATE,
    APP_BASIC_RADIOBUTTON_STATE,
    APP_BASIC_COLORBUTTON_STATE,
    APP_BASIC_REPEATER_STATE,
)
## create store and define the main UI window

store = create_store(AppBasic.app_basic, APP_BASIC_STATE)

function ui(store::AbstractStore)
    CImGui.SetNextWindowPos((650, 20), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((550, 680), CImGui.ImGuiCond_FirstUseEver)
    CImGui.Begin("Demo", Ref(true), CImGui.ImGuiWindowFlags_NoSavedSettings)
    if CImGui.TreeNode("Basic")
        naive_button(store)
        naive_checkbox(store)
        radio_button_group(store)
        color_buttons(store)

        # use AlignTextToFramePadding() to align text baseline to the baseline of framed elements (otherwise a Text+SameLine+Button sequence will have the text a little too high by default)
        CImGui.AlignTextToFramePadding()
        CImGui.Text("Hold to repeat:")
        CImGui.SameLine()
        arrow_buttons_with_repeater(store)

        CImGui.TreePop()
    end
    CImGui.End()
end

## draw UI
Renderer.render(
    () -> ui(store),
    width = 1280,
    height = 720,
    title = "App: Basic",
)
