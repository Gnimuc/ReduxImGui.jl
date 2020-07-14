module ReduxImGui

using Redux
using CImGui

function get_label end

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

end # module
