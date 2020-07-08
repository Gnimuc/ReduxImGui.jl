module ReduxColorButton

using Redux
using CImGui
import CImGui: ImVec2, ImVec4
using ..ReduxButton
import ..ReduxButton: AbstractButtonAction, is_on, get_size
import ..ReduxImGui: get_label

# actions
abstract type AbstractColorButtonAction <: AbstractButtonAction end

"""
    SetButtonColorTo(label, h, s, v)
    SetButtonColorTo(label, color::ImVec4)
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

# state
struct State <: AbstractImmutableState
    button::ReduxButton.State
    button_color::ImVec4
    hovered_color::ImVec4
    active_color::ImVec4
end
State(label::AbstractString, size) = State(
    ReduxButton.State(label, size),
    CImGui.HSV(4 / 7.0, 0.6, 0.6),
    CImGui.HSV(4 / 7.0, 0.7, 0.7),
    CImGui.HSV(4 / 7.0, 0.8, 0.8),
)
State(label::AbstractString) = State(label, ImVec2(0, 0))

# reducers
color_button(state::AbstractState, action::AbstractAction) = state
color_button(state::Vector{<:AbstractState}, action::AbstractAction) = state
color_button(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function color_button(state::Dict{String,State}, action::AbstractButtonAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? ReduxButton.button(v, action) : v
    end
    return s
end

function color_button(state::Dict{String,State}, action::AbstractColorButtonAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? color_button(v, action) : v
    end
    return s
end

color_button(s::State, a::SetButtonColorTo) = State(s.button, a.color, s.hovered_color, s.active_color)
color_button(s::State, a::SetHoveredColorTo) = State(s.button, s.button_color, a.color, s.active_color)
color_button(s::State, a::SetActiveColorTo) = State(s.button, s.button_color, s.hovered_color, a.color)

# helper
"""
    ColorButton(store::AbstractStore, get_state=Redux.get_state) -> Bool
A wrapper over [`ReduxButton.Button`](@ref) with additional color states.
"""
function ColorButton(store::AbstractStore, get_state=Redux.get_state)
    state = get_state(store)
    CImGui.PushStyleColor(CImGui.ImGuiCol_Button, get_color(state))
    CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, get_hovered_color(state))
    CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, get_active_color(state))
    is_clicked = CImGui.Button(get_label(state), get_size(state))
    CImGui.PopStyleColor(3)
    is_clicked && dispatch!(store, ReduxButton.Toggle(get_label(state)))
    return is_clicked
end

"""
    is_on(s::State) -> Bool
Return `true` when the button is on.
"""
is_on(s::State) = ReduxButton.is_on(s.button)

"""
    get_label(s::State) -> String
Return the button label/identifier.
"""
get_label(s::State) = get_label(s.button)

get_size(s::State) = get_size(s.button)

get_color(s::State) = s.button_color
get_hovered_color(s::State) = s.hovered_color
get_active_color(s::State) = s.active_color


end # module
