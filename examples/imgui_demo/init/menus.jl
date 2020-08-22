const IMGUI_DEMO_MENU_OPEN_RESENT_STATES = Menu(
    "Open Recent",
    [
        MenuItem("fish_hat.c"),
        MenuItem("fish_hat.inl"),
        MenuItem("fish_hat.h"),
        Menu(
            "More..",
            [
                MenuItem("Hello"),
                MenuItem("Sailor"),
                Menu("Recurse..", [], false)
            ],
            true,
        )
    ],
    true,
)

struct ItemSeparator <: MenuItems.AbstractGenericMenuItem end
(x::ItemSeparator)() = CImGui.Separator()

mutable struct MenuOptions <: MenuItems.AbstractGenericMenuItem 
    enabled::Bool
    f::Cfloat
    n::Cint
    b::Bool
end
function (x::MenuOptions)()
    if CImGui.BeginMenu("Options")
        CImGui.CSyntax.@c CImGui.MenuItem("Enabled", "", &x.enabled)

        CImGui.BeginChild("child", CImGui.ImVec2(0, 60), true)
            foreach(i->CImGui.Text("Scrolling Text $i"), 0:9)
        CImGui.EndChild()

        CImGui.CSyntax.@c CImGui.SliderFloat("Value", &x.f, 0.0, 1.0)
        CImGui.CSyntax.@c CImGui.InputFloat("Input", &x.f, 0.1)
        CImGui.CSyntax.@c CImGui.Combo("Combo", &x.n, "Yes\0No\0Maybe\0\0")
        CImGui.CSyntax.@c CImGui.Checkbox("Check", &x.b)

        CImGui.EndMenu()
    end
end

struct MenuColors <: MenuItems.AbstractGenericMenuItem end
function (x::MenuColors)()
    if CImGui.BeginMenu("Colors")
        sz = CImGui.GetTextLineHeight()
        for i = 0:CImGui.ImGuiCol_COUNT-1
            name = CImGui.GetStyleColorName(i)
            p = CImGui.GetCursorScreenPos()
            CImGui.AddRectFilled(CImGui.GetWindowDrawList(), p, (p.x+sz,p.y+sz), CImGui.GetColorU32(i))
            CImGui.Dummy(sz, sz)
            CImGui.SameLine()
            CImGui.MenuItem(name)
        end
        CImGui.EndMenu()
    end
end

const IMGUI_DEMO_MENU_FILE_STATES = Menu(
    "File",
    [
        MenuItem("(dummy menu)", "", false),
        MenuItem("New"),
        MenuItem("Open", "Ctrl+O"),
        IMGUI_DEMO_MENU_OPEN_RESENT_STATES,
        MenuItem("Save", "Ctrl+S"),
        MenuItem("Save As.."),
        ItemSeparator(),
        MenuOptions(true, 0.5, 0, true),
        MenuColors(),
        ToggleMenuItem("Checked", "", true),
        MenuItem("Quit", "Alt+F4"),
    ],
    true,
)



const IMGUI_DEMO_MENU_EDIT_STATES = Menu(
    "Edit",
    [
        MenuItem("Undo", "CTRL+Z"),
        MenuItem("Redo", "CTRL+Y", false),
        ItemSeparator(),
        MenuItem("Cut", "CTRL+X"),
        MenuItem("Copy", "CTRL+C"),
        MenuItem("Paste", "CTRL+V"),
    ],
    true,
)

const IMGUI_DEMO_MENU_STATES = [
    IMGUI_DEMO_MENU_FILE_STATES,
    IMGUI_DEMO_MENU_EDIT_STATES,
]

const IMGUI_DEMO_MAIN_MENUBAR_STATES = MainMenuBar(
    "Example: MainMenuBar",
    IMGUI_DEMO_MENU_STATES,
    false,
)