module AppDemo

Base.Experimental.@optlevel 1

using ReduxImGui
using ReduxImGui.Redux
using ReduxImGui.CImGui
using ReduxImGui.Buttons: AbstractButtonState, AbstractButtonAction
using ReduxImGui.RadioButtonGroups: AbstractRadioButtonGroupAction
using ReduxImGui.Checkboxes: AbstractCheckboxAction
using ReduxImGui.Menus: AbstractMenu, AbstractMenuAction
using ReduxImGui.MainMenuBars: AbstractMainMenuBar, AbstractMainMenuBarAction

# additional widgets
include("../widgets/Repeaters.jl")
using .Repeaters

include("../utils.jl")

# UIs
include("ui/buttons.jl")
include("ui/checkboxes.jl")
include("ui/combos.jl")
include("ui/repeaters.jl")
include("ui/inputs.jl")
include("ui/drags.jl")
include("ui/sliders.jl")
include("ui/colors.jl")
include("ui/listboxes.jl")

# actions
abstract type AbstractAppDemoAction <: AbstractSyncAction end

# state
struct State <: AbstractImmutableState
    buttons::Dict{String,Buttons.AbstractButtonState}
    checkboxes::Dict{String,Checkboxes.State}
    radio_button_group::RadioButtonGroups.State
    colorful_buttons::Vector{ColorButtons.State}
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
    main_menubar::MainMenuBar
    extra::Dict{String,Bool}
end

# initial states
include("init/buttons.jl")
include("init/checkboxes.jl")
include("init/combos.jl")
include("init/repeaters.jl")
include("init/inputs.jl")
include("init/drags.jl")
include("init/sliders.jl")
include("init/colors.jl")
include("init/listboxes.jl")
include("init/menus.jl")

const IMGUI_DEMO_STATE = AppDemo.State(
    IMGUI_DEMO_BUTTON_STATES,
    IMGUI_DEMO_CHECKBOX_STATES,
    IMGUI_DEMO_RADIO_BUTTON_GROUP_STATES,
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
    IMGUI_DEMO_MAIN_MENUBAR_STATES,
    Dict(
        "show_app_main_manu_bar"=>true,
    )
)

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function reducer(state::Dict{String,Buttons.AbstractButtonState}, action::AbstractButtonAction)
    next_state = Buttons.reducer(state, action)
    next_state = OnOffButtons.reducer(next_state, action)
    next_state = ColorButtons.reducer(next_state, action)
    return next_state
end

reducer(state::Dict{String,Checkboxes.State}, action::AbstractCheckboxAction) =
    Checkboxes.reducer(state, action)

reducer(state::RadioButtonGroups.State, action::AbstractRadioButtonGroupAction) =
    RadioButtonGroups.reducer(state, action)

reducer(state::Vector{ColorButtons.State}, action::AbstractButtonAction) =
    ColorButtons.reducer(state, action)

reducer(state::Dict{String,Menu}, action::AbstractMenuAction) =
    Menus.reducer(state, action)

reducer(state::MainMenuBar, action::AbstractMainMenuBarAction) =
    MainMenuBars.reducer(state, action)

reducer(state::State, action::AbstractAction) =
    State(reducer(state.buttons, action),
          reducer(state.checkboxes, action),
          reducer(state.radio_button_group, action),
          reducer(state.colorful_buttons, action),
          Repeaters.repeater(state.repeaters, action),
          Combos.combo(state.combos, action),
          InputTexts.input_text(state.input_texts, action),
          InputTextWithHints.input_text_with_hint(state.input_text_with_hints, action),
          InputInts.input_int(state.input_ints, action),
          InputFloats.input_float(state.input_floats, action),
          InputDoubles.input_double(state.input_doubles, action),
          DragInts.drag_int(state.drag_ints, action),
          DragFloats.drag_float(state.drag_floats, action),
          SliderInts.slider_int(state.slider_ints, action),
          SliderFloats.slider_float(state.slider_floats, action),
          SliderAngles.slider_angle(state.slider_angles, action),
          SliderStrings.slider_string(state.slider_strings, action),
          ColorEdits.color_edit(state.color_edits, action),
          ListBoxes.listbox(state.listboxes, action),
          reducer(state.main_menubar, action),
          state.extra,
    )

# helper
"""
    ImGui_Demo(store::AbstractStore, get_state=Redux.get_state)
"""
function ImGui_Demo(store::AbstractStore, get_state=Redux.get_state)
    CImGui.ShowDemoWindow(Ref(true))
    CImGui.SetNextWindowPos((650, 20), CImGui.ImGuiCond_FirstUseEver)
    CImGui.SetNextWindowSize((550, 680), CImGui.ImGuiCond_FirstUseEver)
    CImGui.Begin("Demo", Ref(true), CImGui.ImGuiWindowFlags_NoSavedSettings)
    
    get_state(store).extra["show_app_main_manu_bar"] && 
        get_state(store).main_menubar(store, s->get_state(s).main_menubar)

    ReduxImGui.TreeNode("Basic") do
        basic_button(store, get_state)
        basic_checkbox(store, get_state)
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


    end
    CImGui.End()
end

end # module
