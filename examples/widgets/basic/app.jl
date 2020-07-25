using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

include("AppBasic.jl")
using .AppBasic

include("../../Renderer.jl")
using .Renderer

include("../../utils.jl")

include("ui/buttons.jl")
include("ui/checkbox.jl")
include("ui/combo.jl")
include("ui/repeater.jl")
include("ui/inputs.jl")
include("ui/drags.jl")
include("ui/sliders.jl")
include("ui/colors.jl")
include("ui/listboxes.jl")

## init states and create store
include("init_states.jl")
store = create_store(AppBasic.app_basic, APP_BASIC_STATE)

## define the main UI window
function ui(store::AbstractStore)
    CImGui.SetNextWindowPos((650, 20), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((550, 680), CImGui.ImGuiCond_FirstUseEver)
    CImGui.Begin("Demo", Ref(true), CImGui.ImGuiWindowFlags_NoSavedSettings)
    ReduxImGui.TreeNode("Basic") do
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
        CImGui.IsItemHovered() && ReduxImGui.Tooltip() do
            CImGui.Text("I am a fancy tooltip")
            CImGui.PlotLines("Curve", Cfloat[0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2], 7)
        end

        CImGui.Separator()

        CImGui.LabelText("label", "Value")
        naive_combo(store)
        naive_inputs(store)
        naive_drags(store)
        naive_sliders(store)
        naive_color_edits(store)
        naive_listboxes(store)

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
