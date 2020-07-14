module RigInputText

using Redux
using CImGui
import ..ReduxImGui: get_label

# actions
abstract type AbstractInputTextAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractInputTextAction
    label::String
    new_label::String
end

"""
    ChangeSize(label, size)
Change buffer size to `size`.
"""
struct ChangeSize <: AbstractInputTextAction
    size::Int
end

# state
struct State <: AbstractImmutableState
    label::String
    size::Int
    buffer::String
    flags::CImGui.ImGuiInputTextFlags_
end
State(
    label::AbstractString;
    size = 280,
    buffer = String(fill(UInt8(0), size)),
    flags = CImGui.ImGuiInputTextFlags_None,
) = State(label, size, buffer, flags)

# reducers
input_text(state::AbstractState, action::AbstractAction) = state
input_text(state::Vector{<:AbstractState}, action::AbstractAction) = state
input_text(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function input_text(state::Dict{String,State}, action::AbstractInputTextAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? input_text(v, action) : v
    end
    return s
end

input_text(s::State, a::Rename) = State(a.new_label, s.size, s.buffer, s.flags)
function input_text(s::State, a::ChangeSize)
    new_buf = String(fill(UInt8(0), a.size - s.size))
    return State(s.label, a.size, string(s.buffer, new_buf), s.flags)
end



# helper
"""
    InputText(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when triggered.
"""
function InputText(store::AbstractStore, get_state=Redux.get_state)
    s = get_state(store)
    is_triggered = CImGui.InputText(get_label(s), s.buffer, s.size, s.flags)
    return is_triggered
end

"""
    get_label(s::State) -> String
Return the label/identifier.
"""
get_label(s::State) = s.label

"""
    get_string(s::State) -> String
Return the current string.
"""
get_string(s::State) = split(s.buffer, '\0') |> first

end # module
