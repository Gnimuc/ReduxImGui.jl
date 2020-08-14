const IMGUI_DEMO_DRAG_INT_STATES = Dict(
    "basic_drag_int" => DragInts.State(
        "drag int",
        50,
        speed=1,
    ),
    "basic_drag_int2" => DragInts.State(
        "drag int 0..100",
        42,
        speed=1,
        range=(0, 100),
        format="%d%%",
    ),
)

const IMGUI_DEMO_DRAG_FLOAT_STATES = Dict(
    "basic_drag_float" => DragFloats.State(
        "drag float",
        1.0f0,
        speed=0.005,
    ),
    "basic_drag_small_float" => DragFloats.State(
        "drag small float",
        0.0067f0,
        speed=0.0001,
        range=(0.0f0, 0.0f0),
        format="%.06f ns",
    ),
)
