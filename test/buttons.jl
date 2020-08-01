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
    @test get_state(store).is_triggered == true

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

@testset "Buttons | RadioButton" begin
    name = "Radio_button_test"
    store = create_store(RadioButtons.reducer, RadioButtons.State(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test state.is_active == false
    @test state.is_triggered == false

    # test actions
    new_name = "Radio_button_new_name"
    state = get_state(store)
    dispatch!(store, RadioButtons.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, RadioButtons.Rename(state.label, name))
    @test RadioButtons.get_label(get_state(store)) == name

    dispatch!(store, RadioButtons.SetActiveTo(state.label, true))
    @test get_state(store).is_active == true

    dispatch!(store, RadioButtons.SetTriggeredTo(state.label, true))
    @test get_state(store).is_triggered == true

    # test vectors
    store = create_store(RadioButtons.reducer, [RadioButtons.State("b1"),RadioButtons.State("b2")])
    state = get_state(store) 
    dispatch!(store, RadioButtons.AddButton("b3"))
    dispatch!(store, RadioButtons.DeleteButton("b1"))
    state = get_state(store)
    @test state[1] == RadioButtons.State("b2")
    @test state[2] == RadioButtons.State("b3")
    dispatch!(store, RadioButtons.SetTriggeredTo("b2", true))
    @test RadioButtons.is_triggered(get_state(store)[1]) == true

    dispatch!(store, RadioButtons.OnlySetThisOneToActive("b3"))
    @test RadioButtons.is_active(get_state(store)[1]) == false
    @test RadioButtons.is_active(get_state(store)[2]) == true

    # test dicts
    store = create_store(RadioButtons.reducer, Dict("b1"=>RadioButtons.State("b1"),"b2"=>RadioButtons.State("b2")))
    state = get_state(store)
    dispatch!(store, RadioButtons.SetActiveTo("b2", true))
    state = get_state(store)
    @test RadioButtons.is_active(state["b2"]) == true
end

@testset "Buttons | RadioButtonGroup" begin
    RBG = RadioButtonGroups
    name = "Radio_button_group_test"
    store = create_store(RBG.reducer, RBG.State(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test isempty(state.buttons) == true
    @test state.is_triggered == false

    # test actions
    new_name = "Radio_button_group_new_name"
    state = get_state(store)
    dispatch!(store, RBG.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, RBG.Rename(state.label, name))
    @test RBG.get_label(get_state(store)) == name

    dispatch!(store, RBG.SetTriggeredTo(state.label, true))
    @test get_state(store).is_triggered == true

    dispatch!(store, RBG.EditButtons(state.label, RadioButtons.AddButton("radio button1")))
    dispatch!(store, RBG.EditButtons(state.label, RadioButtons.SetActiveTo("radio button1", true)))
    @test get_state(store).buttons[1].is_active == true

    # test dicts
    store = create_store(RBG.reducer, Dict("b1"=>RBG.State("b1"),"b2"=>RBG.State("b2")))
    state = get_state(store)
    dispatch!(store, RBG.EditButtons(RBG.get_label(state["b1"]), RadioButtons.AddButton("radio button1")))
    state = get_state(store)
    @test state["b1"].buttons[1].label == "radio button1"
end