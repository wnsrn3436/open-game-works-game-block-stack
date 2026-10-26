## coverage

- unknown: the first-run hint `Click or press Space to drop the block` and `Getting ready` (not captured; 3 s waits after `Play` went past them)
- unknown: mouse click and gamepad drop, `Music` and `Sound effects` toggles, `Copy code`, `Get account deletion code`, `Withdraw`, the three About buttons (opened Options and Close was not pressed)
- unknown: the sky darkening with height (not visible in the captures up to 11 blocks), the "grows back" effect from the third perfect in a row (best streak was 3, growth was not checked)
- unknown: a drop during the 150 ms lock after a drop
- unknown: the 'blocker' failure path with a total miss was played once (blocks 11 to the result panel) and a second run was ended with `End run` at 0 points
- play ms: 211435
- scenes: scene/title/title, scene/lobby/lobby, scene/play/play, scene/play/play, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

0 | scene/title | none | terms popup shown on first screen. Title and buttons are drawn over placeholder textures with "BUTTON" text baked in; the label overlaps it | label hard to read (e.g. `Terms of service` header and `Confirm` over the pixel text) | minor | captures/mvosx0myf9cddf-1792991645621.jpg
3000 | scene/title | tap_anchor terms_agree_all, terms_confirm | both boxes ticked, popup closed, lobby shown | works | none | captures/mvosx0myf9cddf-1792991655105.jpg
8000 | scene/lobby | none | `Play` button has "BUTTON" art behind its label, `Options` has a faded "BUTTON" fragment, the tower demo blocks all read "BLOCK", and a huge white "SKY" sits behind the lobby | looks like unreplaced placeholder art; the text on top is harder to read | minor | captures/mvosx0myf9cddf-1792991655105.jpg
31400 | scene/play | tap_anchor lobby_play, step mode | first block slid from the left at speed 700; `offset` ran from -384 down to -629, then turned back toward 0 while `dir` read 1 the whole time | `dir` value does not match the direction of the offset change (offset got more negative with dir 1 moving right, then rose with dir still 1). The block moved, so play was not blocked | minor | none
40500 | scene/play | key Space at offset -21 | block placed with width 440 -> 419, score 1, phase `waiting`, next block entered from the right (offset 640) | trim matches the offset, +1 score | none | captures/mvosx0myf9cddf-1792991672363.jpg
60000 | scene/play | key Space at offset -9 / -10 | perfect drops: score 1 -> 3 -> 6, width kept | bonus rises with streak as the guide says | none | none
140300 | scene/play | repeated Space on offset near 0 | 11 blocks, score 22, 7 perfects, best streak 3, speed rose 700 -> 920; `Perfect ×1` badge under score; "SKY" backdrop stays the same color | speed ramp is felt and readable; the sky did not visibly darken in 11 blocks; each step of 50 ms moved the game 75 ms (play ms 31476 -> 31551) | minor | captures/mvosx0myf9cddf-1792991771737.jpg
143000 | scene/play | key P | pause popup opens, game dimmed, `ogw step` fails with "game time is paused" as documented; `Paused` header, `End run` and `Resume` buttons have "BUTTON" art behind labels | works; label contrast is poor on the Resume button | minor | captures/mvosx0myf9cddf-1792991776826.jpg
147000 | scene/play | tap_anchor pause_resume | block resumed sliding (offset 455, phase sliding) | works | none | none
154000 | scene/play | key Space at offset far from 0 | block missed, Goal mark added, panels changed to include `result_panel` about 1100 ms after drop | matches the 1000 ms wait in the guide | none | none
156000 | prefab/play/result_panel | none | `New best!`, Score 22, Best 22, Perfect drops 7, Best streak 3, `Lobby` and `Play again`; "PANEL" and "BUTTON" art shows through behind `Score` and `Perfect drops` rows | numbers are readable; the "PANEL" text under the `Perfect drops` row and score looks like a leftover placeholder | minor | captures/mvosx0myf9cddf-1792991790910.jpg
160000 | scene/play | tap_anchor result_again, then Space | new run started with score 0, Best 22 and the first block low at the bottom | works. The `Best` plate shows 22 at once | none | captures/mvosx0myf9cddf-1792991798729.jpg
164000 | scene/play | key Escape, tap_anchor pause_end | `End run` ended the 0-point run and the result panel opened, the following `result_lobby` tap returned `anchor is not there or not visible` once (panel still opening) | the first tap right after End run was lost; it was not retried | minor | none
170000 | scene/lobby | tap_anchor result_lobby | lobby shows `Runs 2 · Best streak 3` and Best 22 | record line updates as the guide says | none | captures/mvosx0myf9cddf-1792991805145.jpg
176000 | scene/lobby | tap_anchor lobby_options | options panel opens with Music, Sound effects, User code `8VJW-MVN2`, Copy code, Get account deletion code, Withdraw, Terms, Privacy, Licenses, Close | all items from the guide present; the `Music` and `Sound effects` labels are covered by "BUTTON" art and are hard to read | minor | captures/mvosx0myf9cddf-1792991810221.jpg

## reproduce

(no blocker or major observations)
