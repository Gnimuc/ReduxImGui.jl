using ReduxImGui
using ReduxImGui.Redux
using Test

@testset "Buttons" begin
    name = "Button_test"
    store = create_store(Buttons.button, Buttons.State(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test state.size.x == 0
    @test state.size.y == 0
    @test state.is_clicked == false

    # test actions
    new_name = "Button_new_name"
    state = get_state(store)
    dispatch!(store, Buttons.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, Buttons.Rename(state.label, name))
    @test get_state(store).label == name

    new_size = (100, 200)
    state = get_state(store)
    dispatch!(store, Buttons.Resize(state.label, new_size...))
    @test get_state(store).size.x == new_size[1]
    @test get_state(store).size.y == new_size[2]

    dispatch!(store, Buttons.ChangeWidth(state.label, 7))
    @test get_state(store).size.x == 7

    dispatch!(store, Buttons.ChangeHeight(state.label, 77))
    @test get_state(store).size.y == 77

    state = get_state(store)
    dispatch!(store, Buttons.Toggle(state.label))
    @test get_state(store).is_clicked == !state.is_clicked
end