module ReduxCombo

using Redux
using CImGui
import ..ReduxImGui: get_label

Base.convert(::Type{CImGui.LibCImGui.ImGuiComboFlags_}, x::Integer) = CImGui.LibCImGui.ImGuiComboFlags_(x)

# actions
abstract type AbstractComboAction <: AbstractSyncAction end

"""
    Rename(label, new_label)
Change combo's label to `new_label`.
Note that renaming may also change the identifier, please refer to `help?> CImGui.PushID`.
"""
struct Rename <: AbstractComboAction
    label::String
    new_label::String
end

"""
    SetItemsTo(label, items)
Change combo list to `items`.
"""
struct SetItemsTo <: AbstractComboAction
    label::String
    items::Vector{String}
end

"""
    SetCurrentItemTo(label, current_item)
Change current item to `current_item`.
"""
struct SetCurrentItemTo <: AbstractComboAction
    label::String
    current_item::String
end

"""
    EnableFlag(label, flag)
Enable the feature represented by the `flag`.
Please refer to `CImGui.ImGuiComboFlags_` for a full list of supported flags.
"""
struct EnableFlag <: AbstractComboAction
    label::String
    flag::CImGui.ImGuiComboFlags_
end

"""
    DisableFlag(label, flag)
Disable the feature represented by the `flag`.
Please refer to `CImGui.ImGuiComboFlags_` for a full list of supported flags.
"""
struct DisableFlag <: AbstractComboAction
    label::String
    flag::CImGui.ImGuiComboFlags_
end

"""
    SetFlagsTo(label, flag)
Set combo's flags to `flags` directly. Note you need to do the bit-masking by yourself.
"""
struct SetFlagsTo <: AbstractComboAction
    label::String
    flags::CImGui.ImGuiComboFlags
end

# state
struct State <: AbstractImmutableState
    label::String
    items::Vector{String}
    current_item::String
    flags::CImGui.ImGuiComboFlags_
end
State(
    label::AbstractString;
    items = ["No item."],
    current_item = first(items),
    flags = CImGui.ImGuiComboFlags_None,
) = State(label, items, current_item, flags)

# reducers
combo(state::AbstractState, action::AbstractAction) = state
combo(state::Vector{<:AbstractState}, action::AbstractAction) = state
combo(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

function combo(state::Dict{String,State}, action::AbstractComboAction)
    s = Dict{String,State}()
    for (k,v) in state
        s[k] = get_label(v) == action.label ? combo(v, action) : v
    end
    return s
end

combo(s::State, a::Rename) = State(a.new_label, s.items, s.current_item, s.flags)
combo(s::State, a::SetItemsTo) = State(s.label, a.items, s.current_item, s.flags)
combo(s::State, a::SetCurrentItemTo) = State(s.label, s.items, a.current_item, s.flags)
combo(s::State, a::DisableFlag) = State(s.label, s.items, s.current_item, s.flags & ~a.flag)
combo(s::State, a::SetFlagsTo) = State(s.label, s.items, s.current_item, a.flags)
function combo(s::State, a::EnableFlag)
    flags = s.flags
    if a.flag == CImGui.ImGuiComboFlags_NoArrowButton
        # clear the other flag, as we cannot combine both
        flags &= ~CImGui.ImGuiComboFlags_NoPreview
    elseif a.flag == CImGui.ImGuiComboFlags_NoPreview
        # clear the other flag, as we cannot combine both
        flags &= ~CImGui.ImGuiComboFlags_NoPreview
    end
    return State(s.label, s.items, s.current_item, flags | a.flag)
end

# helper
"""
    Combo(store::AbstractStore, get_state=Redux.get_state) -> Bool
Return `true` when opened.
"""
function Combo(store::AbstractStore, get_state=Redux.get_state)
    state = get_state(store)
    is_opened = false
    current_item = state.current_item
    if CImGui.BeginCombo(get_label(state), current_item, state.flags)
        for item in state.items
            is_selected = item == current_item
            CImGui.Selectable(item, is_selected) && (current_item = item;)
            is_selected && CImGui.SetItemDefaultFocus()
        end
        is_opened = true
        CImGui.EndCombo()
    end
    is_opened && dispatch!(store, SetCurrentItemTo(get_label(state), current_item))
    return is_opened
end

"""
    get_label(s::State) -> String
Return the combo label/identifier.
"""
get_label(s::State) = s.label

"""
    get_current_item(s::State) -> String
"""
get_current_item(s::State) = s.current_item

end # module
