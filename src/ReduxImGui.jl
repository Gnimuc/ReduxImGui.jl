module ReduxImGui

using Redux
using CImGui

include("forward_decls.jl")

include("buttons/RigButton.jl")
using .RigButton
import .RigButton: Button, is_on, get_size
export RigButton

include("buttons/RigColorButton.jl")
using .RigColorButton
import .RigColorButton: ColorButton, get_color, get_hovered_color, get_active_color
export RigColorButton

include("buttons/RigRadioButton.jl")
using .RigRadioButton
import .RigRadioButton: RadioButton, is_active
export RigRadioButton

include("buttons/RigArrowButton.jl")
using .RigArrowButton
import .RigArrowButton: ArrowButton
export RigArrowButton

include("checkboxes/RigCheckbox.jl")
using .RigCheckbox
import .RigCheckbox: Checkbox, is_check
export RigCheckbox

include("combos/RigCombo.jl")
using .RigCombo
import .RigCombo: Combo
export RigCombo

include("inputs/RigInputText.jl")
using .RigInputText
import .RigInputText: InputText, get_string
export RigInputText

include("inputs/RigInputTextWithHint.jl")
using .RigInputTextWithHint
import .RigInputTextWithHint: InputTextWithHint
export RigInputTextWithHint

include("inputs/RigInputInt.jl")
using .RigInputInt
import .RigInputInt: InputInt
export RigInputInt

include("inputs/RigInputFloat.jl")
using .RigInputFloat
import .RigInputFloat: InputFloat
export RigInputFloat

include("inputs/RigInputDouble.jl")
using .RigInputDouble
import .RigInputDouble: InputDouble
export RigInputDouble

include("drags/RigDragInt.jl")
using .RigDragInt
import .RigDragInt: DragInt
export RigDragInt

include("drags/RigDragFloat.jl")
using .RigDragFloat
import .RigDragFloat: DragFloat
export RigDragFloat

include("sliders/RigSliderInt.jl")
using .RigSliderInt
import .RigSliderInt: SliderInt
export RigSliderInt

include("sliders/RigSliderFloat.jl")
using .RigSliderFloat
import .RigSliderFloat: SliderFloat
export RigSliderFloat

include("sliders/RigSliderAngle.jl")
using .RigSliderAngle
import .RigSliderAngle: SliderAngle
export RigSliderAngle

include("layout/RigTreeNode.jl")
using .RigTreeNode
import .RigTreeNode: TreeNode, TreeNodeEx
export RigTreeNode


end # module
