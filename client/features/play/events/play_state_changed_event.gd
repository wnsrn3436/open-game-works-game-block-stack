class_name PlayStateChangedEvent
extends EventBase
## The run state the HUD draws changed.

## The server has not started the run yet.
var starting: bool = true
var score: int = 0
## Best score of the record before this run.
var best: int = 0
var streak: int = 0
## What the drop that made this change did; `PlayTower.Drop.NONE` for a change without a drop.
var drop: PlayTower.Drop = PlayTower.Drop.NONE
## The block grew back on this drop.
var grew: bool = false
## The drop hint shows: the first run of the user, until its first drop.
var show_hint: bool = false
