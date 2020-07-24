module ReduxImGui

using Redux
using CImGui

include("forward_decls.jl")

include("basic/RigButton.jl")
using .RigButton
import .RigButton: Button, is_on, get_size
export RigButton

include("basic/RigColorButton.jl")
using .RigColorButton
import .RigColorButton: ColorButton, get_color, get_hovered_color, get_active_color
export RigColorButton

include("basic/RigCheckbox.jl")
using .RigCheckbox
import .RigCheckbox: Checkbox, is_check
export RigCheckbox

include("basic/RigRadioButton.jl")
using .RigRadioButton
import .RigRadioButton: RadioButton, is_active
export RigRadioButton

include("basic/RigArrowButton.jl")
using .RigArrowButton
import .RigArrowButton: ArrowButton
export RigArrowButton

include("combo/RigCombo.jl")
using .RigCombo
import .RigCombo: Combo
export RigCombo

include("input/RigInputText.jl")
using .RigInputText
import .RigInputText: InputText, get_string
export RigInputText

include("input/RigInputTextWithHint.jl")
using .RigInputTextWithHint
import .RigInputTextWithHint: InputTextWithHint
export RigInputTextWithHint

include("input/RigInputInt.jl")
using .RigInputInt
import .RigInputInt: InputInt
export RigInputInt

include("input/RigInputFloat.jl")
using .RigInputFloat
import .RigInputFloat: InputFloat
export RigInputFloat

include("input/RigInputDouble.jl")
using .RigInputDouble
import .RigInputDouble: InputDouble
export RigInputDouble

include("drag/RigDragInt.jl")
using .RigDragInt
import .RigDragInt: DragInt
export RigDragInt

end # module
