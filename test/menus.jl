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

    dispatch!(store, MenuItems.Enable(state.label))
    @test MenuItems.is_enabled(get_state(store)) == true

    dispatch!(store, MenuItems.Disable(state.label))
    @test MenuItems.is_enabled(get_state(store)) == false

    dispatch!(store, MenuItems.SetTriggeredTo(state.label, true))
    @test MenuItems.is_triggered(get_state(store)) == true

    # test vectors
    store = create_store(MenuItems.reducer, [MenuItems.State("m1"),MenuItems.State("m2"),MenuItemSeparators.State()])
    state = get_state(store) 
    dispatch!(store, MenuItems.AddMenuItem("m3"))
    dispatch!(store, MenuItems.DeleteMenuItem("m1"))
    state = get_state(store)
    @test state[1] == MenuItems.State("m2")
    @test state[3] == MenuItems.State("m3")
    dispatch!(store, MenuItems.SetTriggeredTo("m2", false))
    @test MenuItems.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(MenuItems.reducer, Dict("m1"=>MenuItems.State("m1"),"m2"=>MenuItems.State("m2")))
    state = get_state(store)
    dispatch!(store, MenuItems.Enable("m2"))
    state = get_state(store)
    @test MenuItems.is_enabled(state["m2"]) == true
end

@testset "Menus | ToggleMenuItem" begin
    MIWC = ToggleMenuItems
    name = "MenuItem_test"
    store = create_store(MIWC.reducer, MIWC.State(name))
    state = get_state(store)

    # test initial state
    @test state.is_selected == false

    # test actions
    new_name = "MenuItem_new_name"
    state = get_state(store)
    dispatch!(store, MIWC.Rename(MIWC.get_label(state), new_name))
    @test MIWC.get_label(get_state(store)) == new_name
    dispatch!(store, MIWC.Rename(MIWC.get_label(state), name))
    @test MIWC.get_label(get_state(store)) == name

    new_shortcut = "Ctrl+Z"
    state = get_state(store)
    dispatch!(store, MIWC.ChangeShortcut(MIWC.get_label(state), new_shortcut))
    @test MIWC.get_shortcut(get_state(store)) == new_shortcut

    dispatch!(store, MIWC.SetSelectedTo(MIWC.get_label(state), true))
    @test MIWC.is_selected(get_state(store)) == true

    dispatch!(store, MIWC.Toggle(MIWC.get_label(state)))
    @test MIWC.is_selected(get_state(store)) == false

    dispatch!(store, MIWC.Enable(MIWC.get_label(state)))
    @test MIWC.is_enabled(get_state(store)) == true

    dispatch!(store, MIWC.Disable(MIWC.get_label(state)))
    @test MIWC.is_enabled(get_state(store)) == false

    dispatch!(store, MIWC.SetTriggeredTo(MIWC.get_label(state), true))
    @test MIWC.is_triggered(get_state(store)) == true

    # test vectors
    store = create_store(MIWC.reducer, [MIWC.State("m1"),MIWC.State("m2")])
    state = get_state(store) 
    dispatch!(store, MIWC.AddMenuItem("m3"))
    dispatch!(store, MIWC.DeleteMenuItem("m1"))
    state = get_state(store)
    @test state[1] == MIWC.State("m2")
    @test state[2] == MIWC.State("m3")
    dispatch!(store, MIWC.SetTriggeredTo("m2", false))
    @test MIWC.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(MIWC.reducer, Dict("m1"=>MIWC.State("m1"),"m2"=>MIWC.State("m2")))
    state = get_state(store)
    dispatch!(store, MIWC.Enable("m2"))
    state = get_state(store)
    @test MIWC.is_enabled(state["m2"]) == true
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

    dispatch!(store, Menus.EditMenuItems(state.label, ToggleMenuItems.AddMenuItem("mtc")))
    @test Menus.get_label(get_state(store).items[2]) == "mtc"

    # submenu
    name = "SubMenu_test"
    store = create_store(Menus.reducer, Menus.State(name, [MenuItems.State("item1"), Menus.State("submenu1")]))
    state = get_state(store)
    dispatch!(store, Menus.EditMenuItems(state.label, ToggleMenuItems.AddMenuItem("item2")))
    @test Menus.get_label(get_state(store).items[3]) == "item2"

    dispatch!(
        store, 
        Menus.EditMenuItems(
            state.label, 
            Menus.EditMenuItems(
                "submenu1", 
                ToggleMenuItems.AddMenuItem("item2")
            )
        )
    )
    @test Menus.get_label(get_state(store).items[2].items[]) == "item2"

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