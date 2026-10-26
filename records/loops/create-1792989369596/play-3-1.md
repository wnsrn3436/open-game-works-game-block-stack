## coverage

- unknown: the third perfect in a row (block growing back). Best streak reached was 2
- unknown: `Tower fell` title. The miss run ended as `New best!`, and `End run` gave `Run ended`
- unknown: the red screen flash on a miss. Only the end state was captured
- unknown: `Copy code`, `Get account deletion code`, `Withdraw`, `Terms of service` / `Privacy policy` / `Licenses` in Options, and the `View` buttons in the terms popup. None were pressed
- unknown: audio. Only the toggle words were checked
- unknown: realtime-input timing (play was in step mode, so lock windows were not measured in real time)
- unknown: whether a drop during the 150ms after a drop is ignored. No input was put in during that window
- play ms: 267436
- scenes: scene/title/title, scene/lobby/lobby, scene/play/play, scene/play/play, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

0 | scene/title/title | none | Terms popup shows `Agree to all`, two checkboxes with `View`, and a greyed `Confirm` with the hint `Agree to both items to continue` | clear; Confirm disabled until consent | none | captures/mvou8r5d5e6bf1-1792993863582.jpg
6000 | scene/title/title | tap_anchor terms_agree_all, tap_anchor terms_confirm | Lobby opened within 2s. Shows the title, `Stack your first tower`, `Best 0`, a demo tower, `Options` and large `Play` | readable, with an obvious primary action | none | captures/mvou8r5d5e6bf1-1792993872372.jpg
9000 | scene/lobby/lobby | tap_anchor lobby_play | Run started. The first block was at offset -605 after the first 50ms step and slid right at 700 units/s | the start is quick | none | captures/mvou8r5d5e6bf1-1792993878234.jpg
12000 | scene/play/play | key Space at offset -10 | The block landed, width 440→430, score 1, and the next block was at offset 640 from the right (alternating side) | trim is clear | none | captures/mvou8r5d5e6bf1-1792993885241.jpg
60000 | scene/play/play | key Space, 7 blocks | Score 11, `Perfect ×2` badge under the score, background sky darkening, tower colors shifting. 3 perfects, best streak 2 | feedback is readable; the best plate rises live (`Best 11`) during the run | none | captures/mvou8r5d5e6bf1-1792993937883.jpg
70000 | scene/play/play | key P | The `Paused` popup shows `End run` and `Resume`, and the score plate and badge dim. The popup's top edge covers the lower part of the `Perfect ×2` badge text | slight overlap with the badge | minor | captures/mvou8r5d5e6bf1-1792993948198.jpg
75000 | scene/play/play | tap_anchor pause_resume | The block continued from the same state and the run resumed correctly | none | none | captures/mvou8r5d5e6bf1-1792993948198.jpg
190000 | scene/play/play | key Space x12 | Score 29, 19 blocks, width narrowed to 262, speed 890 units/s. Perfect drops required the offset within 7, and trimmed drops came 1–25 off center. Four perfects came in the 12 blocks | difficulty rises with speed, and a 7-unit tolerance at 890 units/s (about 44 units per 50ms step) is tight | none | captures/mvou8r5d5e6bf1-1792994045261.jpg
195000 | scene/play/play | key Space with the block at offset 639 (off tower) | The block fell, the result panel opened after about 2s: `New best!`, Score 29, Best 29, Perfect drops 7, Best streak 2, `Lobby` / `Play again` | matches the guide; the tower and the last block show behind the panel | none | captures/mvou8r5d5e6bf1-1792994053730.jpg
199000 | scene/play/play | tap_anchor result_again | A new run started: Score 0, `Best 29`, hint `Click or press Space when the block is over the tower`, and the block slid in from the right | in the second run the first block comes from the right, not the left as the guide says | minor | captures/mvou8r5d5e6bf1-1792994064896.jpg
203000 | scene/play/play | key Escape, tap_anchor pause_end | `Run ended` panel: Score 0, Best 29, Perfect drops 0, Best streak 0 | consistent with the guide | none | captures/mvou8r5d5e6bf1-1792994068805.jpg
206000 | scene/play/play | tap_anchor result_lobby | Lobby shows `Runs 2 · Best streak 2` and `Best 29` | the record line updates | none | captures/mvou8r5d5e6bf1-1792994071412.jpg
210000 | scene/lobby/lobby | tap_anchor lobby_options, tap_anchor option_music, tap_anchor option_sounds, tap_anchor option_close | Options panel shows Sound, About and Account sections with the user code. After the toggles both read `Off`. Close returned to the lobby | the toggles work and the words change; the start state was not captured | none | captures/mvou8r5d5e6bf1-1792994088890.jpg

## reproduce

None. No observation is a `blocker` or `major`.
