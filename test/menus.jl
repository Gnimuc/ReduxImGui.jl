using ReduxImGui
using ReduxImGui.Redux
using Test

struct ItemSeparator <: MenuItems.AbstractGenericMenuItem end
(x::ItemSeparator)() = ReduxImGui.CImGui.Separator()

@testset "Menus | MenuItem" begin
    name = "MenuItem_test"
    store = create_store(MenuItems.reducer, MenuItem(name))
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
    @test get_state(store).label == name

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
    store = create_store(MenuItems.reducer, [MenuItem("m1"),MenuItem("m2"),ItemSeparator()])
    state = get_state(store) 
    dispatch!(store, MenuItems.AddMenuItem("m3"))
    dispatch!(store, MenuItems.DeleteMenuItem("m1"))
    state = get_state(store)
    @test state[1] == MenuItem("m2")
    @test state[3] == MenuItem("m3")
    dispatch!(store, MenuItems.SetTriggeredTo("m2", false))
    @test MenuItems.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(MenuItems.reducer, Dict("m1"=>MenuItem("m1"),"m2"=>MenuItem("m2")))
    state = get_state(store)
    dispatch!(store, MenuItems.Enable("m2"))
    state = get_state(store)
    @test MenuItems.is_enabled(state["m2"]) == true
end

@testset "Menus | ToggleMenuItem" begin
    name = "MenuItem_test"
    store = create_store(ToggleMenuItems.reducer, ToggleMenuItem(name))
    state = get_state(store)

    # test initial state
    @test state.is_selected == false

    # test actions
    new_name = "MenuItem_new_name"
    state = get_state(store)
    dispatch!(store, ToggleMenuItems.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, ToggleMenuItems.Rename(state.label, name))
    @test get_state(store).label == name

    new_shortcut = "Ctrl+Z"
    state = get_state(store)
    dispatch!(store, ToggleMenuItems.ChangeShortcut(state.label, new_shortcut))
    @test ToggleMenuItems.get_shortcut(get_state(store)) == new_shortcut

    dispatch!(store, ToggleMenuItems.SetSelectedTo(state.label, true))
    @test ToggleMenuItems.is_selected(get_state(store)) == true

    dispatch!(store, ToggleMenuItems.Toggle(state.label))
    @test ToggleMenuItems.is_selected(get_state(store)) == false

    dispatch!(store, ToggleMenuItems.Enable(state.label))
    @test ToggleMenuItems.is_enabled(get_state(store)) == true

    dispatch!(store, ToggleMenuItems.Disable(state.label))
    @test ToggleMenuItems.is_enabled(get_state(store)) == false

    dispatch!(store, ToggleMenuItems.SetTriggeredTo(state.label, true))
    @test ToggleMenuItems.is_triggered(get_state(store)) == true

    # test vectors
    store = create_store(ToggleMenuItems.reducer, [ToggleMenuItem("m1"),ToggleMenuItem("m2")])
    state = get_state(store) 
    dispatch!(store, ToggleMenuItems.AddMenuItem("m3"))
    dispatch!(store, ToggleMenuItems.DeleteMenuItem("m1"))
    state = get_state(store)
    @test state[1] == ToggleMenuItem("m2")
    @test state[2] == ToggleMenuItem("m3")
    dispatch!(store, ToggleMenuItems.SetTriggeredTo("m2", false))
    @test ToggleMenuItems.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(ToggleMenuItems.reducer, Dict("m1"=>ToggleMenuItem("m1"),"m2"=>ToggleMenuItem("m2")))
    state = get_state(store)
    dispatch!(store, ToggleMenuItems.Enable("m2"))
    state = get_state(store)
    @test ToggleMenuItems.is_enabled(state["m2"]) == true
end

@testset "Menus | Menus" begin
    name = "Menus_test"
    store = create_store(Menus.reducer, Menu(name))
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
    @test get_state(store).label == name

    dispatch!(store, Menus.Enable(state.label))
    @test Menus.is_enabled(get_state(store)) == true

    dispatch!(store, Menus.Disable(state.label))
    @test Menus.is_enabled(get_state(store)) == false

    dispatch!(store, Menus.SetTriggeredTo(state.label, true))
    @test Menus.is_triggered(get_state(store)) == true

    dispatch!(store, Menus.EditMenuItems(state.label, MenuItems.AddMenuItem("mt")))
    @test get_state(store).items[1].label == "mt"

    dispatch!(store, Menus.EditMenuItems(state.label, ToggleMenuItems.AddMenuItem("mtc")))
    @test get_state(store).items[2].label == "mtc"

    # submenu
    name = "SubMenu_test"
    store = create_store(Menus.reducer, Menu(name, [MenuItem("item1"), Menu("submenu1")]))
    state = get_state(store)
    dispatch!(store, Menus.EditMenuItems(state.label, ToggleMenuItems.AddMenuItem("item2")))
    @test get_state(store).items[3].label == "item2"

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
    @test get_state(store).items[2].items[].label == "item2"

    # test vectors
    store = create_store(Menus.reducer, [Menu("m1"),Menu("m2")])
    state = get_state(store) 
    dispatch!(store, Menus.AddMenu("m3"))
    dispatch!(store, Menus.DeleteMenu("m1"))
    state = get_state(store)
    @test state[1].label == "m2"
    @test state[2].label == "m3" 
    dispatch!(store, Menus.SetTriggeredTo("m2", false))
    @test Menus.is_triggered(get_state(store)[1]) == false

    # test dicts
    store = create_store(Menus.reducer, Dict("m1"=>Menu("m1"),"m2"=>Menu("m2")))
    state = get_state(store)
    dispatch!(store, Menus.Enable("m2"))
    state = get_state(store)
    @test Menus.is_enabled(state["m2"]) == true
end

@testset "Menus | MenuBar" begin
    name = "MenuBar_test"
    store = create_store(MenuBars.reducer, MenuBar(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test state.menus == []
    @test state.is_hidden == false
    @test state.is_triggered == false

    # test actions
    new_name = "MenuBar_new_name"
    state = get_state(store)
    dispatch!(store, MenuBars.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, MenuBars.Rename(state.label, name))
    @test get_state(store).label == name

    dispatch!(store, MenuBars.Show(state.label))
    @test MenuBars.is_hidden(get_state(store)) == false

    dispatch!(store, MenuBars.Hide(state.label))
    @test MenuBars.is_hidden(get_state(store)) == true

    dispatch!(store, MenuBars.SetTriggeredTo(state.label, true))
    @test MenuBars.is_triggered(get_state(store)) == true

    dispatch!(store, MenuBars.EditMenus(state.label, Menus.AddMenu("m")))
    @test get_state(store).menus[1].label == "m"

    dispatch!(store, MenuBars.EditMenus(state.label, Menus.AddMenu("m2")))
    @test get_state(store).menus[2].label == "m2"
end

@testset "Menus | MainMenuBar" begin
    name = "MainMenuBar_test"
    store = create_store(MainMenuBars.reducer, MainMenuBar(name))
    state = get_state(store)

    # test initial state
    @test state.label == name
    @test state.menus == []
    @test state.is_hidden == false
    @test state.is_triggered == false

    # test actions
    new_name = "MainMenuBar_new_name"
    state = get_state(store)
    dispatch!(store, MainMenuBars.Rename(state.label, new_name))
    @test get_state(store).label == new_name
    dispatch!(store, MainMenuBars.Rename(state.label, name))
    @test get_state(store).label == name

    dispatch!(store, MainMenuBars.Show(state.label))
    @test MainMenuBars.is_hidden(get_state(store)) == false

    dispatch!(store, MainMenuBars.Hide(state.label))
    @test MainMenuBars.is_hidden(get_state(store)) == true

    dispatch!(store, MainMenuBars.SetTriggeredTo(state.label, true))
    @test MainMenuBars.is_triggered(get_state(store)) == true

    dispatch!(store, MainMenuBars.EditMenus(state.label, Menus.AddMenu("m")))
    @test get_state(store).menus[1].label == "m"

    dispatch!(store, MainMenuBars.EditMenus(state.label, Menus.AddMenu("m2")))
    @test get_state(store).menus[2].label == "m2"
end