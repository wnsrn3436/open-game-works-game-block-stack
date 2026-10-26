## coverage

- unknown: trimmed (non-perfect) drops and the width shrink; the block growing back after the 3rd perfect (all drops were within 2 units, so width stayed 440); the view scrolling and sky darkening past 9 blocks (not checked in captures); Music / Sound effects toggles, Copy code, deletion code, Withdraw, Terms/Privacy/Licenses views; gamepad and mouse click drops (only `Space` used); fail-then-`Lobby` → `Play` path from a fresh run beyond one pass
- Played: terms → lobby → run (9 perfect drops, score 44) → pause/resume → miss → result (`New best!`) → Play again → immediate drop = miss (`Tower fell`, 0) → Lobby → Options
- play ms: 202756
- scenes: scene/title/title, scene/lobby/lobby, scene/play/play, scene/play/play, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

0 | scene/title/title | tap_anchor terms_agree_all | Terms popup shows. A pixel "BUTTON" placeholder image sits behind `Terms of service` and the `Agree to all` / `Confirm` rows | Placeholder art text is visible behind the labels, so the labels are cluttered | minor | captures/mvoswtk90867df-1792991630504.jpg
8000 | scene/lobby/lobby | none | Lobby: `Block Stack`, `Stack your first tower`, Best 0. The tower is drawn as `BLOCK` labelled blocks, the backdrop as a huge `SKY` block-letter image, `Play` sits on a `BUTTON` image | Placeholder sprites with their own words are shown as final art; `Play` is dark text over orange `BUTTON` letters and is hard to read | major | captures/mvoswtk90867df-1792991639008.jpg
26162 | scene/play/play | tap_anchor lobby_play | Block slides in from the left, offset -605, speed 700, phase sliding. Loading took less than 3s | Run starts without trouble | none | -
35000 | scene/play/play | key Space at offset -10 | Drop within tolerance 12: score 2, streak 1, width stays 440, phase waiting | Perfect drop is clear, score adds +1 and +1 | none | -
90000 | scene/play/play | key Space x8 at offsets of ±2 | Scores 5, 9, 14, 20, 26, 32, 38; speed rises 20 per block (720→860) | Scoring matches the controls text (+1 plus streak, capped at +5) | none | -
133042 | scene/play/play | step | Score 44, `Perfect ×9` badge under it, best 44 at top right. Tower of `BLOCK` blocks with a faded `BLOCK` on the sliding block over the `SKY` letters | The HUD is clear. The `SKY` background letters are big and sit behind the sliding block and cross the badge | minor | captures/mvoswtk90867df-1792991753276.jpg
134000 | scene/play/play | key P | Pause popup `Paused` with `End run` and `Resume`. `ogw step` failed with "game time is paused" as the guide says | Pause works. Both buttons sit on `BUTTON` placeholder images; `Resume` is dark text on orange letters and hard to read | minor | captures/mvoswtk90867df-1792991758592.jpg
140000 | scene/play/play | tap_anchor pause_resume | Popup closes, game time resumes, the block continues at offset 640 | Resume works | none | -
145000 | scene/play/play | key Space at offset 639 | Block falls tilted off to the right. The tower stays at 44. About 700 ms later the Goal mark and the result panel open | The miss reads clearly. I did not look at the red flash in a capture | none | captures/mvoswtk90867df-1792991765617.jpg
149339 | scene/play/play | wait | Result panel `New best!` with Score 44, Best 44, Perfect drops 9, Best streak 9, `Lobby`, `Play again`. A `PANEL` placeholder image shows through behind the score and the `Perfect drops` row | The `PANEL` letters run through the `Perfect drops` text and the score number | minor | captures/mvoswtk90867df-1792991774159.jpg
152000 | scene/play/play | tap_anchor result_again then key Space about 3s later | A new run starts. A Space at the start of the run (block still far off the tower) ends it as `Tower fell`, score 0, best stays 44 | Dropping too early is a miss, as the rules say. A first-time player has no warning that the first drop must wait for the block to reach the tower | minor | captures/mvoswtk90867df-1792991783647.jpg
158000 | scene/lobby/lobby | tap_anchor result_lobby, tap_anchor lobby_options | Options panel: Sound (`Music`, `Sound effects`), Account (user code, `Copy code`, `Get account deletion code`, `Withdraw`), About, `Close` | `Music` and `Sound effects` labels are dark text on dark, partly covered by `BUTTON` placeholder pieces, and nearly unreadable | major | captures/mvoswtk90867df-1792991793813.jpg
- | all | ogw log | `no error log` | No errors in the log | none | -

## reproduce

- Lobby art (major): finish terms (`tap_anchor terms_agree_all`, `tap_anchor terms_confirm`), wait for the lobby, capture. `BLOCK`, `SKY` and `BUTTON` placeholder images show as the tower, backdrop and Play button
- Options labels (major): from the lobby, `tap_anchor lobby_options`, capture. `Music` and `Sound effects` are hard to read
