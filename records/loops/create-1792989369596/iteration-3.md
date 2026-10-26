## commit

- instance: f32c4e5556ab888bd7be3e19ba1913ae0f0fda61
- baseline: 43d406267e9646fbc21d3813c276c7a7e29440e0
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/create-1792989369596/check-3.json |
| static check | pass | records/loops/create-1792989369596/check-3.json |
| no blocker | pass | records/loops/create-1792989369596/check-3.json |
| full flow | pass | records/loops/create-1792989369596/check-3.json |
| performance | pass | records/loops/create-1792989369596/check-3.json |
| UI quality | fail | records/loops/create-1792989369596/check-3.json |
| no placeholder | pass | records/loops/create-1792989369596/check-3.json |
| row simulation | pass | records/loops/create-1792989369596/check-3.json |

## judge

### records/loops/create-1792989369596/judge-3-2.md

- kind: main
- status: done
- A: f32c4e5556ab888bd7be3e19ba1913ae0f0fda61
- B: 43d406267e9646fbc21d3813c276c7a7e29440e0
- vs baseline: worse
- vs reference: fail
- omitted moments: none

#### moments

- `B` is better at first 30000ms. Reason: `feedback_per_input` was 7 against 2 in the window. B's first drops were perfect (window 12) while A's first drop at offset -10 was a trim (window 7). `idle_span_ms` was 0 for both.
- `B` is better at core action. Reason: `feedback_per_input` was 7 against 5 over the first 3 drops. With the same timing rule, B scored 9 after 3 drops (3 perfects) and A scored 4 (1 perfect).
- `B` is better at first reward. Reason: B's first reward mark came on drop 1 (perfect at offset -10) and A's came on drop 2 (offset 0). Telemetry `game feel` in this window was A 6 against B 1, because B's window held only one drop.
- Indistinguishable at first failure. Reason: both drops at offset -639 slid off the left side and spun down, both result panels opened at step 21 (1050 ms), and `feedback_per_input` was 5 and 5.
- `B` is better at restart. Reason: `restart_delay_ms` was 3653 against 4053. Both start a sliding block on the first step after `Play again`, and the 400 ms gap is the judge's 8 extra steps on A.
- `A` is better at lobby. Reason: A shows drawn clouds, a crown best plate and a `Play` button with a bevel. B's non-placeholder elements are text only, and both have 2 idle motions.
- `A` is better at hud. Reason: A's score sits on a 2-layer plate with a `Score` tab, and B's score is bare text.
- Indistinguishable at reward popup. Reason: neither game has a reward popup. Both show a `Perfect ×n` text badge under the score.
- `A` is better at result. Reason: A's `Play again` pulses while idle (PSNR 31.96 dB over 1 s) and B's result panel does not change (PSNR inf). Both have the same layout: header band, score inset, a stats inset with 2 dividers, and `Lobby` / `Play again`.

#### loser better

- B (lost `presentation`): B's perfect window is 12 against A's 7, so with the same timing B got 9 perfect drops in 12 against A's 5, and the `Perfect ×n` streak reached 4 against 2. B's speed ramp (+20 per block) also raises the pressure faster within a run.
- A (lost `game feel` and `one more run`): A has final art on every screen (clouds, a sky that changes color with height, a crown icon, a beveled button), a pulsing `Play again` on the result panel, and a tween on button release (`mouse_up` Tween 1 against B's none). A also shows the drop hint for the first 3 runs instead of only the first.

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/create-1792989369596/play-3-1.md | 0 | 0 | 2 | 11 |
| records/loops/create-1792989369596/play-3-2.md | 0 | 0 | 0 | 14 |
| records/loops/create-1792989369596/play-3-3.md | 0 | 0 | 2 | 6 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| title-lobby-text-low-contrast | major | client content | scene/lobby/lobby | low contrast UICore/Panel/SafeAreaRoot/LobbyPanel/Record: 1.88:1 in prefab/lobby/lobby_panel (en, macbook_air_13, lobby.open_lobby, text scale 1000) | title and lobby text over the final sky art is below the contrast the UI quality check needs | records/loops/create-1792989369596/check-3.json#UI quality, records/loops/create-1792989369596/evidence/check-3/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-3/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792989369596/evidence/check-3/ui-macos/0006-en-macbook_air_13-title.open_title-1000.png, records/loops/create-1792989369596/evidence/check-3/ui-macos/0006-en-macbook_air_13-title.open_title-1000.json, records/loops/create-1792989369596/evidence/check-3/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-3/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.json, records/loops/create-1792989369596/evidence/check-3/ui-macos/0012-en-display_16_9-title.open_title-1000.png, records/loops/create-1792989369596/evidence/check-3/ui-macos/0012-en-display_16_9-title.open_title-1000.json | check | open |
| presentation-layers-below-reference | major | client content | vs reference: presentation | lobby: largest plate is the `Play` button / best plate at 2 layers against 4 for the reference `Area 1` plate (frame, inset, progress bar, chest ornament); idle motion 2 (demo block, Play pulse) against 3 or more (fountain water, sparkle trail, flags); press feedback 1 against unknown. hud: `Score` plate 2 layers (plate, tab) against 3 (bar frame, `Moves` header tab, cream inset); idle motion not counted for either. reward popup: A has none (the reward is the `Perfect ×n` text badge, 0 layers) against 5 (frame, gold border, header band, inset, `Well Done!` ribbon + star-on-pillow ornament). result: 6 layers (frame, header band, 2 insets, 2 dividers) against 5; idle motion 1 (`Play again` pulse) against 1 (sparkles); press feedback 1 (button darkens) against unknown. | worse than the reference game, so `vs reference` is `fail` | A captures `mvouoyk73c63d6-1792994640822-video/frame-00000..24`, `-1792994763127.jpg`, `-1792994871092.jpg`, `-1792994901571.jpg`; ref frames 132000–138000, 100000–106000, 126000–130500, 38000–45500, records/loops/create-1792989369596/judge-3-2.md, `mvouoyk73c63d6-1792994640822-video` frames 0/8/16/24; ref 132000–138000, `mvouoyk73c63d6-1792994763127.jpg`; ref 100000–106000 | judge | open |
| no-reward-popup | major | design | reward popup | There is no reward popup. A perfect drop or a new best shows only the `Perfect ×n` text badge or the `New best!` band on the result panel. | `presentation` count: 0 layers against 5 for the Royal Match `Well Done!` popup (frame, gold border, header band, inset, ribbon + star ornament) | `mvouoyk73c63d6-1792994763127.jpg`; ref 126000–130500 | judge | refused (The reference reward popup shows coins flying to a counter; `brief.md` `## prohibitions` has no gems, coins, skins or unlocks, and a popup per perfect drop would stop the one-input rhythm of `## emotion`. A perfect drop stays rewarded on the run screen at the moment of the drop; `design.md` `## screens` now says so) |
| reward-interval-short | minor | data | reward_interval_ms | value 1002 out of 2000..30000 | the measured reward interval is below the design.md target range | records/loops/create-1792989369596/measure-3.json#reward_interval_ms | check | open |
| pause-popup-covers-badge | minor | client content | scene/play/play | key P → The `Paused` popup shows `End run` and `Resume`, and the score plate and badge dim. The popup's top edge covers the lower part of the `Perfect ×2` badge text | slight overlap with the badge | captures/mvou8r5d5e6bf1-1792993948198.jpg, records/loops/create-1792989369596/play-3-1.md:22 | play | open |
| lobby-play-button-overlaps-base | minor | client content | scene/lobby/lobby | none → Lobby shows title `Block Stack`, `Stack your first tower`, Best 0, demo tower, `Play`. The top of the `Play` button overlaps the bottom of the dark tower base slab | The button covers part of the tower; looks slightly crowded but readable | captures/mvou938328cf9b-1792993887072.jpg, records/loops/create-1792989369596/play-3-3.md:16 | play | open |
| result-delay-long | minor | client content | scene/play/play | wait → Result panel opened; Goal mark about 3100 play ms after the miss drop (about 2s of game time at the 1.5x play ms rate), longer than the guide's about 1000ms | Wait before the result may feel a little long; the timing is not certain because of the play ms vs game time difference | captures/mvou938328cf9b-1792993909545.jpg, records/loops/create-1792989369596/play-3-3.md:20 | play | open |
| play-guide-first-block-side | minor | client content | scene/play/play | tap_anchor result_again → A new run started: Score 0, `Best 29`, hint `Click or press Space when the block is over the tower`, and the block slid in from the right | in the second run the first block comes from the right, not the left as the guide says | captures/mvou8r5d5e6bf1-1792994064896.jpg, records/loops/create-1792989369596/play-3-1.md:26 | play | open |
| flat-tower-blocks | minor | resource | play | The tower blocks are flat single-color rounded rectangles, and the base slab is a plain dark box. | Reference Stack blocks carry a carved pattern and shading, with particle dots in the sky | `mvouoyk73c63d6-1792994856059.jpg`; ref 14000–44000 | judge | open |
| tween-preset-invalid-value | blocker | client content | step 1 | client main error log: 1792993402749	error	TweenCore	play_preset: definition check failed: change 0 of step 0 has a value that is not finite or out of range	res://core/tween_core/tween_core.gd:436 _checked\nres://core/tween_core/tween_core.gd:200 play_preset\nres://features/play/play_result_panel.gd:68 on_opened\nres://core/ui_core/ui_core.gd:1421 _show_view\nres://core/ui_core/ui_core.gd:1262 _open_flow\nres://core/ui_core/ui_core.gd:1391 _make_view\nres://core/ui_core/call_waiter.gd:56 _finish\nres://core/ui_core/call_waiter.gd:30 start_load\nres://core/resource_core/resource_core.gd:210 load\nres://core/resource_core/resource_core.gd:572 _run_loading | a TweenCore preset that the client main plays fails its definition check, so the error log stops the bot playtest at step 1 | records/loops/create-1792989369596/check-2.json#no blocker, records/loops/create-1792989369596/evidence/check-2/bot-playtest/client.log, records/loops/create-1792989369596/evidence/check-2/bot-playtest/server.log, records/loops/create-1792989369596/check-2.json#full flow | check | fixed |
| flat-panels | major | client content | scene/play/play | flat panel UICore/Panel/SafeAreaRoot/Hud/ScorePlate: 86% one color in prefab/play/hud_panel (en, display_16_9, play.open_pause, text scale 1000) | the HUD score plate is mostly one flat color, which the UI quality check fails | records/loops/create-1792989369596/check-2.json#UI quality, records/loops/create-1792989369596/evidence/check-2/ui-macos/0010-en-display_16_9-play.open_pause-1000.png, records/loops/create-1792989369596/evidence/check-2/ui-macos/0010-en-display_16_9-play.open_pause-1000.json | check | fixed |
| lobby-title-options-overlap | major | client content | scene/lobby/lobby | overlap UICore/Panel/SafeAreaRoot/LobbyPanel/Top/Title UICore/Panel/SafeAreaRoot/LobbyPanel/Options in prefab/lobby/lobby_panel (en, macbook_air_13, lobby.open_lobby, text scale 1000) | the lobby title and the Options button overlap, so the UI quality check fails | records/loops/create-1792989369596/check-1.json#UI quality, records/loops/create-1792989369596/evidence/check-1/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.json | check | fixed |
| hud-text-low-contrast | major | client content | scene/play/play | low contrast UICore/Panel/SafeAreaRoot/Hud/Top/Score: 2.94:1 in prefab/play/hud_panel (en, macbook_air_13, play.open_pause, text scale 1000) | HUD text is below the contrast the UI quality check needs | records/loops/create-1792989369596/check-1.json#UI quality, records/loops/create-1792989369596/evidence/check-1/ui-macos/0004-en-macbook_air_13-play.open_pause-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0004-en-macbook_air_13-play.open_pause-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0010-en-display_16_9-play.open_pause-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0010-en-display_16_9-play.open_pause-1000.json | check | fixed |
| idle-motion-hud-result | major | client content | result panel | No element moves while no input is given for 2000 ms (idle motion 0). The reference `Well Done!` panel has 2 (sparkles, star glow) | The result screen is static where the reference keeps motion on the reward panel; this count is below the reference | `mvoswiok48da09-1792991993228.jpg` vs `mvoswiok48da09-1792991996026.jpg` (PSNR inf); ref video-2 44000/45000 ms, `mvoswiok48da09-1792992151985.jpg` vs `mvoswiok48da09-1792992154854.jpg` (top 260 px, PSNR inf); ref video-2 103000/105000 ms, captures `mvoswiok48da09-1792991642917-video` (lobby), `mvoswiok48da09-1792992151985.jpg` vs `…2154854.jpg` (HUD), `mvoswiok48da09-1792991993228.jpg` vs `…1996026.jpg` (result), `mvoswiok48da09-1792992163249.jpg` vs `…2175708.jpg` (press); ref frames video-2 at 44000/45000, 103000/105000, 126000–132000, 132000–140000, records/loops/create-1792989369596/judge-1-1.md | judge | fixed |
| option-sound-toggle-unreadable | major | client content | options | tap_anchor lobby_options → panel opened with `Sound`, `Account` (user code shown), `About` and `Close`. The `Music` and `Sound effects` labels are dark text on the dark green placeholder `BUTTON` letters and are nearly unreadable; the toggles show an orange box with no on/off word | cannot tell if sound is on or off from the screen | captures/mvoswof415ef25-1792991729473.jpg, records/loops/create-1792989369596/play-1-1.md:32, captures/mvoswtk90867df-1792991793813.jpg, records/loops/create-1792989369596/play-1-2.md:23, captures/mvosx0myf9cddf-1792991810221.jpg, records/loops/create-1792989369596/play-1-3.md:29 | play | fixed |
| goal-interval-short | minor | data | goal_interval_ms | value 11909 out of 15000..180000 | the measured goal interval is below the design.md target range | records/loops/create-1792989369596/measure-1.json#goal_interval_ms | check | fixed |
| play-dir-state-wrong | minor | client content | scene/play | tap_anchor lobby_play, step mode → first block slid from the left at speed 700; `offset` ran from -384 down to -629, then turned back toward 0 while `dir` read 1 the whole time | `dir` value does not match the direction of the offset change (offset got more negative with dir 1 moving right, then rose with dir still 1). The block moved, so play was not blocked | records/loops/create-1792989369596/play-1-3.md:18, step log, play ms 97869–98094 | play | fixed |
| panel-edge-line-fragments | minor | client content | terms, result and pause panels | Short white line fragments sit at the panel edges, not part of any drawn resource: a vertical stroke at the left edge, a dot or stroke at the right, and a dashed line under the score inset | They look like a partly drawn outline made in code, laid over the panels | `mvoswiok48da09-1792991618919.jpg` (x≈500, y 450–625), `mvoswiok48da09-1792991976939.jpg` (x≈520, y 430–650; dashed y≈515), `mvoswiok48da09-1792992163249.jpg` (x≈580, y 505–575) | judge | fixed |
| first-drop-too-early-miss | minor | design | scene/play/play | tap_anchor result_again then key Space about 3s later → A new run starts. A Space at the start of the run (block still far off the tower) ends it as `Tower fell`, score 0, best stays 44 | Dropping too early is a miss, as the rules say. A first-time player has no warning that the first drop must wait for the block to reach the tower | captures/mvoswtk90867df-1792991783647.jpg, records/loops/create-1792989369596/play-1-2.md:22 | play | fixed |
| end-run-result-title | minor | client content | play | key Space, key P, tap_anchor pause_end → `End run` ended the run with score 1 and opened `Tower fell`, 0 perfect, streak 0, best 17 | correct. The title is `Tower fell` for a run ended by the player, which is the same as for a miss | captures/mvoswof415ef25-1792991724394.jpg, records/loops/create-1792989369596/play-1-1.md:30 | play | fixed |
| cut-piece-trail-lingers | minor | client content | play | none → tower of 6 blocks over a dark base; the view did not scroll yet. A ghost `BLOCK` trail of the cut piece stays faded on the right of the tower after a trim | the tail of the fall looks like a smear that lingers; the sliding block drawn on the left was cut by the `S` letter shapes of the background | captures/mvoswof415ef25-1792991698561.jpg, records/loops/create-1792989369596/play-1-1.md:24 | play | fixed |
| step-advances-more-game-time | minor | client content | scene/play | repeated Space on offset near 0 → 11 blocks, score 22, 7 perfects, best streak 3, speed rose 700 -> 920; `Perfect ×1` badge under score; "SKY" backdrop stays the same color | speed ramp is felt and readable; the sky did not visibly darken in 11 blocks; each step of 50 ms moved the game 75 ms (play ms 31476 -> 31551) | captures/mvosx0myf9cddf-1792991771737.jpg, records/loops/create-1792989369596/play-1-3.md:21 | play | fixed |
| result-tap-lost-while-opening | minor | client content | scene/play | key Escape, tap_anchor pause_end → `End run` ended the 0-point run and the result panel opened, the following `result_lobby` tap returned `anchor is not there or not visible` once (panel still opening) | the first tap right after End run was lost; it was not retried | records/loops/create-1792989369596/play-1-3.md:27 | play | fixed |

## measurements

| metric | value | range | result |
|---|---|---|---|
| input_latency_ms | 1 | 0..100 | in |
| no_response_permille | 0 | 0..200 | in |
| feedback_per_input | 5 | 1..1000 | in |
| scene_load_ms | 508 | 0..3000 | in |
| restart_delay_ms | 8868 | 1000..20000 | in |
| first_reward_ms | 24314 | 3000..40000 | in |
| reward_interval_ms | 1002 | 2000..30000 | out |
| goal_interval_ms | 21825 | 15000..180000 | in |

## load

none

## temporary resources

none
