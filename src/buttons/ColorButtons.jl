module ColorButtons

Base.Experimental.@optlevel 1

using Redux
using CImGui
using ..Buttons
import ..Buttons: AbstractButtonAction, AbstractButtonState, get_label
import CImGui: ImVec4

# actions
const Rename = Buttons.Rename 
const SetTriggeredTo = Buttons.SetTriggeredTo
const Resize = Buttons.Resize 
const ChangeWidth = Buttons.ChangeWidth 
const ChangeHeight = Buttons.ChangeHeight 

"""
    SetButtonColorTo(label, h, s, v)
    SetButtonColorTo(label, color::CImGui.ImVec4)
Change button's color to `color`.
"""
struct SetButtonColorTo <: AbstractButtonAction
    label::String
    color::ImVec4
end
SetButtonColorTo(label, h, s, v) = SetButtonColorTo(label, CImGui.HSV(h, s, v))

"""
    SetHoveredColorTo(label, h, s, v)
    SetHoveredColorTo(label, color::ImVec4)
Change hovered color to `color`.
"""
struct SetHoveredColorTo <: AbstractButtonAction
    label::String
    color::ImVec4
end
SetHoveredColorTo(label, h, s, v) = SetHoveredColorTo(label, CImGui.HSV(h, s, v))

"""
    SetActiveColorTo(label, h, s, v)
    SetActiveColorTo(label, color::ImVec4)
Change active color to `color`.
"""
struct SetActiveColorTo <: AbstractButtonAction
    label::String
    color::ImVec4
end
SetActiveColorTo(label, h, s, v) = SetActiveColorTo(label, CImGui.HSV(h, s, v))

"""
    AddButton(label::AbstractString, size = (0,0))
Add a [`ColorButton`](@ref).
"""
struct AddButton <: AbstractButtonAction
    button::Buttons.State
    button_color::ImVec4
    hovered_color::ImVec4
    active_color::ImVec4
end
AddButton(label::AbstractString, size) = AddButton(
    Buttons.State(label, size),
    CImGui.HSV(4 / 7.0, 0.6, 0.6),
    CImGui.HSV(4 / 7.0, 0.7, 0.7),
    CImGui.HSV(4 / 7.0, 0.8, 0.8),
)
AddButton(label::AbstractString) = AddButton(label, (0, 0))

get_label(a::AddButton) = a.button.label

"""
    DeleteButton(label::AbstractString)
Delete the [`ColorButton`](@ref).
"""
struct DeleteButton <: AbstractButtonAction
    label::String
end

# state
"""
    ColorButtons.State(label::AbstractString)
    ColorButtons.State(label::AbstractString, size)
    ColorButtons.State(label::AbstractString, size, button_color, hovered_color, active_color)
A color button state which contains a common button plus three colors.
"""
struct State <: AbstractButtonState
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

get_label(s::State) = s.button.label
get_size(s::State) = s.button.size
get_color(s::State) = s.button_color
get_hovered_color(s::State) = s.hovered_color
get_active_color(s::State) = s.active_color
is_triggered(s::State) = s.button.is_triggered

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
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractButtonState}, a::AbstractButtonAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end
reducer(s::Vector{<:AbstractButtonState}, a::AddButton) =
    [s..., State(a.button, a.button_color, a.hovered_color, a.active_color)]
reducer(s::Vector{<:AbstractButtonState}, a::DeleteButton) = 
    filter(s -> get_label(s) !== get_label(a), s)

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

end # module
