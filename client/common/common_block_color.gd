class_name CommonBlockColor
extends RefCounted
## Color of the block at a tower level: the palette blends from one color to the next every
## `CommonConstants.BLOCKS_PER_COLOR` blocks and starts over after the last.


static func of_level(level: int) -> Color:
	var colors: PackedColorArray = CommonConstants.BLOCK_COLORS
	var step: int = CommonConstants.BLOCKS_PER_COLOR
	var count: int = colors.size()
	var index: int = UtilCore.floor_div(maxi(level, 0), step)
	var part: int = UtilCore.floor_mod(maxi(level, 0), step)
	var from: Color = colors[UtilCore.floor_mod(index, count)]
	var to: Color = colors[UtilCore.floor_mod(index + 1, count)]
	return from.lerp(to, float(part) / float(step))
