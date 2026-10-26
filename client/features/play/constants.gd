class_name PlayConstants
extends RefCounted
## Drawing values of the play feature. Gameplay values are in `game_setting`.

## Game ms in one second, for the slide speed in units per second.
const MS_PER_SECOND: int = 1000 # unit conversion, not a tunable value
## Screen height of the top of the base slab before the tower scrolls, and the screen height the top of the sliding
## level keeps once the tower is high.
const BASE_TOP_Y: float = 820.0 # layout of the drawing only; no rule reads it
const FOCUS_TOP_Y: float = 470.0 # layout of the drawing only; no rule reads it
## The block faces are drawn at twice their size and scaled by half, so the bevel of the block art stays thin.
const FACE_SCALE: float = 2.0 # drawing scale only; no rule reads it
## Tower levels kept on screen; lower blocks go back to the pool.
const SHOWN_LEVELS: int = 40 # drawing budget only; no rule reads it
## Sky tint at the tower levels of `SKY_LEVELS`: day, dusk, night.
const SKY_TINTS: PackedColorArray = [Color(1.0, 1.0, 1.0, 1.0), Color(0.86, 0.74, 1.0, 1.0), Color(0.36, 0.4, 0.68, 1.0)] # colors of the drawing only; no rule reads them
const SKY_LEVELS: PackedInt32Array = [0, 40, 100] # blend points of the drawing only; no rule reads them
## Pointer ID of the left mouse button (`client-core` Godot `InputCore` pointer ID). A tap of that pointer is the
## release of a click that `drop` already took.
const MOUSE_POINTER_ID: int = 1000000 # engine mapping constant, not a tunable value
## Game ms the DEV bot looks ahead for the time its key takes to arrive.
const DEV_BOT_LEAD_MS: int = 50 # DEV bot timing only; no game rule reads it
## Blocks after which the DEV bot stops aiming and drops at once, so a run ends.
const DEV_BOT_TIRED_BLOCKS: int = 18 # DEV bot behavior only; no game rule reads it
## The DEV bot drops when the block is within this share of its width of the top block (a divisor).
const DEV_BOT_WINDOW_DIVISOR: int = 6 # DEV bot behavior only; no game rule reads it
## Frames a DEV command waits for a scene, a popup or the result.
const DEV_WAIT_FRAMES: int = 900 # DEV command time limit; no game rule reads it
