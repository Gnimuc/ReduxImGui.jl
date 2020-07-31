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
    @test Buttons.get_label(get_state(store)) == name

    new_size = (100, 200)
    state = get_state(store)
    dispatch!(store, Buttons.Resize(state.label, new_size...))
    @test get_state(store).size[1] == new_size[1]
    @test get_state(store).size[2] == new_size[2]

    dispatch!(store, Buttons.ChangeWidth(state.label, 7))
    @test get_state(store).size[1] == 7

    dispatch!(store, Buttons.ChangeHeight(state.label, 77))
    @test get_state(store).size[2] == 77

    dispatch!(store, Buttons.SetTriggeredTo(state.label, true))
    @test get_state(store).size[2] == 77

    # test vectors
    store = create_store(Buttons.reducer, [Buttons.State("b1"),Buttons.State("b2")])
    state = get_state(store) 
    dispatch!(store, Buttons.AddButton("b3"))
    dispatch!(store, Buttons.DeleteButton("b1"))
    state = get_state(store)
    @test state[1] == Buttons.State("b2")
    @test state[2] == Buttons.State("b3")
    dispatch!(store, Buttons.SetTriggeredTo("b2", false))
    @test Buttons.is_triggered(get_state(store)[1]) == false

    # test dicts
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

    # test vectors
    store = create_store(OnOffButtons.reducer, [OnOffButtons.State("b1"),OnOffButtons.State("b2")])
    state = get_state(store) 
    dispatch!(store, OnOffButtons.AddButton("b3"))
    dispatch!(store, OnOffButtons.DeleteButton("b1"))
    state = get_state(store)
    @test state[1] == OnOffButtons.State("b2")
    @test state[2] == OnOffButtons.State("b3")
    dispatch!(store, OnOffButtons.SetTriggeredTo("b2", false))
    @test OnOffButtons.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(OnOffButtons.reducer, Dict("b1"=>OnOffButtons.State("b1"),"b2"=>OnOffButtons.State("b2")))
    state = get_state(store)
    dispatch!(store, OnOffButtons.Resize("b2", 10, 20))
    state = get_state(store)
    @test OnOffButtons.get_size(state["b2"]) == (10,20) 
end

@testset "Buttons | ColorButton" begin
    name = "ColorButton_test"
    store = create_store(ColorButtons.reducer, ColorButtons.State(name))
    state = get_state(store)

    # test initial state
    @test ColorButtons.get_label(state) == name
    @test ColorButtons.get_size(state) == (0,0)
    @test ColorButtons.is_triggered(state) == false

    # test actions
    new_size = (100, 200)
    state = get_state(store)
    dispatch!(store, ColorButtons.SetButtonColorTo(ColorButtons.get_label(state), 0.0, 0.0, 1.0))
    @test ColorButtons.get_color(get_state(store)) == ReduxImGui.CImGui.HSV(0.0, 0.0, 1.0)
    dispatch!(store, ColorButtons.SetHoveredColorTo(ColorButtons.get_label(state), 1.0, 0.0, 1.0))
    @test ColorButtons.get_hovered_color(get_state(store)) == ReduxImGui.CImGui.HSV(1.0, 0.0, 1.0)
    dispatch!(store, ColorButtons.SetActiveColorTo(ColorButtons.get_label(state), 0.5, 1.0, 0.0))
    @test ColorButtons.get_active_color(get_state(store)) == ReduxImGui.CImGui.HSV(0.5, 1.0, 0.0)

    # test vectors
    store = create_store(ColorButtons.reducer, [ColorButtons.State("b1"),ColorButtons.State("b2")])
    state = get_state(store) 
    dispatch!(store, ColorButtons.AddButton("b3"))
    dispatch!(store, ColorButtons.DeleteButton("b1"))
    state = get_state(store)
    @test state[1] == ColorButtons.State("b2")
    @test state[2] == ColorButtons.State("b3")
    dispatch!(store, ColorButtons.SetTriggeredTo("b2", false))
    @test ColorButtons.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(ColorButtons.reducer, Dict("b1"=>ColorButtons.State("b1"),"b2"=>ColorButtons.State("b2")))
    state = get_state(store)
    dispatch!(store, ColorButtons.Resize("b2", 10, 20))
    state = get_state(store)
    @test ColorButtons.get_size(state["b2"]) == (10,20) 
end