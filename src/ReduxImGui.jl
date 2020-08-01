module ReduxImGui

using Redux
using CImGui

include("forward_decls.jl")

## Buttons
include("buttons/Buttons.jl")
using .Buttons
import .Buttons: Button
export Buttons

include("buttons/OnOffButtons.jl")
using .OnOffButtons
import .OnOffButtons: OnOffButton
export OnOffButtons

include("buttons/ColorButtons.jl")
using .ColorButtons
import .ColorButtons: ColorButton
export ColorButtons

include("buttons/RadioButtons.jl")
using .RadioButtons
import .RadioButtons: RadioButton
export RadioButtons

include("buttons/RadioButtonGroups.jl")
using .RadioButtonGroups
import .RadioButtonGroups: RadioButtonGroup
export RadioButtonGroups

include("buttons/ArrowButtons.jl")
using .ArrowButtons
import .ArrowButtons: ArrowButton
export ArrowButtons

## Checkboxes
include("checkboxes/Checkboxes.jl")
using .Checkboxes
import .Checkboxes: Checkbox, is_check
export Checkboxes

## Combos
include("combos/Combos.jl")
using .Combos
import .Combos: Combo
export Combos

## Inputs
include("inputs/InputTexts.jl")
using .InputTexts
import .InputTexts: InputText
export InputTexts

include("inputs/InputTextWithHints.jl")
using .InputTextWithHints
import .InputTextWithHints: InputTextWithHint
export InputTextWithHints

include("inputs/InputInts.jl")
using .InputInts
import .InputInts: InputInt
export InputInts

include("inputs/InputFloats.jl")
using .InputFloats
import .InputFloats: InputFloat
export InputFloats

include("inputs/InputDoubles.jl")
using .InputDoubles
import .InputDoubles: InputDouble
export InputDoubles

## Drags
include("drags/DragInts.jl")
using .DragInts
import .DragInts: DragInt
export DragInts

include("drags/DragFloats.jl")
using .DragFloats
import .DragFloats: DragFloat
export DragFloats

## Sliders
include("sliders/SliderInts.jl")
using .SliderInts
import .SliderInts: SliderInt
export SliderInts

include("sliders/SliderFloats.jl")
using .SliderFloats
import .SliderFloats: SliderFloat
export SliderFloats

include("sliders/SliderAngles.jl")
using .SliderAngles
import .SliderAngles: SliderAngle
export SliderAngles

include("sliders/SliderStrings.jl")
using .SliderStrings
import .SliderStrings: SliderString
export SliderStrings

## ColorEdits
include("color_edits/ColorEdits.jl")
using .ColorEdits
import .ColorEdits: ColorEdit
export ColorEdits

## ListBoxes
include("listboxes/ListBoxes.jl")
using .ListBoxes
import .ListBoxes: ListBox, get_items, get_item
export ListBoxes

## Menus
include("menus/MenuItems.jl")
using .MenuItems
import .MenuItems: MenuItem
export MenuItems

include("menus/Menus.jl")
using .Menus
import .Menus: Menu
export Menus

include("menus/MenuBars.jl")
using .MenuBars
import .MenuBars: MenuBar
export MenuBars

include("menus/MainMenuBars.jl")
using .MainMenuBars
import .MainMenuBars: MainMenuBar
export MainMenuBars

## Others
include("trees/TreeNodes.jl")
using .TreeNodes
import .TreeNodes: TreeNode, TreeNodeEx
export TreeNodes

include("tooltips/Tooltips.jl")
using .Tooltips
import .Tooltips: Tooltip
export Tooltips

end # module
