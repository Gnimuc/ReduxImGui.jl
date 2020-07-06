using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

include("AppBasic.jl")
using .AppBasic

include("../../Renderer.jl")
using .Renderer

include("ui/button.jl")
include("ui/checkbox.jl")

## init states and create store
APP_BASIC_BUTTON_STATE = Dict("basic_button"=>ReduxButton.State("Button"))
APP_BASIC_CHECKBOX_STATE = Dict("basic_checkbox"=>ReduxCheckbox.State("checkbox"))

APP_BASIC_STATE = AppBasic.State(APP_BASIC_BUTTON_STATE,
                                 APP_BASIC_CHECKBOX_STATE)

store = create_store(AppBasic.app_basic, APP_BASIC_STATE)

function ui(store::AbstractStore)
    CImGui.SetNextWindowPos((650, 20), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((550, 680), CImGui.ImGuiCond_FirstUseEver)
    CImGui.Begin("Demo", Ref(true), CImGui.ImGuiWindowFlags_NoSavedSettings)
        if CImGui.TreeNode("Basic")
            button_triggered_text(store)
            naive_checkbox(store)
            CImGui.TreePop()
        end
    CImGui.End()
end

## draw UI
Renderer.render(()->ui(store), width=1280, height=720, title="App: Basic")
