module Buttons

using Redux
using CImGui
import CImGui: ImVec2
import ..ReduxImGui: get_label

# actions
abstract type AbstractButtonAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change button's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractButtonAction
    label::String
    new_label::String
end

"""
    Resize(label, x, y)
Change button size to (x,y).
"""
struct Resize <: AbstractButtonAction
    label::String
    x::Cfloat
    y::Cfloat
end

"""
    ChangeWidth(label, w)
Change button width to `w`.
"""
struct ChangeWidth <: AbstractButtonAction
    label::String
    width::Cfloat
end

"""
    ChangeHeight(label, h)
Change button height to `h`.
"""
struct ChangeHeight <: AbstractButtonAction
    label::String
    height::Cfloat
end

"""
    Toggle(label)
Toggle button's `is_clicked` state.
"""
struct Toggle <: AbstractButtonAction
    label::String
end

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
button(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function button(state::Dict{String,State}, action::AbstractButtonAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? button(v, action) : v
    end
    return s
end

button(s::State, a::Rename) = State(a.new_label, s.size, s.is_clicked)
button(s::State, a::Resize) = State(s.label, ImVec2(a.x, a.y), s.is_clicked)
button(s::State, a::ChangeWidth) = State(s.label, ImVec2(a.width, s.size.y), s.is_clicked)
button(s::State, a::ChangeHeight) = State(s.label, ImVec2(s.size.x, a.height), s.is_clicked)
button(s::State, a::Toggle) = State(s.label, s.size, !s.is_clicked)

# helper
"""
    Button(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when pressed. It also maintains a `is_clicked` state which can be
used to implement an on/off button, see also [`is_on`](@ref).
"""
function Button(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_clicked = CImGui.Button(get_label(s), get_size(s))
    is_clicked && dispatch!(store, Toggle(get_label(s)))
    return is_clicked
end

"""
    is_on(s::State) -> Bool
Return `true` when the button is on.
"""
is_on(s::State) = s.is_clicked

get_label(s::State) = s.label

get_size(s::State) = s.size

end # module
