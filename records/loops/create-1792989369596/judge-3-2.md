# judge result — run create-1792989369596, iteration 3

A = `mvouoyk73c63d6`, B = `mvoup51j81f6a9`. No save fixtures. Both instances were played from the terms popup to the lobby, then through one full run (12 placed blocks, then a deliberate miss), the result panel and `Play again`. The play scene was played in `step` mode with 50 ms steps. Each drop was made at the step where `|offset|` ≤ speed × 0.025 (the same rule for both).

Clock note: the `play ms` that `ogw step` prints counts wall time from the instance start, while telemetry `play_at` counts game time. Moment intervals given to `ogw telemetry compare` use the `ogw step` `play ms`.

Moment intervals (from / to, in `ogw step` play ms):

| moment | A | B |
|---|---|---|
| first 30000ms | 119312–149312 | 306136–336136 |
| core action (first 3 drops) | 119312–160010 | 306136–328785 |
| first reward | 119312–151024 | 306136–313173 |
| first failure | 243955–258968 | 405215–409000 |
| restart (fail → new run sliding) | 243955–292253 | 405215–455418 |
| run 1 (whole run) | 119312–258968 | 306136–409000 |

## vs baseline

| element | winner | margin | reason | evidence |
|---|---|---|---|---|
| `game feel` | B | clear | `ogw telemetry compare` gave B the win over the core action interval: `feedback_per_input` A 5, B 7 (d 0.286), `input_latency_ms` 1 and 1. For the same drop type the two games give the same feedback (trim: Sound + Tween 3–4 + Effect; perfect: Sound + ScreenEffect + Tween 5–6). B came out ahead because its perfect window is 12 against A's 7, so the same drop timing gave B more perfect drops. | `ogw telemetry compare --from-a 119312 --to-a 160010 --from-b 306136 --to-b 328785`; raw telemetry inputs of A at 141984/150568/158818 and of B at 312809/320434/327734 |
| `tension and release` | indistinguishable | slight | No telemetry. Both games have one failure point (a full miss ends the run; a partial overlap trims the block) and show a white flash plus a `Perfect ×n` badge after each perfect drop. A's perfect window is narrower (7 against 12), while B's speed rises faster (+20 per block, 940 at block 12, against A's +10, 820 at block 12). | `ogw step --state` `perfect_tolerance` A 7 / B 12; `speed` at the miss drop A 820 / B 940; captures `mvouoyk73c63d6-1792994763127.jpg`, `mvoup51j81f6a9-1792994946735.jpg` |
| `progression` | indistinguishable | | Over the whole run 1 interval, `reward_interval_ms` was A 1002 and B 1002 (d 0). | `ogw telemetry compare --from-a 119312 --to-a 258968 --from-b 306136 --to-b 409000` |
| `one more run` | B | slight | `restart_delay_ms` was A 4053 and B 3653 (d 0.099). Both games start the next block sliding on the first 50 ms step after `Play again`. The 400 ms gap matches the 8 extra 50 ms steps the judge advanced on A's result panel. | `ogw telemetry compare` over the restart interval (and over the whole session); marks: A Fail 131614 → Restart 135667, B Fail 317795 → Restart 321448 |
| `no friction` | indistinguishable | | Over the first 30000ms interval, `idle_span_ms` was A 0 and B 0. The whole-session compare gives A the win (90924 against 283729), but B's long idle span is the time B sat in the lobby while the judge played A, so it reflects the judge, not the game. `goal_input_count` was 16 and 16. | `ogw telemetry compare --from-a 119312 --to-a 149312 --from-b 306136 --to-b 336136`; idle_spans in raw telemetry |
| `presentation` | A | slight | No telemetry. B's lobby, HUD and result panel are placeholder resources, which are not judged. Among the parts that are not placeholders, B's score in the HUD is bare text with no plate (0 layers) and B's result panel has no idle motion (PSNR between frames 1 s apart = inf). A has a 2-layer `Score` plate and a `Play again` button that pulses (button region PSNR 31.96 dB). | A captures `mvouoyk73c63d6-1792994763127.jpg`, `mvouoyk73c63d6-1792994888874.jpg`/`-1792994889990.jpg`; B captures `mvoup51j81f6a9-1792995025143.jpg`, `mvoup51j81f6a9-1792995035430.jpg`/`-1792995036559.jpg` |

## vs reference

Reference: Stack (`reference-video-1.mp4`) for the play moments, and Royal Match (`reference-video-2.mp4`) for `lobby`, `hud`, `reward popup` and `result`.

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | `game feel` | pass | Every drop gave a sound, 3–6 tweens and an effect or screen effect at 0–1 ms latency. In the video's 16000–20000 interval, each placement in Stack shows a landing, a cut piece and a ring on a perfect drop. A shows a falling cut piece on a trim and a white flash with a `Perfect ×1` badge on a perfect drop. | telemetry inputs 141984–243575; captures `mvouoyk73c63d6-1792994754531.jpg`, `-1792994763127.jpg`; ref frames 16000–20000 |
| A | `tension and release` | pass | Like Stack in the 59000–64000 interval, a miss ends the run (the block slides off the left side and spins down) and a partial overlap trims the block. The camera then pans down the whole tower before the result. A perfect drop is followed right away by a flash and a badge. | captures `mvouoyk73c63d6-1792994861626.jpg` … `-1792994863627.jpg`; ref frames 59000–64000 |
| A | `progression` | pass | The score rises on every block and the perfect bonus grows with the streak (+1, +2), with `reward_interval_ms` 1002. Stack in 17000–21000 shows +1 score per block and a gem +1 at about 22 s. | `ogw step` scores 1, 3, 4, … 19; run 1 compare |
| A | `one more run` | pass | The cause of the miss is on screen (the block falls beside the tower). The result panel opens 1050 ms (21 steps) after the miss, and `Play again` starts a sliding block on the first step. Stack in 63000–68000 shows the fall, then `BEST 82`, then a new run about 2 s later. | `ogw step` output: Goal mark at step 21; restart state at step 1 `offset -605 phase sliding` |
| A | `no friction` | pass | From the lobby, one `Play` tap gives a 500 ms scene load, and the block slides right after. `idle_span_ms` was 0 in the first 30000ms. Stack in 14000–44000 goes from the menu tap to continuous placements. | scene_loads 504 ms; first 30000ms compare |
| A | `presentation` | fail | lobby: largest plate is the `Play` button / best plate at 2 layers against 4 for the reference `Area 1` plate (frame, inset, progress bar, chest ornament); idle motion 2 (demo block, Play pulse) against 3 or more (fountain water, sparkle trail, flags); press feedback 1 against unknown. hud: `Score` plate 2 layers (plate, tab) against 3 (bar frame, `Moves` header tab, cream inset); idle motion not counted for either. reward popup: A has none (the reward is the `Perfect ×n` text badge, 0 layers) against 5 (frame, gold border, header band, inset, `Well Done!` ribbon + star-on-pillow ornament). result: 6 layers (frame, header band, 2 insets, 2 dividers) against 5; idle motion 1 (`Play again` pulse) against 1 (sparkles); press feedback 1 (button darkens) against unknown. | A captures `mvouoyk73c63d6-1792994640822-video/frame-00000..24`, `-1792994763127.jpg`, `-1792994871092.jpg`, `-1792994901571.jpg`; ref frames 132000–138000, 100000–106000, 126000–130500, 38000–45500 |
| B | `game feel` | pass | Every drop gave a sound, 3–6 tweens and an effect or screen effect at 1 ms latency. A perfect drop also shows a large flash on the landed block and a `Perfect ×n` badge, at the level of the per-placement feedback in Stack's 16000–20000 interval. | telemetry inputs 312809–404838; captures `mvoup51j81f6a9-1792994931810.jpg` … `-1792994946735.jpg` |
| B | `tension and release` | pass | A miss ends the run (the block spins off the left side) and a partial overlap trims the block. A perfect drop is followed right away by a flash and a badge. | captures `mvoup51j81f6a9-1792995025143.jpg` … `-1792995027360.jpg` |
| B | `progression` | pass | The score rises on every block and the perfect bonus grows up to +4, with `reward_interval_ms` 1002. | `ogw step` scores 2, 5, 9, 14, … 29 |
| B | `one more run` | pass | The cause of the miss is visible, the result panel opens after 21 steps, and `Play again` starts a sliding block on the first step. | `ogw step` output for B at 405886–409000 and 454558–455418 |
| B | `no friction` | pass | The lobby `Play` tap gives a 500 ms scene load, and `idle_span_ms` was 0 in the first 30000ms. | scene_loads 500 ms; first 30000ms compare |
| B | `presentation` | fail | Placeholder resources (`BUTTON`, `BLOCK`, `PANEL`, `SKY`, `BEST`) are not judged. Not placeholders: hud score is bare text, 0 layers against 3; reward popup is none (0 layers) against 5; result panel idle motion 0 (frames 1 s apart identical, PSNR inf) against 1 (sparkles); lobby idle motion 2 (demo block, Play pulse) against 3 or more; press feedback 1 (button darkens) against unknown. | B captures `mvoup51j81f6a9-1792994643570-video`, `-1792994925897.jpg`, `-1792995035430.jpg`, `-1792995036559.jpg`, `-1792995073302.jpg` |

## moments

- `B` is better at first 30000ms. Reason: `feedback_per_input` was 7 against 2 in the window. B's first drops were perfect (window 12) while A's first drop at offset -10 was a trim (window 7). `idle_span_ms` was 0 for both.
- `B` is better at core action. Reason: `feedback_per_input` was 7 against 5 over the first 3 drops. With the same timing rule, B scored 9 after 3 drops (3 perfects) and A scored 4 (1 perfect).
- `B` is better at first reward. Reason: B's first reward mark came on drop 1 (perfect at offset -10) and A's came on drop 2 (offset 0). Telemetry `game feel` in this window was A 6 against B 1, because B's window held only one drop.
- Indistinguishable at first failure. Reason: both drops at offset -639 slid off the left side and spun down, both result panels opened at step 21 (1050 ms), and `feedback_per_input` was 5 and 5.
- `B` is better at restart. Reason: `restart_delay_ms` was 3653 against 4053. Both start a sliding block on the first step after `Play again`, and the 400 ms gap is the judge's 8 extra steps on A.
- `A` is better at lobby. Reason: A shows drawn clouds, a crown best plate and a `Play` button with a bevel. B's non-placeholder elements are text only, and both have 2 idle motions.
- `A` is better at hud. Reason: A's score sits on a 2-layer plate with a `Score` tab, and B's score is bare text.
- Indistinguishable at reward popup. Reason: neither game has a reward popup. Both show a `Perfect ×n` text badge under the score.
- `A` is better at result. Reason: A's `Play again` pulses while idle (PSNR 31.96 dB over 1 s) and B's result panel does not change (PSNR inf). Both have the same layout: header band, score inset, a stats inset with 2 dividers, and `Lobby` / `Play again`.

## loser better

- B (lost `presentation`): B's perfect window is 12 against A's 7, so with the same timing B got 9 perfect drops in 12 against A's 5, and the `Perfect ×n` streak reached 4 against 2. B's speed ramp (+20 per block) also raises the pressure faster within a run.
- A (lost `game feel` and `one more run`): A has final art on every screen (clouds, a sky that changes color with height, a crown icon, a beveled button), a pulsing `Play again` on the result panel, and a tween on button release (`mouse_up` Tween 1 against B's none). A also shows the drop hint for the first 3 runs instead of only the first.

## strengths

- Both games respond to every drop within 0–1 ms with a sound plus 3–6 tweens and an effect. A trim drops the cut piece and a perfect drop flashes the block (raw telemetry inputs).
- The cause of failure is on screen in both: the missed block falls beside the tower and spins, then the camera pans down the tower before the result panel (A 1792994861626–863627, B 1792995025143–027360).
- `Play again` starts a new sliding block on the first 50 ms step in both games, with no loading screen in between (state `offset -605 phase sliding` at step 1).
- A's result panel shows `New best!`, the score, `Best`, `Perfect drops` and `Best streak` on a 6-layer panel (frame, header band, 2 insets, 2 dividers), and its `Play again` pulses while idle (`mouse_down` darkens it).

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | reward popup | There is no reward popup. A perfect drop or a new best shows only the `Perfect ×n` text badge or the `New best!` band on the result panel. | `presentation` count: 0 layers against 5 for the Royal Match `Well Done!` popup (frame, gold border, header band, inset, ribbon + star ornament) | major | `mvouoyk73c63d6-1792994763127.jpg`; ref 126000–130500 |
| A | lobby | The largest plate (best plate / `Play` button) has 2 layers, and the lobby has 2 idle motions. | Reference lobby: `Area 1` plate with 4 layers and 3 or more idle motions (fountain, sparkle trail, flags) | major | `mvouoyk73c63d6-1792994640822-video` frames 0/8/16/24; ref 132000–138000 |
| A | hud | The `Score` plate has 2 layers (plate, tab), and the best plate is a single rounded box with a crown. | Reference HUD: top bar frame, `Moves` header tab and cream inset (3 layers) | major | `mvouoyk73c63d6-1792994763127.jpg`; ref 100000–106000 |
| A | play | The tower blocks are flat single-color rounded rectangles, and the base slab is a plain dark box. | Reference Stack blocks carry a carved pattern and shading, with particle dots in the sky | minor | `mvouoyk73c63d6-1792994856059.jpg`; ref 14000–44000 |
| B | hud | The score is bare text with no plate. | Not a placeholder; 0 layers against 3 in the reference HUD | major | `mvoup51j81f6a9-1792994925897.jpg`; ref 100000–106000 |
| B | reward popup | There is no reward popup, only the `Perfect ×n` text badge. | 0 layers against 5 | major | `mvoup51j81f6a9-1792994946735.jpg`; ref 126000–130500 |
| B | result | Nothing moves while the result panel is idle. | Frames 1 s apart are identical (PSNR inf), against 1 idle motion (sparkles) in the reference result | major | `mvoup51j81f6a9-1792995035430.jpg` / `-1792995036559.jpg`; ref 38000–45500 |
| B | lobby | 2 idle motions (demo block, Play pulse). | Against 3 or more in the reference lobby | major | `mvoup51j81f6a9-1792994643570-video`; ref 132000–138000 |
