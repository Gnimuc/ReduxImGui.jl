module ReduxButton

using Redux
using CImGui
import CImGui: ImVec2

# actions
"""
    RenameTo(label)
Change button label to `label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct RenameTo <: AbstractSyncAction
    label::String
end

"""
    ResizeTo(x, y)
Change button size to (x,y).
"""
struct ResizeTo <: AbstractSyncAction
    x::Cfloat
    y::Cfloat
end

"""
    WidthTo(w)
Change button width to `w`.
"""
struct WidthTo <: AbstractSyncAction
    width::Cfloat
end

"""
    HeightTo(h)
Change button height to `h`.
"""
struct HeightTo <: AbstractSyncAction
    height::Cfloat
end

"""
    Toggle()
Toggle button's `is_clicked` state.
"""
struct Toggle <: AbstractSyncAction end

# state
struct State <: AbstractImmutableState
    label::String
    size::ImVec2
    is_clicked::Bool
end
State(label::AbstractString, size) = State(label, size, false)
State(label::AbstractString) = State(label, ImVec2(0,0))

# reducers
button(state::AbstractState, action::AbstractAction) = state
button(state::Vector{<:AbstractState}, action::AbstractAction) = state
button(s::State, a::RenameTo) = State(a.label, s.size, s.is_clicked)
button(s::State, a::ResizeTo) = State(s.label, ImVec2(a.x, a.y), s.is_clicked)
button(s::State, a::WidthTo) = State(s.label, ImVec2(a.width, s.size.y), s.is_clicked)
button(s::State, a::HeightTo) = State(s.label, ImVec2(s.size.x, a.height), s.is_clicked)
button(s::State, a::Toggle) = State(s.label, s.size, !s.is_clicked)

# helper
function Button(store::AbstractStore, state::State)
    is_clicked = CImGui.Button(state.label, state.size)
    is_clicked && dispatch!(store, Toggle())
    return is_clicked
end

is_on(s::State) = s.is_clicked
is_off(s::State) = !is_on(s)

end # module
