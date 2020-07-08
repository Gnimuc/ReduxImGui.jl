module ReduxImGui

using Redux
using CImGui

function get_label end

include("basic/ReduxButton.jl")
using .ReduxButton
import .ReduxButton: Button, is_on, get_size
export ReduxButton

include("basic/ReduxColorButton.jl")
using .ReduxColorButton
import .ReduxColorButton: ColorButton, get_color, get_hovered_color, get_active_color
export ReduxColorButton

include("basic/ReduxCheckbox.jl")
using .ReduxCheckbox
import .ReduxCheckbox: Checkbox, is_check
export ReduxCheckbox

include("basic/ReduxRadioButton.jl")
using .ReduxRadioButton
import .ReduxRadioButton: RadioButton, is_active
export ReduxRadioButton

include("basic/ReduxArrowButton.jl")
using .ReduxArrowButton
import .ReduxArrowButton: ArrowButton
export ReduxArrowButton

include("combo/ReduxCombo.jl")
using .ReduxCombo
import .ReduxCombo: Combo
export ReduxCombo

end # module
