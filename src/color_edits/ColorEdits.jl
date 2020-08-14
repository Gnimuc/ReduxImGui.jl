module ColorEdits

Base.Experimental.@optlevel 1

using Redux
using CImGui
import ..ReduxImGui: get_label, get_color

# actions
abstract type AbstractColorEditAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractColorEditAction
    label::String
    new_label::String
end

"""
    EnableAlpha(label)
Enable editing alpha. This also changes widget appearance.
"""
struct EnableAlpha <: AbstractColorEditAction
    label::String
end

"""
    DisableAlpha(label)
Disable editing alpha. This also changes widget appearance.
"""
struct DisableAlpha <: AbstractColorEditAction
    label::String
end

"""
    ChangeFlags(label, flags)
Change widget's flags to `flags`.
"""
struct ChangeFlags <: AbstractColorEditAction
    label::String
    flags::CImGui.ImGuiColorEditFlags_
end

# state
struct State <: AbstractImmutableState
    label::String
    rgba::Vector{Cfloat}
    flags::CImGui.ImGuiColorEditFlags_
    no_alpha::Bool
end
State(label::AbstractString, rgba::Vector{Cfloat}, flags = 0) =
    State(label, rgba, CImGui.ImGuiColorEditFlags_(flags), true)

# reducers
color_edit(state::AbstractState, action::AbstractAction) = state
color_edit(state::Vector{<:AbstractState}, action::AbstractAction) = state
color_edit(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function color_edit(state::Dict{String,State}, action::AbstractColorEditAction)
    s = Dict{String,State}()
    for (k, v) in state
        s[k] = get_label(v) == action.label ? color_edit(v, action) : v
    end
    return s
end

color_edit(s::State, a::Rename) = State(a.new_label, s.rgba, s.flags, s.no_alpha)
color_edit(s::State, a::EnableAlpha) = State(s.label, s.rgba, s.flags, false)
color_edit(s::State, a::DisableAlpha) = State(s.label, s.rgba, s.flags, true)
color_edit(s::State, a::ChangeFlags) = State(s.label, s.rgba, a.flags, s.no_alpha)

# helper
"""
    ColorEdit(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function ColorEdit(store::AbstractStore, get_state = Redux.get_state)
    s = get_state(store)
    if s.no_alpha
        is_triggered = CImGui.ColorEdit3(get_label(s), s.rgba, s.flags)
    else
        is_triggered = CImGui.ColorEdit4(get_label(s), s.rgba, s.flags)
    end
    return is_triggered
end

get_label(s::State) = s.label
get_color(s::State) = s.rgba

end # module
