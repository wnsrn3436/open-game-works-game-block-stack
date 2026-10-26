## coverage

- unknown: the view scrolling up and the sky darkening as the tower grows (the tower had 6 blocks; no scroll seen)
- unknown: the third perfect in a row regrowing the block width (the 5 perfects in run 1 were not captured one by one; width went 440 → 425 over 6 blocks, so a trim happened)
- unknown: `Perfect ×n` for n of 2 or more on screen, and the maximum +5 bonus
- unknown: the first-run hint `Click or press Space to drop the block`, `Getting ready` text (the step mode had started before the screen was captured)
- unknown: mouse click and gamepad drop, `Esc`/gamepad pause, `Enter` on a focused button
- unknown: toggling `Music`/`Sound effects`, `Copy code`, `Get account deletion code`, `Withdraw`, and the `View`, `Terms of service`, `Privacy policy`, `Licenses` pages
- unknown: the score count-up animation on the result panel (the capture was taken after it ended)
- unknown: the result panel `Lobby` record line after a run (`Runs n · Best streak n`); the lobby was captured only before the first run and after returning, the second one not read
- play ms: 161440
- scenes: scene/title/title, scene/lobby/lobby, scene/play/play, scene/play/play, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

3 | title | none | terms popup shown on first screen | `Agree to both items to continue` hint shows; `Confirm` is greyed until agreed. Placeholder art `BUTTON` letters show behind the `Terms of service` title and behind `Confirm`, so the text is hard to read | minor | captures/mvoswof415ef25-1792991621260.jpg
8000 | title | tap_anchor terms_agree_all, tap_anchor terms_confirm | both boxes agreed with one press; confirm went to the lobby within 2.5s | no problem | none | captures/mvoswof415ef25-1792991629976.jpg
18000 | lobby | none | the lobby shows `Block Stack`, `Stack your first tower`, `Best 0`, `Options`, a demo tower and `Play`. The art is placeholder: a huge white `SKY` text behind everything, `BLOCK` text printed on every block, and the word `BUTTON` printed over `Play` | the placeholder words are bigger than the real label `Play` and `Options`, so the screen looks unfinished; the buttons still read | minor | captures/mvoswof415ef25-1792991629976.jpg
25200 | play | tap_anchor lobby_play | the run opened in about 2s; the block slid in from the left at offset -605 and moved 35 units per 50ms step at speed 700 | clear and predictable | none | captures/mvoswof415ef25-1792991636391.jpg
31772 | play | key Space at offset -10 | perfect drop: score 2, `Perfect ×1` shown, best plate went 0 → 2 at once, the next block started from the right at offset 640, speed 720 | feels good; the score and the best update immediately. The sliding block image is stretched and its `BLOCK` text is distorted and larger than the tower blocks | minor | captures/mvoswof415ef25-1792991642923.jpg
60000 | play | 5 more drops at offsets -9, -10, -7, -15, -1 | all scored; score 17 after 6 blocks, 5 perfects, best streak 4, width 440 → 425, speed 820. The offset -15 drop was outside tolerance 12 and trimmed 15 | scoring and trim match the guide | none | captures/mvoswof415ef25-1792991698561.jpg
87400 | play | none | tower of 6 blocks over a dark base; the view did not scroll yet. A ghost `BLOCK` trail of the cut piece stays faded on the right of the tower after a trim | the tail of the fall looks like a smear that lingers; the sliding block drawn on the left was cut by the `S` letter shapes of the background | minor | captures/mvoswof415ef25-1792991698561.jpg
88700 | play | key P | pause popup opened in under 1s; the block, score and background dim. `ogw step` failed with `game time is paused`, as the guide says. `Paused` title is over placeholder `BUTTON` art, `End run`, `Resume` read well | text over the placeholder art is hard to read, `Resume` is half hidden by orange `BUTTON` letters | minor | captures/mvoswof415ef25-1792991699787.jpg
95800 | play | tap_anchor pause_resume | resumed and the block kept sliding | no problem | none | none
96600 | play | key Space right after the block appeared at offset 640 | miss: the block fell tilted and mirrored (`BLOCK` text upside-down) and left the tower | the fall reads as a miss | none | captures/mvoswof415ef25-1792991707966.jpg
100000 | result | none (about 1.5s after the miss) | result panel opened with `New best!`, score 17, `Best 17`, `Perfect drops 5`, `Best streak 4`, `Lobby` left and `Play again` right | the numbers match the run. Placeholder `PANEL` and `BUTTON` letters overlap `Score`, `Perfect drops` and the title; the large score `17` sits on top of `PANEL` text | minor | captures/mvoswof415ef25-1792991711307.jpg
106000 | play | tap_anchor result_again | new run started in about 2s with score 0 and `Best 17`; no restart problem | no problem | none | captures/mvoswof415ef25-1792991720106.jpg
110000 | play | key Space, key P, tap_anchor pause_end | `End run` ended the run with score 1 and opened `Tower fell`, 0 perfect, streak 0, best 17 | correct. The title is `Tower fell` for a run ended by the player, which is the same as for a miss | minor | captures/mvoswof415ef25-1792991724394.jpg
114000 | lobby | tap_anchor result_lobby | back to the lobby in under 3s | no problem | none | captures/mvoswof415ef25-1792991727667.jpg
117000 | options | tap_anchor lobby_options | panel opened with `Sound`, `Account` (user code shown), `About` and `Close`. The `Music` and `Sound effects` labels are dark text on the dark green placeholder `BUTTON` letters and are nearly unreadable; the toggles show an orange box with no on/off word | cannot tell if sound is on or off from the screen | major | captures/mvoswof415ef25-1792991729473.jpg
120000 | options | tap_anchor option_close | closed back to the lobby; error log empty (`no error log`) | no problem | none | none

## reproduce

- Options toggles unreadable: new user → `tap_anchor terms_agree_all` → `tap_anchor terms_confirm` → wait 2.5s → `tap_anchor lobby_options` → capture; the `Music` and `Sound effects` labels overlap the placeholder art and the on/off state cannot be told
