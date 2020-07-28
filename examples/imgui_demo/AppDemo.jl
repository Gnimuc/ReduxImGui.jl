module AppDemo

using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui

# additional widgets
include("../widgets/Repeaters.jl")
using .Repeaters

include("../utils.jl")

# UIs
include("ui/buttons.jl")
include("ui/checkbox.jl")
include("ui/combo.jl")
include("ui/repeater.jl")
include("ui/inputs.jl")
include("ui/drags.jl")
include("ui/sliders.jl")
include("ui/colors.jl")
include("ui/listboxes.jl")
include("ui/menus.jl")

# actions
abstract type AbstractAppDemoAction <: AbstractSyncAction end

# state
struct State <: AbstractImmutableState
    buttons::Dict{String,Buttons.State}
    checkboxes::Dict{String,Checkboxes.State}
    radio_buttons::Dict{String,RadioButtons.State}
    color_buttons::Dict{String,ColorButtons.State}
    repeaters::Dict{String,Repeaters.State}
    combos::Dict{String,Combos.State}
    input_texts::Dict{String,InputTexts.State}
    input_text_with_hints::Dict{String,InputTextWithHints.State}
    input_ints::Dict{String,InputInts.State}
    input_floats::Dict{String,InputFloats.State}
    input_doubles::Dict{String,InputDoubles.State}
    drag_ints::Dict{String,DragInts.State}
    drag_floats::Dict{String,DragFloats.State}
    slider_ints::Dict{String,SliderInts.State}
    slider_floats::Dict{String,SliderFloats.State}
    slider_angles::Dict{String,SliderAngles.State}
    slider_strings::Dict{String,SliderStrings.State}
    color_edits::Dict{String,ColorEdits.State}
    listboxes::Dict{String,ListBoxes.State}
    menus::Dict{String,Menus.State}
end

# constants
include("init_states.jl")

const IMGUI_DEMO_STATE = AppDemo.State(
    IMGUI_DEMO_BUTTON_STATES,
    IMGUI_DEMO_CHECKBOX_STATES,
    IMGUI_DEMO_RADIO_BUTTON_STATES,
    IMGUI_DEMO_COLOR_BUTTON_STATES,
    IMGUI_DEMO_REPEATER_STATES,
    IMGUI_DEMO_COMBO_STATES,
    IMGUI_DEMO_INPUT_TEXT_STATES,
    IMGUI_DEMO_INPUT_TEXT_WITH_HINT_STATES,
    IMGUI_DEMO_INPUT_INT_STATES,
    IMGUI_DEMO_INPUT_FLOAT_STATES,
    IMGUI_DEMO_INPUT_DOUBLE_STATES,
    IMGUI_DEMO_DRAG_INT_STATES,
    IMGUI_DEMO_DRAG_FLOAT_STATES,
    IMGUI_DEMO_SLIDER_INT_STATES,
    IMGUI_DEMO_SLIDER_FLOAT_STATES,
    IMGUI_DEMO_SLIDER_ANGLE_STATES,
    IMGUI_DEMO_SLIDER_STRING_STATES,
    IMGUI_DEMO_COLOR_EDIT_STATES,
    IMGUI_DEMO_LISTBOX_STATES,
    IMGUI_DEMO_MENU_STATES,
)

# reducers
app_demo(state::AbstractState, action::AbstractAction) = state
app_demo(state::Vector{<:AbstractState}, action::AbstractAction) = state
app_demo(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function app_demo(state::State, action::AbstractAction)
    next_button_state = Buttons.button(state.buttons, action)
    next_checkbox_state = Checkboxes.checkbox(state.checkboxes, action)
    next_radio_button_state = RadioButtons.radio_button(state.radio_buttons, action)
    next_color_button_state = ColorButtons.color_button(state.color_buttons, action)
    next_repeater_state = Repeaters.repeater(state.repeaters, action)
    next_combo_state = Combos.combo(state.combos, action)
    next_input_text_state = InputTexts.input_text(state.input_texts, action)
    next_input_text_with_hint_state = InputTextWithHints.input_text_with_hint(state.input_text_with_hints, action)
    next_input_int_state = InputInts.input_int(state.input_ints, action)
    next_input_float_state = InputFloats.input_float(state.input_floats, action)
    next_input_double_state = InputDoubles.input_double(state.input_doubles, action)
    next_drag_int_state = DragInts.drag_int(state.drag_ints, action)
    next_drag_float_state = DragFloats.drag_float(state.drag_floats, action)
    next_slider_int_state = SliderInts.slider_int(state.slider_ints, action)
    next_slider_float_state = SliderFloats.slider_float(state.slider_floats, action)
    next_slider_angle_state = SliderAngles.slider_angle(state.slider_angles, action)
    next_slider_string_state = SliderStrings.slider_string(state.slider_strings, action)
    next_color_edit_state = ColorEdits.color_edit(state.color_edits, action)
    next_listbox_state = ListBoxes.listbox(state.listboxes, action)
    next_menus_state = Menus.menu(state.menus, action)
    return State(next_button_state,
                 next_checkbox_state,
                 next_radio_button_state,
                 next_color_button_state,
                 next_repeater_state,
                 next_combo_state,
                 next_input_text_state,
                 next_input_text_with_hint_state,
                 next_input_int_state,
                 next_input_float_state,
                 next_input_double_state,
                 next_drag_int_state,
                 next_drag_float_state,
                 next_slider_int_state,
                 next_slider_float_state,
                 next_slider_angle_state,
                 next_slider_string_state,
                 next_color_edit_state,
                 next_listbox_state,
                 next_menus_state)
end

# helper
"""
    ImGui_Demo(store::AbstractStore, get_state=Redux.get_state)
"""
function ImGui_Demo(store::AbstractStore, get_state=Redux.get_state)
    CImGui.SetNextWindowPos((650, 20), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((550, 680), CImGui.ImGuiCond_FirstUseEver)
    CImGui.Begin("Demo", Ref(true), CImGui.ImGuiWindowFlags_NoSavedSettings)
    ReduxImGui.TreeNode("Basic") do
        naive_button(store, get_state)
        naive_checkbox(store, get_state)
        radio_button_group(store, get_state)
        color_buttons(store, get_state)

        # use AlignTextToFramePadding() to align text baseline to the baseline of framed elements (otherwise a Text+SameLine+Button sequence will have the text a little too high by default)
        CImGui.AlignTextToFramePadding()
        CImGui.Text("Hold to repeat:")
        CImGui.SameLine()
        arrow_buttons_with_repeater(store, get_state)

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
        naive_combo(store, get_state)
        naive_inputs(store, get_state)
        naive_drags(store, get_state)
        naive_sliders(store, get_state)
        naive_color_edits(store, get_state)
        naive_listboxes(store, get_state)
    end

    ReduxImGui.TreeNode("Trees") do
        ReduxImGui.TreeNode("Basic trees") do
            for i = 0:4
                if CImGui.TreeNode(Ptr{Cvoid}(i), "Child $i")
                    CImGui.Text("blah blah")
                    CImGui.SameLine()
                    CImGui.SmallButton("button") && @info "Trigger `Basic trees`'s button | find me here: $(@__FILE__) at line $(@__LINE__)"
                    CImGui.TreePop()
                end
            end
        end
    end

    ReduxImGui.TreeNode("Advanced, with Selectable nodes") do
        ShowHelpMarker("This is a more standard looking tree with selectable nodes.\nClick to select, CTRL+Click to toggle, click on arrows or double-click to open.")
        naive_menus(store, get_state)

    end
    CImGui.End()
end

end # module
