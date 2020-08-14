module Buttons

Base.Experimental.@optlevel 1

using Redux
using CImGui

# actions
abstract type AbstractButtonAction <: AbstractSyncAction end

get_label(a::AbstractButtonAction) = a.label

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
    SetTriggeredTo(label, is_triggered)
Update widget's `is_triggered` state.
"""
struct SetTriggeredTo <: AbstractButtonAction
    label::String
    is_triggered::Bool
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
    AddButton(label::AbstractString, size = (0,0))
Add a [`Button`](@ref).
"""
struct AddButton <: AbstractButtonAction
    label::String
    size::Tuple{Cfloat,Cfloat}
end
AddButton(label::AbstractString) = AddButton(label, (0,0))

"""
    DeleteButton(label::AbstractString)
Delete the [`Button`](@ref).
"""
struct DeleteButton <: AbstractButtonAction
    label::String
end

# state
abstract type AbstractButtonState <: AbstractImmutableState end

get_label(s::AbstractButtonState) = s.label

"""
    Buttons.State(label::AbstractString)
    Buttons.State(label::AbstractString, size)
    Buttons.State(label::AbstractString, size, is_triggered)
A simple button state which contains a label a.k.a the identifier,
a size tuple (x,y) and a flag value `is_triggered` that records the state of
the latest poll events.
"""
struct State <: AbstractButtonState
    label::String
    size::Tuple{Cfloat,Cfloat}
    is_triggered::Bool
end
State(label::AbstractString, size) = State(label, size, false)
State(label::AbstractString) = State(label, (0,0))

get_size(s::State) = s.size
is_triggered(s::State) = s.is_triggered

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

reducer(s::State, a::Rename) = State(a.new_label, s.size, s.is_triggered)
reducer(s::State, a::Resize) = State(s.label, (a.x, a.y), s.is_triggered)
reducer(s::State, a::ChangeWidth) = State(s.label, (a.width, s.size[2]), s.is_triggered)
reducer(s::State, a::ChangeHeight) = State(s.label, (s.size[1], a.height), s.is_triggered)
reducer(s::State, a::SetTriggeredTo) = State(s.label, s.size, a.is_triggered)

reducer(s::Dict{String,<:AbstractButtonState}, a::AbstractButtonAction) =
    Dict(k => (get_label(v) == get_label(a) ? reducer(v, a) : v) for (k, v) in s)

reducer(s::Vector{<:AbstractButtonState}, a::AbstractButtonAction) = map(s) do s
    get_label(s) == get_label(a) ? reducer(s, a) : s
end
reducer(s::Vector{<:AbstractButtonState}, a::AddButton) = [s..., State(a.label, a.size, false)]
reducer(s::Vector{<:AbstractButtonState}, a::DeleteButton) = filter(s -> get_label(s) !== get_label(a), s)

# helper
"""
    Button(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
`get_state` is a router function which tells how to find the target state from `store`.
"""
function Button(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_triggered = CImGui.Button(s.label, CImGui.ImVec2(s.size...))
    dispatch!(store, SetTriggeredTo(s.label, is_triggered))
    return is_triggered
end

end # module
