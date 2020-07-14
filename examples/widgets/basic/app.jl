using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

include("AppBasic.jl")
using .AppBasic

include("../../Renderer.jl")
using .Renderer

include("../../utils.jl")

include("ui/button.jl")
include("ui/checkbox.jl")
include("ui/radio_button.jl")
include("ui/color_buttons.jl")
include("ui/arrow_button.jl")
include("ui/combo.jl")
include("ui/input_text.jl")

## init states and create store
include("init_states.jl")
store = create_store(AppBasic.app_basic, APP_BASIC_STATE)

## define the main UI window
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

        CImGui.Text("Hover over me")
        CImGui.IsItemHovered() && CImGui.SetTooltip("I am a tooltip")

        CImGui.SameLine()
        CImGui.Text("- or me")
        if CImGui.IsItemHovered()
            CImGui.BeginTooltip()
            CImGui.Text("I am a fancy tooltip")
            CImGui.PlotLines("Curve", Cfloat[0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2], 7)
            CImGui.EndTooltip()
        end

        CImGui.Separator()

        CImGui.LabelText("label", "Value")
        naive_combo(store)
        naive_input_text(store)

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
