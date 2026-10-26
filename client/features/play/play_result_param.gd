class_name PlayResultParam
extends UIParam
## Param of the result panel: the run that ended and the two ways on.

var score: int = 0
var perfects: int = 0
var best_streak: int = 0
## Best score of the record after the run; the best before it when the run was not recorded.
var best: int = 0
## The score is above the best score before the run.
var new_best: bool = false
## The server counted the run.
var saved: bool = true
var on_again: Callable = Callable()
var on_lobby: Callable = Callable()
