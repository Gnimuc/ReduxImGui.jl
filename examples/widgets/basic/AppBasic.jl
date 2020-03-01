module AppBasic

using ReduxImGui
using ReduxImGui.Redux

# state
struct State <: AbstractImmutableState
    button::ReduxButton.State
end

# reducers
function app_basic(state::AbstractState, action::AbstractAction)
    next_button_state = ReduxButton.button(state.button, action)
    return State(next_button_state)
end

end # module
