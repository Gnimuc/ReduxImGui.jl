module MenuItemSeparators

using Redux
using CImGui
using ..MenuItems
import ..MenuItems: AbstractMenuItemAction, AbstractMenuItemState, get_label

# state
"""
    MenuItemSeparators.State()
A fake menu item that should be rendered as `CImGui.Separator()`.
"""
struct State <: AbstractMenuItemState end

get_label(s::State) = "___REDUXIMGUI_RESERVED_DUMMY_LABEL"
is_separator(s::AbstractMenuItemState) = false
is_separator(s::State) = true

# reducers
reducer(state::AbstractState, action::AbstractAction) = state
reducer(state::Vector{<:AbstractState}, action::AbstractAction) = state
reducer(state::Dict{String,<:AbstractState}, action::AbstractAction) = state

end # module
