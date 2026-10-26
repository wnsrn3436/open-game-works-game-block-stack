class_name CommonConstants
extends RefCounted
## Drawing values the shared content code uses. Gameplay values are in `game_setting`.

## Permille of a whole.
const PERMILLE: int = 1000 # unit conversion, not a tunable value
const PERMILLE_F: float = 1000.0 # unit conversion, not a tunable value
## Text color of the terms hint while an agree toggle is off (gold highlight) and once both are on (cream).
const TERMS_HINT_WAITING_COLOR: Color = Color(1.0, 0.714, 0.153, 1.0) # color of the drawing only; no rule reads it
const TERMS_HINT_DONE_COLOR: Color = Color(0.957, 0.906, 0.773, 1.0) # color of the drawing only; no rule reads it
## The block palette in the order the tower blends through it: coral, sun, mint, lilac.
const BLOCK_COLORS: PackedColorArray = [Color(1.0, 0.478, 0.349, 1.0), Color(1.0, 0.788, 0.29, 1.0), Color(0.239, 0.863, 0.592, 1.0), Color(0.608, 0.549, 1.0, 1.0)] # colors of the drawing only; no rule reads them
## Blocks from one palette color to the next.
const BLOCKS_PER_COLOR: int = 4 # blend step of the drawing only; no rule reads it
