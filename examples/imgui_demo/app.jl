using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

include("AppDemo.jl")
using .AppDemo

include("../Renderer.jl")
using .Renderer

## create store
store = create_store(AppDemo.reducer, AppDemo.IMGUI_DEMO_STATE)

## draw UI
Renderer.render(
    () -> AppDemo.ImGui_Demo(store),
    width = 1280,
    height = 720,
    title = "IMGUI Demo",
)
