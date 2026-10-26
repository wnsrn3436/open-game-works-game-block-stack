## coverage

- unknown: Options panel (toggles, Copy code, Withdraw, etc.), pause popup (`Resume`, `End run`), `Play again` and `Lobby` buttons on the result panel, a second run, the `Run ended` and `Tower fell` titles, a partial-overlap (trim) drop, the 3rd perfect in a row (block grows back), the streak badge `Perfect ×n`, scrolling of the view and sky darkening, the first-run hint text during live play, mouse click and gamepad drop
- Only 1 block was placed and the run ended by a deliberate miss; no more than 2 drops in total
- play ms: 65418
- scenes: scene/title/title, scene/lobby/lobby, scene/play/play
- fail: 1
- restart: 0

## observations

| elapsed ms | scene | input | what happened | feeling or problem | severity | capture |
|---|---|---|---|---|---|---|
| 0 | scene/title/title | none | Terms popup shown with unchecked boxes, `Confirm` greyed out, hint `Agree to both items to continue` | Clear; Confirm disabled until both agreed | none | captures/mvou938328cf9b-1792993879760.jpg |
| 5000 | scene/title/title | tap_anchor terms_agree_all, tap_anchor terms_confirm | Popup closed and lobby opened within 2s | Works as the guide says | none | captures/mvou938328cf9b-1792993887072.jpg |
| 7000 | scene/lobby/lobby | none | Lobby shows title `Block Stack`, `Stack your first tower`, Best 0, demo tower, `Play`. The top of the `Play` button overlaps the bottom of the dark tower base slab | The button covers part of the tower; looks slightly crowded but readable | minor | captures/mvou938328cf9b-1792993887072.jpg |
| 9000 | scene/lobby/lobby | tap_anchor lobby_play | Run scene loaded; state `sliding`, offset -605, speed 700, width 440 | Start was fast after the tap | none | captures/mvou938328cf9b-1792993894979.jpg |
| 12000 | scene/play/play | step 50ms x16, then step 10ms, key Space at offset -3 | Drop was perfect: score 2 (1 block + 1 streak bonus), streak 1, phase `waiting`, next block offset 640 coming from the right at speed 710 | Scoring matches the guide; the block alternates side as written | none | captures/mvou938328cf9b-1792993901662.jpg |
| 14000 | scene/play/play | key Space right after the next block appeared (offset 639, off the tower) | Run ended: phase `fallen`, score stayed 2 | Miss behaves as the guide says | none | captures/mvou938328cf9b-1792993906522.jpg |
| 17000 | scene/play/play | wait | Result panel opened; Goal mark about 3100 play ms after the miss drop (about 2s of game time at the 1.5x play ms rate), longer than the guide's about 1000ms | Wait before the result may feel a little long; the timing is not certain because of the play ms vs game time difference | minor | captures/mvou938328cf9b-1792993909545.jpg |
| 19000 | scene/play/play | wait | Result panel shows `New best!`, Score 2, Best 2, Perfect drops 1, Best streak 1, `Lobby` and `Play again`. The `Lobby` button is darker and lower contrast than `Play again`; `Play again` text is on a dim amber | Readable; values match the run | none | captures/mvou938328cf9b-1792993912196.jpg |

## reproduce

None (no blocker or major observation).
