module ColorButtons

using Redux
using CImGui
using ..Buttons
import ..Buttons: AbstractButtonAction, AbstractButtonState
import CImGui: ImVec4

# actions
abstract type AbstractColorButtonAction <: AbstractButtonAction end

"""
    SetButtonColorTo(label, h, s, v)
    SetButtonColorTo(label, color::CImGui.ImVec4)
Change button's color to `color`.
"""
struct SetButtonColorTo <: AbstractColorButtonAction
    label::String
    color::ImVec4
end
SetButtonColorTo(label, h, s, v) = SetButtonColorTo(label, CImGui.HSV(h, s, v))

"""
    SetHoveredColorTo(label, h, s, v)
    SetHoveredColorTo(label, color::ImVec4)
Change hovered color to `color`.
"""
struct SetHoveredColorTo <: AbstractColorButtonAction
    label::String
    color::ImVec4
end
SetHoveredColorTo(label, h, s, v) = SetHoveredColorTo(label, CImGui.HSV(h, s, v))

"""
    SetActiveColorTo(label, h, s, v)
    SetActiveColorTo(label, color::ImVec4)
Change active color to `color`.
"""
struct SetActiveColorTo <: AbstractColorButtonAction
    label::String
    color::ImVec4
end
SetActiveColorTo(label, h, s, v) = SetActiveColorTo(label, CImGui.HSV(h, s, v))

"""
    AddColorButton(label::AbstractString, size = (0,0))
Add a [`ColorButton`](@ref).
"""
struct AddColorButton <: AbstractColorButtonAction
    button::Buttons.State
    button_color::ImVec4
    hovered_color::ImVec4
    active_color::ImVec4
end
AddColorButton(label::AbstractString, size) = AddColorButton(
    Buttons.State(label, size),
    CImGui.HSV(4 / 7.0, 0.6, 0.6),
    CImGui.HSV(4 / 7.0, 0.7, 0.7),
    CImGui.HSV(4 / 7.0, 0.8, 0.8),
)
AddColorButton(label::AbstractString) = AddColorButton(label, (0, 0))

"""
    DeleteColorButton(label::AbstractString)
Delete the [`ColorButton`](@ref).
"""
struct DeleteColorButton <: AbstractColorButtonAction
    label::String
end

# state
struct State <: AbstractImmutableState
    button::Buttons.State
    button_color::ImVec4
    hovered_color::ImVec4
    active_color::ImVec4
end
State(label::AbstractString, size) = State(
    Buttons.State(label, size),
    CImGui.HSV(4 / 7.0, 0.6, 0.6),
    CImGui.HSV(4 / 7.0, 0.7, 0.7),
    CImGui.HSV(4 / 7.0, 0.8, 0.8),
)
State(label::AbstractString) = State(label, (0, 0))

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::AbstractButtonAction) =
    State(Buttons.reducer(s.button, a), s.button_color, s.hovered_color, s.active_color)
reducer(s::State, a::SetButtonColorTo) = State(s.button, a.color, s.hovered_color, s.active_color)
reducer(s::State, a::SetHoveredColorTo) = State(s.button, s.button_color, a.color, s.active_color)
reducer(s::State, a::SetActiveColorTo) = State(s.button, s.button_color, s.hovered_color, a.color)

reducer(s::Dict{String,<:AbstractButtonState}, a::AbstractButtonAction) =
    Dict(k => (get_label(v) == a.label ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{State}, a::AbstractButtonAction) = map(s) do s
    get_label(s) === a.label ? reducer(s, a) : s
end

reducer(s::Vector{State}, a::AddColorButton) =
    State[s..., State(a.button, a.button_color, a.hovered_color, a.active_color)]
reducer(s::Vector{State}, a::DeleteColorButton) = filter(s -> s.label !== a.label, s)

# helper
"""
    ColorButton(store::AbstractStore, get_state=Redux.get_state) -> Bool
A wrapper over [`Buttons.Button`](@ref) with additional color states.
"""
function ColorButton(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    CImGui.PushStyleColor(CImGui.ImGuiCol_Button, get_color(s))
    CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, get_hovered_color(s))
    CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, get_active_color(s))
    is_triggered = CImGui.Button(get_label(s), get_size(s))
    CImGui.PopStyleColor(3)
    dispatch!(store, Buttons.SetTriggeredTo(get_label(s), is_triggered))
    return is_triggered
end

get_label(s::AbstractButtonState) = "__REDUX_IMGUI_RESERVED_DUMMY_LABEL"
get_label(s::State) = s.button.label

get_size(s::State) = s.button.size
get_color(s::State) = s.button_color
get_hovered_color(s::State) = s.hovered_color
get_active_color(s::State) = s.active_color


end # module
