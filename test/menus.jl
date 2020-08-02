using ReduxImGui
using ReduxImGui.Redux
using Test

@testset "Menus | MenuItem" begin
    name = "MenuItem_test"
    store = create_store(MenuItems.reducer, MenuItems.State(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test state.shortcut == ""
    @test state.is_selected == false
    @test state.is_enabled == true
    @test state.is_triggered == false

    # test actions
    new_name = "MenuItem_new_name"
    state = get_state(store)
    dispatch!(store, MenuItems.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, MenuItems.Rename(state.label, name))
    @test MenuItems.get_label(get_state(store)) == name

    new_shortcut = "Ctrl+Z"
    state = get_state(store)
    dispatch!(store, MenuItems.ChangeShortcut(state.label, new_shortcut))
    @test MenuItems.get_shortcut(get_state(store)) == new_shortcut

    dispatch!(store, MenuItems.SetSelectedTo(state.label, true))
    @test MenuItems.is_selected(get_state(store)) == true

    dispatch!(store, MenuItems.Toggle(state.label))
    @test MenuItems.is_selected(get_state(store)) == false

    dispatch!(store, MenuItems.Enable(state.label))
    @test MenuItems.is_enabled(get_state(store)) == true

    dispatch!(store, MenuItems.Disable(state.label))
    @test MenuItems.is_enabled(get_state(store)) == false

    dispatch!(store, MenuItems.SetTriggeredTo(state.label, true))
    @test MenuItems.is_triggered(get_state(store)) == true

    # test vectors
    store = create_store(MenuItems.reducer, [MenuItems.State("m1"),MenuItems.State("m2")])
    state = get_state(store) 
    dispatch!(store, MenuItems.AddMenuItem("m3"))
    dispatch!(store, MenuItems.DeleteMenuItem("m1"))
    state = get_state(store)
    @test state[1] == MenuItems.State("m2")
    @test state[2] == MenuItems.State("m3")
    dispatch!(store, MenuItems.SetTriggeredTo("m2", false))
    @test MenuItems.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(MenuItems.reducer, Dict("m1"=>MenuItems.State("m1"),"m2"=>MenuItems.State("m2")))
    state = get_state(store)
    dispatch!(store, MenuItems.Enable("m2"))
    state = get_state(store)
    @test MenuItems.is_enabled(state["m2"]) == true
end

@testset "Menus | Menus" begin
    name = "Menus_test"
    store = create_store(Menus.reducer, Menus.State(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test state.items == []
    @test state.is_enabled == true
    @test state.is_triggered == false

    # test actions
    new_name = "Menus_new_name"
    state = get_state(store)
    dispatch!(store, Menus.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, Menus.Rename(state.label, name))
    @test Menus.get_label(get_state(store)) == name

    dispatch!(store, Menus.Enable(state.label))
    @test Menus.is_enabled(get_state(store)) == true

    dispatch!(store, Menus.Disable(state.label))
    @test Menus.is_enabled(get_state(store)) == false

    dispatch!(store, Menus.SetTriggeredTo(state.label, true))
    @test Menus.is_triggered(get_state(store)) == true

    dispatch!(store, Menus.EditMenuItems(state.label, MenuItems.AddMenuItem("mt")))
    @test get_state(store).items[1].label == "mt"

    # test vectors
    store = create_store(Menus.reducer, [Menus.State("m1"),Menus.State("m2")])
    state = get_state(store) 
    dispatch!(store, Menus.AddMenu("m3"))
    dispatch!(store, Menus.DeleteMenu("m1"))
    state = get_state(store)
    @test state[1].label == "m2"
    @test state[2].label == "m3" 
    dispatch!(store, Menus.SetTriggeredTo("m2", false))
    @test Menus.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(Menus.reducer, Dict("m1"=>Menus.State("m1"),"m2"=>Menus.State("m2")))
    state = get_state(store)
    dispatch!(store, Menus.Enable("m2"))
    state = get_state(store)
    @test Menus.is_enabled(state["m2"]) == true
end