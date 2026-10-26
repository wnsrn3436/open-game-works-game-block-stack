## coverage

- unknown: the third perfect in a row (width growing back), the streak bonus above +1, scrolling of the view and sky darkening as the tower grows (only reached 2 blocks), block speed at higher block counts
- unknown: Options toggles (`option_music`, `option_sounds`), `Copy code`, `Get account deletion code`, `Withdraw`, `Terms of service` / `Privacy policy` / `Licenses` views, the `Tower fell` heading (the miss run showed `New best!`)
- unknown: the `View` buttons on the terms popup, the gamepad and mouse click drops, `Esc` and gamepad pause, `Enter` on a focused button
- unknown: `Getting ready` text was not seen (the capture came after it)
- play ms: 123984
- scenes: scene/title/title, scene/lobby/lobby, scene/play/play, scene/play/play, scene/lobby/lobby
- fail: 2
- restart: 1

## observations

0 | scene/title/title | none | Terms popup shown with Agree to all, two checkboxes with View, Confirm greyed with `Agree to both items to continue` | readable, Confirm clearly disabled | none | captures/mvou8x24b8abd1-1792993874525.jpg
5000 | scene/title/title | tap_anchor terms_agree_all, tap_anchor terms_confirm | Both consents turned on, Confirm accepted, lobby opened within about 2s | smooth | none | captures/mvou8x24b8abd1-1792993882697.jpg
18000 | scene/lobby/lobby | none | Lobby shows title, `Stack your first tower`, Best 0, demo tower with a purple block overhanging right, large Play | Play button overlaps the bottom of the demo tower slightly, but is clear | none | captures/mvou8x24b8abd1-1792993882697.jpg
25000 | scene/lobby/lobby | tap_anchor lobby_options | Option panel opened with Music On, Sound effects On, user code, Copy code, Get account deletion code, Withdraw, Terms, Privacy, Licenses, Close | complete and legible | none | captures/mvou8x24b8abd1-1792993890991.jpg
28000 | scene/lobby/lobby | tap_anchor option_close | Panel closed and returned to the lobby | none | none |
36720 | scene/play/play | tap_anchor lobby_play | Run started within the 3s wait, first block slid from the left at offset -605, speed 700, width 440 | smooth entry | none | captures/mvou8x24b8abd1-1792993899971.jpg
46500 | scene/play/play | key Space at offset -10 | Block landed trimmed: width 440 to 430, score 1 (+1, no perfect, since |-10| is over tolerance 7), speed 700 to 710, next block came from the right at 640 | feedback matches the guide | none | captures/mvou8x24b8abd1-1792993910482.jpg
56281 | scene/play/play | key Space at offset 0 | Perfect drop: score 1 to 3 (+1 and +1 streak bonus), `Perfect ×1` badge under the score, speed 720, block stayed 430 wide, Best on the plate updated live to 3 | clear reward feedback | none | captures/mvou8x24b8abd1-1792993919532.jpg
64450 | scene/play/play | key Space at offset -639 (block still off the tower) | Phase went to `fallen` on the next step, streak reset to 0, score kept at 3 | miss rule as written | none | captures/mvou8x24b8abd1-1792993928414.jpg
69792 | scene/play/play | none (wait about 5s after the miss) | Result panel `New best!` with Score 3, Best 3, Perfect drops 1, Best streak 1, Lobby (left) and Play again (right, highlighted) | matches the guide, I did not catch the score count-up in step mode | none | captures/mvou8x24b8abd1-1792993934700.jpg
80000 | scene/play/play | tap_anchor result_again | New run began; hint `Click or press Space when the block is over the tower` showed at the bottom, a brown block waiting at the left, Score 0 | hint clear | none | captures/mvou8x24b8abd1-1792993944881.jpg
84000 | scene/play/play | key P | Pause popup `Paused` with End run and Resume; score plate and background dimmed, the block held | clear | none | captures/mvou8x24b8abd1-1792993946505.jpg
86000 | scene/play/play | tap_anchor pause_resume, key P, tap_anchor pause_end | Resume closed the popup, P reopened it, End run opened the result panel `Run ended` with Score 0, Best 3, Perfect drops 0 | works in both directions, no error log | none | captures/mvou8x24b8abd1-1792993951822.jpg
92000 | scene/lobby/lobby | tap_anchor result_lobby | Lobby shown with `Runs 2 · Best streak 1`, Best 3; the anchor tap worked right after the panel opened | record line updated correctly | none | captures/mvou8x24b8abd1-1792993955465.jpg
92500 | all | none | `ogw log` empty; telemetry: 2 fails, 1 restart, scenes title, lobby, play, play, lobby | no errors | none |

## reproduce

None. No observation was rated `blocker` or `major`.
