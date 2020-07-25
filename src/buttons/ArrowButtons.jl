module ArrowButtons

using Redux
using CImGui

# actions
abstract type AbstractArrowButtonAction <: AbstractSyncAction end

"""
    SetIdTo(id, new_id)
Set button's identifier to `new_id`.
Please refer to `help?> CImGui.PushID` for further details.
"""
struct SetIdTo <: AbstractArrowButtonAction
    id::String
    new_id::String
end

"""
    SetArrowTo(id, direction::CImGui.ImGuiDir)
Change arrow direction to `direction`. The followings are cadidate directions:
- `ImGuiDir_None` = -1
- `ImGuiDir_Left` = 0
- `ImGuiDir_Right` = 1
- `ImGuiDir_Up` = 2
- `ImGuiDir_Down` = 3
- `ImGuiDir_COUNT` = 4
"""
struct SetArrowTo <: AbstractArrowButtonAction
    id::String
    direction::CImGui.ImGuiDir
end

# state
struct State <: AbstractImmutableState
    id::String
    direction::CImGui.ImGuiDir
end
State(id::AbstractString) = State(id, CImGui.ImGuiDir_None)

# reducers
arrow_button(state::AbstractState, action::AbstractAction) = state
arrow_button(state::Vector{<:AbstractState}, action::AbstractAction) = state
arrow_button(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function arrow_button(state::Dict{String,State}, action::AbstractArrowButtonAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = v.id == action.id ? arrow_button(v, action) : v
    end
    return s
end

arrow_button(s::State, a::SetIdTo) = State(a.new_id, s.direction)
arrow_button(s::State, a::SetArrowTo) = State(s.id, a.direction)

# helper
"""
    ArrowButton(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when pressed.
"""
function ArrowButton(store::AbstractStore, get_state=Redux.get_state)
    state = get_state(store)
    is_clicked = CImGui.ArrowButton(state.id, state.direction)
    return is_clicked
end

end # module
