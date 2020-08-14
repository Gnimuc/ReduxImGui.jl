module ListBoxes

Base.Experimental.@optlevel 1

using Redux
using CImGui
import ..ReduxImGui: get_label

# actions
abstract type AbstractListBoxAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractListBoxAction
    label::String
    new_label::String
end

"""
    ChangeItems(label, items)
Change widget's items to `items`.
"""
struct ChangeItems <: AbstractListBoxAction
    label::String
    items::Vector{String}
end

"""
    ChangeIndex(label, idx)
Change current item to the one indexed by `idx`.
"""
struct ChangeIndex <: AbstractListBoxAction
    label::String
    idx::Cint
end

"""
    ChangeHeight(label, height)
Change widget's height to `height`-items.
"""
struct ChangeHeight <: AbstractListBoxAction
    label::String
    height::Cint
end

# state
struct State <: AbstractImmutableState
    label::String
    items::Vector{String}
    idx::Cint
    height::Cint
end
State(label::AbstractString, items::Vector{<:AbstractString}, idx = 1) =
    State(label, items, idx, -1)

# reducers
listbox(state::AbstractState, action::AbstractAction) = state
listbox(state::Vector{<:AbstractState}, action::AbstractAction) = state
listbox(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function listbox(state::Dict{String,State}, action::AbstractListBoxAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? listbox(v, action) : v
    end
    return s
end

listbox(s::State, a::Rename) = State(a.new_label, s.items, s.idx, s.height)
listbox(s::State, a::ChangeItems) = State(s.label, a.items, s.idx, s.height)
listbox(s::State, a::ChangeIndex) = State(s.label, s.items, a.idx, s.height)
listbox(s::State, a::ChangeHeight) = State(s.label, s.items, s.idx, a.height)

# helper
"""
    ListBox(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function ListBox(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    c_idx = Ref{Cint}(s.idx - 1)
    is_triggered = CImGui.ListBox(s.label, c_idx, s.items, length(s.items), s.height)
    is_triggered && dispatch!(store, ChangeIndex(s.label, c_idx[]+1))
    return is_triggered
end

get_label(s::State) = s.label
get_items(s::State) = s.items
get_item(s::State) = s.items[s.idx]

end # module
