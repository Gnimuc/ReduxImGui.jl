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

## init states and create store
APP_BASIC_BUTTON_STATE = Dict("basic_button"=>ReduxButton.State("Button"))
APP_BASIC_CHECKBOX_STATE = Dict("basic_checkbox"=>ReduxCheckbox.State("checkbox"))
APP_BASIC_RADIOBUTTON_STATE = Dict("basic_radio_button1"=>ReduxRadioButton.State("radio a"),
                                   "basic_radio_button2"=>ReduxRadioButton.State("radio b"),
                                   "basic_radio_button3"=>ReduxRadioButton.State("radio c"))

APP_BASIC_STATE = AppBasic.State(APP_BASIC_BUTTON_STATE,
                                 APP_BASIC_CHECKBOX_STATE,
                                 APP_BASIC_RADIOBUTTON_STATE)

store = create_store(AppBasic.app_basic, APP_BASIC_STATE)

function ui(store::AbstractStore)
    CImGui.SetNextWindowPos((650, 20), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((550, 680), CImGui.ImGuiCond_FirstUseEver)
    CImGui.Begin("Demo", Ref(true), CImGui.ImGuiWindowFlags_NoSavedSettings)
        if CImGui.TreeNode("Basic")
            button_triggered_text(store)
            naive_checkbox(store)
            radio_button_group(store)
            CImGui.TreePop()
        end
    CImGui.End()
end

## draw UI
Renderer.render(()->ui(store), width=1280, height=720, title="App: Basic")
