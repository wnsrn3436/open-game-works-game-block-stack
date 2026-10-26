class_name LobbyConstants
extends RefCounted
## Drawing values of the lobby feature.

## Joins the two groups of 4 characters of a user code (`client-content` `## UI composition`).
const CODE_JOINER: String = "-" # display format of a user code, not a tunable value
## Frames a DEV command waits for a panel.
const DEV_WAIT_FRAMES: int = 600 # DEV command time limit; no game rule reads it
