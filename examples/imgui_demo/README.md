# IMGUI Demo
This is a concise implementation of [CImGui.jl's examples](https://github.com/Gnimuc/CImGui.jl/tree/master/examples) which are one-to-one translated from [the C++ examples](https://github.com/ocornut/imgui/blob/master/imgui_demo.cpp). This implementation uses [Redux.jl](https://github.com/Gnimuc/Redux.jl) for state-management.

## How to run the demo
In Julia REPL, simply run:
```julia-repl
julia> using ReduxImGui

julia> include(joinpath(pathof(ReduxImGui), "..", "..", "examples", "imgui_demo", "app.jl"))
```

and this is what `app.jl` looks like:

```julia
using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

include("AppDemo.jl")
using .AppDemo

include("../Renderer.jl")
using .Renderer

## create store
store = create_store(AppDemo.app_demo, AppDemo.IMGUI_DEMO_STATE)

## draw UI
Renderer.render(
    () -> AppDemo.ImGui_Demo(store),
    width = 1280,
    height = 720,
    title = "IMGUI Demo",
)
```
