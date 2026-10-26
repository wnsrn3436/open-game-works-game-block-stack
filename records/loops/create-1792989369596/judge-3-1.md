# judge result — run create-1792989369596, iteration 3

- A: `mvou8frvd8c2e7`, B: `mvou8m15b7cf08` (which one is the baseline was not told)
- reference: Stack (`reference-video-1.mp4`), presentation: Royal Match (`reference-video-2.mp4`)
- fixtures: none
- Both instances were played the same way: new user terms → lobby → one run of 10 drops with the same target list (offset 0 ×4, offset 20 ×1, offset 0 ×5, dropping at the 50ms step whose `offset` was closest to the target) → a deliberate miss → result panel → `Play again` → pause popup
- Capture paths are relative to `/private/var/folders/dv/xpbhgnp93_16v1jkkjkvvrrw0000gn/T/ogw-judge-5jzj4J/`. The number in each file name is the unix ms of the capture

## vs baseline

| element | winner | margin | reason | evidence |
|---|---|---|---|---|
| `game feel` | B | clear | `ogw telemetry compare` (whole session) gives B a clear win: `feedback_per_input` A 5 vs B 6, `input_latency_ms` 1 vs 1. | `ogw telemetry compare mvou8frvd8c2e7 mvou8m15b7cf08` (whole session); core interval (A play ms 196685–269000, B 283213–350500): `feedback_per_input` A 6, B 7, winner B slight |
| `tension and release` | B | slight | No telemetry, so this is LLM opinion. With the same drop timing, B's perfect window is `perfect_tolerance` 12 against A's 7, so B gave 7 perfects to A's 5 and a best streak of 4 to A's 2. B's speed also rises 20 per block (880 at block 10) against A's 10 (790), so the failure pressure builds faster. | `--state` output: A block 2 dropped at offset 9 → trimmed (width 440→431); B block 1 dropped at offset −9 and block 2 at offset −10 → both perfect; A result `Perfect drops 5 / Best streak 2` (`captures/mvou8frvd8c2e7-1792994258983.jpg`, play ms 418058); B result `Perfect drops 7 / Best streak 4` (`captures/mvou8m15b7cf08-1792994263754.jpg`, play ms 416591) |
| `progression` | indistinguishable | | Telemetry `reward_interval_ms` is A 1052 vs B 1002 (d 0.048), and compare reports indistinguishable. | `ogw telemetry compare` (whole session and core interval) |
| `one more run` | indistinguishable | | Telemetry `restart_delay_ms` is A 3203 vs B 3203 (d 0). | `ogw telemetry compare` (whole session) |
| `no friction` | indistinguishable | | Telemetry `idle_span_ms` is A 120466 vs B 123999 (d 0.028), `goal_input_count` 14 vs 14. | `ogw telemetry compare` (whole session) |
| `presentation` | A | slight | No telemetry, so this is LLM opinion. Leaving out B's placeholder art: A's score sits on a plate with a `Score` tab (2 layers) while B's score is a bare number (0 layers), and A's result panel has 2 idle motions (crown wiggle, `Play again` pulse) while B's has 0. | A HUD `captures/mvou8frvd8c2e7-1792994012388.jpg` (play ms 171463); B HUD `captures/mvou8m15b7cf08-1792994012762.jpg` (play ms 165599); result idle 2000ms: A `captures/mvou8frvd8c2e7-1792994254584.jpg`→`-1792994258983.jpg`, B `captures/mvou8m15b7cf08-1792994259363.jpg`→`-1792994263754.jpg` |

## vs reference

Presentation counts per screen (game vs the frame of that moment in `reference-video-2.mp4`):

| screen | A panel layers / idle motion / press | B panel layers / idle motion / press | reference panel layers / idle motion / press |
|---|---|---|---|
| lobby | 2 (Play button fill + bottom lip; the Best plate is 1) / 2 (demo top block slides, Play button pulses) / 1 | placeholder art (not looked at) / 2 (demo top block slides, Play button pulses) / 1 | 3 (`Level 3` button: gold frame + green fill + top highlight; bottom nav: band + gold top border + selected-tab plate) / ≥3 (fountain water, waving flags, sparkle particles) / not shown in 132000–140000 |
| hud | 2 (score plate + cream `Score` tab) / 1 (sliding block) / – | 0 (score is bare text; the Best plate is placeholder art) / 1 (sliding block) / – | 4 (blue band, gold trim line, cream insets for Target/Moves, header tabs `Target`/`Moves`) / ≥1 (drifting clouds) / – |
| reward popup | 0 (no popup: the reward is a `Perfect ×n` text badge under the score and a white flash on the block) / 0 / – | 0 (same `Perfect ×n` text badge and flash) / 0 / – | 6 (gold outer frame, blue header band `Level 2`, inner inset with gold border, `Well Done!` title ornament, close button, star-on-cushion ornament) / 2 (sparkles, star motion) / – |
| result | 6 (outer frame + inner border line, `New best!` header band, score inset, stats inset, row dividers) / 2 (crown icon wiggles, `Play again` pulses) / 1 (`Play again` darkens when held) | placeholder art (not looked at) / 0 / 1 (`Play again` darkens when held) | 6 (same `Well Done!` popup as the reward popup, `Level 1`) / 2 (star flies in and settles, sparkles) / – |

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | `game feel` | pass | `input_latency_ms` is 1 and `feedback_per_input` is 5. Each drop lands the block at once, the cut piece falls, a perfect flashes the block white and shows `Perfect ×n`, and the score updates. The reference core action (16000–20000) shows a block landing with a placed-block highlight. Sound could not be heard in either. | `ogw telemetry compare` whole session; `captures/mvou8frvd8c2e7-1792994043312.jpg` (perfect, play ms ~201760), `-1792994058698.jpg` (trim with falling piece, play ms ~217170); `ogw frames reference-video-1.mp4 --from 16000 --to 20000` |
| A | `tension and release` | pass | Every drop can fail (a miss ends the run), and a perfect is followed at once by a white flash on the block, the `Perfect ×n` badge and a streak bonus of +1…+5. The reference at 59000–64000 shows the same failure point on every drop and a ring on each perfect. | `--state`: score 0→2 on the first perfect, 2→5 on the second; `captures/mvou8frvd8c2e7-1792994051038.jpg` (`Perfect ×2`, score 5) |
| A | `progression` | pass | `reward_interval_ms` is 1052. The reference first reward (17000–21000) shows score +1 and a perfect ring about once per second. | `ogw telemetry compare` whole session; `ogw frames reference-video-1.mp4 --from 17000 --to 21000` |
| A | `one more run` | pass | `restart_delay_ms` is 3203. On a miss the block tilts and falls past the tower's left edge with a red flash, so the cause can be seen. The reference miss at about 62000 reaches run 1 of the next game by about 65000 (≈3000ms). | `captures/mvou8frvd8c2e7-1792994221958.jpg`… (play ms 381033–383735: falling block, then result panel); `ogw frames reference-video-1.mp4 --from 63000 --to 68000` |
| A | `no friction` | unknown | `goal_input_count` is 14, but `idle_span_ms` (120466) holds the time the judge spent reading reference frames while the game waited in the lobby. The telemetry cannot be split from the judge's pauses, so this could not be checked against the reference 14000–44000. | `ogw telemetry compare` whole session and `--from-a 0 --to-a 30000` |
| A | `presentation` | fail | Lobby panel layers are 2 against the reference's 3, and lobby idle motion is 2 against ≥3. HUD panel layers are 2 against 4. There is no reward popup (0 layers, 0 idle motion against 6 and 2). The result screen is level with the reference (6/6 layers, 2/2 idle motion). | lobby `captures/mvou8frvd8c2e7-1792993876343.jpg`, idle video `captures/mvou8frvd8c2e7-1792993886140-video`; HUD `captures/mvou8frvd8c2e7-1792994012388.jpg`; result `captures/mvou8frvd8c2e7-1792994254584.jpg`; reference frames at 132000–138000, 100000–106000, 126000–130500, 38000–44750 |
| B | `game feel` | pass | `input_latency_ms` is 1 and `feedback_per_input` is 6. A drop lands at once, the cut piece falls, and a perfect shows a white flash, a widening ring over the block and `Perfect ×n`. | `ogw telemetry compare` whole session; `captures/mvou8m15b7cf08-1792994135839.jpg` (perfect ring), `-1792994164822.jpg` (trim) |
| B | `tension and release` | pass | Every drop can fail, and a perfect is followed at once by the flash, the ring and the streak bonus. | `--state`: score 9→14 on the 4th perfect in a row; `captures/mvou8m15b7cf08-1792994157631.jpg` (`Perfect ×4`) |
| B | `progression` | pass | `reward_interval_ms` is 1002, level with the roughly 1s reward rhythm of the reference 17000–21000. | `ogw telemetry compare` whole session |
| B | `one more run` | pass | `restart_delay_ms` is 3203, and the missed block tilts off the tower's left edge with a red flash before the result panel. | `captures/mvou8m15b7cf08-1792994225983.jpg`… (play ms 378820–381525) |
| B | `no friction` | unknown | `goal_input_count` is 14, but `idle_span_ms` (123999) holds the judge's pause in the lobby, so it cannot be compared with the reference 14000–44000. | `ogw telemetry compare` whole session and `--from-b 0 --to-b 30000` |
| B | `presentation` | fail | Panel art is placeholder and is not looked at. Lobby idle motion is 2 against the reference's ≥3. Result idle motion is 0 against 2. The HUD score has no plate (0 layers against 4). The reward popup is missing (0 against 6). | lobby idle video `captures/mvou8m15b7cf08-1792993888407-video`; result idle `captures/mvou8m15b7cf08-1792994259363.jpg`→`-1792994263754.jpg`; HUD `captures/mvou8m15b7cf08-1792994012762.jpg` |

## moments

- `B` is better at core action. Reason: in the core interval `feedback_per_input` is A 6 vs B 7 (telemetry: B, slight), and B's perfect window is 12 against A's 7.
- Indistinguishable at first reward. Reason: `reward_interval_ms` is A 1052 vs B 1002 (d 0.048), and both show a white flash plus a `Perfect ×1` badge on the first perfect.
- Indistinguishable at first failure. Reason: `feedback_per_input` is 5 vs 5 in the failure interval. In both, the missed block tilts off the left edge with a red flash, and the result panel opens about 950ms of game time later (Goal mark at step 19).
- `A` is better at restart. Reason: `feedback_per_input` in the restart interval is A 1 vs B 0 (telemetry: A, decisive). A's result panel has 2 idle motions against B's 0. `restart_delay_ms` is equal (3203).
- `A` is better at first 30000ms. Reason: telemetry gives A a decisive win on `idle_span_ms` (A 0 vs B 123999 in 0–30000ms). The B span is the lobby wait while the judge was reading reference frames; both instances sat idle for the same wall time. `goal_input_count` is 14 vs 14.
- Indistinguishable at lobby. Reason: same layout, 2 idle motions each (demo top block slides, Play button pulses), press feedback 1 each. B's panel art is placeholder and is not counted.
- `A` is better at hud. Reason: A's score is on a navy plate with a cream `Score` tab (2 layers); B's score is a bare number (0 layers).
- Indistinguishable at reward popup. Reason: neither game has a reward popup. Both show a `Perfect ×n` text badge under the score and a flash on the block.
- `A` is better at result. Reason: A's result panel has 2 idle motions (crown wiggle, `Play again` pulse) against B's 0. Both have the same rows (Score count-up, Best, Perfect drops, Best streak) and the same `Lobby` / `Play again` buttons.

## loser better

- `game feel` (B won): A's slower speed ramp (+10 per block against B's +20) left more time to line up each drop at the same block count. A's speed at block 10 was 790 against B's 880.
- `tension and release` (B won): A's narrower perfect window (7) makes a perfect a stricter test, so a `Perfect ×n` streak in A needs more precise timing than in B (12).
- `presentation` (A won): B's perfect drop adds a widening ring over the landed block on top of the white flash. A's perfect shows only the white flash on the block (`captures/mvou8m15b7cf08-1792994135839.jpg` vs `captures/mvou8frvd8c2e7-1792994043312.jpg`).

## strengths

- In both games, input reaches the block in 1ms (`input_latency_ms` 1), and every drop gives a visible result: the block lands, the overhang falls away as a separate piece, the tower scrolls up and the sky color shifts as the tower grows.
- In both games the cause of failure is on screen: the missed block tilts and falls past the tower's edge with a red flash before the result panel. `restart_delay_ms` is 3203, about the same as the reference (miss at ≈62000 → next run at ≈65000).
- In A, the terms popup, lobby, HUD, pause popup and result panel all use one drawn style: navy plates with a cream double border and a gold header band (`captures/mvou8frvd8c2e7-1792993862425.jpg`, `-1792994376938.jpg`, `-1792994254584.jpg`).
- In both games the result panel shows the run's facts with the score counting up: `New best!`, Best, Perfect drops and Best streak.

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | reward popup | There is no reward popup. A perfect or a new best is shown only as a `Perfect ×n` text badge under the score (0 panel layers, 0 idle motion). | The reference reward popup has 6 panel layers and 2 idle motions. | major | `captures/mvou8frvd8c2e7-1792994051038.jpg`; reference 126000–130500 |
| A | hud | The score plate has 2 drawn layers (plate + `Score` tab). | The reference HUD has 4 (band, gold trim, insets, header tabs). | major | `captures/mvou8frvd8c2e7-1792994012388.jpg`; reference 100000–106000 |
| A | lobby | The largest plate (Play button) has 2 layers and there are 2 idle motions. | The reference lobby has 3 layers and ≥3 idle motions (fountain, flags, sparkles). | major | `captures/mvou8frvd8c2e7-1792993876343.jpg`, `captures/mvou8frvd8c2e7-1792993886140-video`; reference 132000–138000 |
| B | result | The result panel has 0 idle motion over 2000ms with no input. | The reference result popup has 2 (star, sparkles). | major | `captures/mvou8m15b7cf08-1792994259363.jpg`→`-1792994263754.jpg`; reference 38000–44750 |
| B | hud | The score is bare text with no plate (0 layers). | The reference HUD has 4 layers. | major | `captures/mvou8m15b7cf08-1792994012762.jpg`; reference 100000–106000 |
| B | reward popup | There is no reward popup, only a `Perfect ×n` text badge (0 layers, 0 idle motion). | The reference has 6 layers and 2 idle motions. | major | `captures/mvou8m15b7cf08-1792994157631.jpg`; reference 126000–130500 |
| B | lobby | There are 2 idle motions. | The reference lobby has ≥3. | major | `captures/mvou8m15b7cf08-1792993888407-video`; reference 132000–138000 |
| B | play state | `content.play.dir` reads 1 while `offset` falls (625→520 over 3 steps), which disagrees with the play guide ("1 moving right"). | The play state reports the wrong direction for automation. | minor | `ogw step mvou8m15b7cf08 50 --state` steps 37–40 (play ms 153946–154171) |
