module Button

using Redux
using CImGui: ImVec2

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

# state
struct State <: AbstractImmutableState
    label::String
    size::ImVec2
end
State(label::AbstractString) = State(label, ImVec2(0,0))

# reducers
button(state::AbstractState, action::AbstractAction) = state
button(state::Vector{<:AbstractState}, action::AbstractAction) = state
button(s::State, a::RenameTo) = State(a.label, s.size)
button(s::State, a::ResizeTo) = State(s.label, ImVec2(a.x, a.y))
button(s::State, a::WidthTo) = State(s.label, ImVec2(a.width, s.size.y))
button(s::State, a::HeightTo) = State(s.label, ImVec2(s.size.x, a.height))


end # module
