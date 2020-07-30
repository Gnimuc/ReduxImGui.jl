using ReduxImGui
using ReduxImGui.Redux
using Test

@testset "Buttons | Button" begin
    name = "Button_test"
    store = create_store(Buttons.reducer, Buttons.State(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test state.size[1] == 0
    @test state.size[2] == 0
    @test state.is_triggered == false

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
    @test get_state(store).size[1] == new_size[1]
    @test get_state(store).size[2] == new_size[2]

    dispatch!(store, Buttons.ChangeWidth(state.label, 7))
    @test get_state(store).size[1] == 7

    dispatch!(store, Buttons.ChangeHeight(state.label, 77))
    @test get_state(store).size[2] == 77

    # test Vectors
    store = create_store(Buttons.reducer, [Buttons.State("b1"),Buttons.State("b2")])
    state = get_state(store) 
    dispatch!(store, Buttons.AddButton("b3"))
    dispatch!(store, Buttons.DeleteButton("b1"))
    state = get_state(store)
    @test state[1] == Buttons.State("b2")
    @test state[2] == Buttons.State("b3")

    # test Dicts
    store = create_store(Buttons.reducer, Dict("b1"=>Buttons.State("b1"),"b2"=>Buttons.State("b2")))
    state = get_state(store) 
    dispatch!(store, Buttons.Resize("b2", 10, 20))
    state = get_state(store)
    @test Buttons.get_size(state["b2"]) == (10,20)
end

@testset "Buttons | OnOffButton" begin
    name = "OnOffButton_test"
    store = create_store(OnOffButtons.reducer, OnOffButtons.State(name))
    state = get_state(store)

    # test initial state
    @test OnOffButtons.get_label(state) == name
    @test OnOffButtons.get_size(state) == (0,0)
    @test OnOffButtons.is_triggered(state) == false
    @test OnOffButtons.is_on(state) == false

    # test actions
    new_size = (100, 200)
    state = get_state(store)
    dispatch!(store, OnOffButtons.Toggle(OnOffButtons.get_label(state)))
    state = get_state(store)
    @test OnOffButtons.is_on(state) == true
    dispatch!(store, OnOffButtons.Toggle(OnOffButtons.get_label(state)))
    state = get_state(store)
    @test OnOffButtons.is_on(state) == false


end