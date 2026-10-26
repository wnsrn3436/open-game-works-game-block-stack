## commit

- instance: 43d406267e9646fbc21d3813c276c7a7e29440e0
- baseline: none
- confirms: none

## checks

| check | result | file |
|---|---|---|
| regression test | pass | records/loops/create-1792989369596/check-1.json |
| static check | pass | records/loops/create-1792989369596/check-1.json |
| no blocker | pass | records/loops/create-1792989369596/check-1.json |
| full flow | pass | records/loops/create-1792989369596/check-1.json |
| performance | pass | records/loops/create-1792989369596/check-1.json |
| UI quality | fail | records/loops/create-1792989369596/check-1.json |
| no placeholder | fail | records/loops/create-1792989369596/check-1.json |
| row simulation | pass | records/loops/create-1792989369596/check-1.json |

## judge

### records/loops/create-1792989369596/judge-1-1.md

- kind: main
- status: done
- A: 43d406267e9646fbc21d3813c276c7a7e29440e0
- B: none
- vs baseline: none
- vs reference: fail
- omitted moments: none

#### moments

- first 30000ms of `A`: the terms popup is up at 14174 ms. After `Agree to all` and `Confirm`, the lobby loads in 517 ms; `Play` loads the run in 502 ms, and the first block slides about 550 ms after the tap. Over the play window, telemetry `idle_span_ms` is 0.
- core action of `A`: Space drops the block with 1 ms latency. A perfect drop shows an expanding translucent ring, a lighter background flash, `Perfect ×1` and the score going 0→2. A trimmed drop shows the cut piece falling and rotating (capture `mvoswiok48da09-1792991838213.jpg`).
- first reward of `A`: the first perfect drop logs `Reward` at the same play_at (97122) as the input. Score +2, the `Perfect ×1` badge appears and Best updates live to 2 (capture `mvoswiok48da09-1792991717312.jpg`).
- first failure of `A`: a drop at offset -627 with width 350 misses. The screen flashes red, the block tumbles off the left side, the camera pulls back to the whole tower, and after 1043 ms of game time (`Fail`→`Goal`) the result panel fades in: `New best!`, score 57, Best 57, Perfect drops 15, Best streak 6.
- restart of `A`: `Play again` shows a single Loading frame, then score 0, Best 57, and a block sliding from the left about 300 ms after the tap. Telemetry `restart_delay_ms` 1053 (run 2).
- lobby of `A`: title `Block Stack`, `Stack your first tower`, Best plate 0, `Options`, demo tower with a sliding top block, pulsing `Play`. All art is placeholder (`SKY`, `BLOCK`, `BUTTON`, `BEST`).
- hud of `A`: score at top center, Best plate at top right, `Perfect ×n` badge under the score; nothing in the HUD moves while no input is given.
- reward popup of `A`: no reward popup screen exists. The per-drop reward is shown inside the HUD (`Perfect ×n` badge, ring, flash).
- result of `A`: the panel has a header band (`New best!`/`Tower fell`), a score inset with count-up, and 3 stat rows. `Lobby` is on the left, `Play again` (focused) on the right. The panel has no idle motion.

#### loser better

none

## play

| feedback | blocker | major | minor | none |
|---|---|---|---|---|
| records/loops/create-1792989369596/play-1-1.md | 0 | 1 | 7 | 8 |
| records/loops/create-1792989369596/play-1-2.md | 0 | 2 | 5 | 5 |
| records/loops/create-1792989369596/play-1-3.md | 0 | 0 | 8 | 7 |

## defects

| id | severity | owner | where | what | why | evidence | source | status |
|---|---|---|---|---|---|---|---|---|
| lobby-title-options-overlap | major | client content | scene/lobby/lobby | overlap UICore/Panel/SafeAreaRoot/LobbyPanel/Top/Title UICore/Panel/SafeAreaRoot/LobbyPanel/Options in prefab/lobby/lobby_panel (en, macbook_air_13, lobby.open_lobby, text scale 1000) | the lobby title and the Options button overlap, so the UI quality check fails | records/loops/create-1792989369596/check-1.json#UI quality, records/loops/create-1792989369596/evidence/check-1/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.json | check | open |
| hud-text-low-contrast | major | client content | scene/play/play | low contrast UICore/Panel/SafeAreaRoot/Hud/Top/Score: 2.94:1 in prefab/play/hud_panel (en, macbook_air_13, play.open_pause, text scale 1000) | HUD text is below the contrast the UI quality check needs | records/loops/create-1792989369596/check-1.json#UI quality, records/loops/create-1792989369596/evidence/check-1/ui-macos/0004-en-macbook_air_13-play.open_pause-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0004-en-macbook_air_13-play.open_pause-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0010-en-display_16_9-play.open_pause-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0010-en-display_16_9-play.open_pause-1000.json | check | open |
| flat-panels | major | client content | scene/lobby/lobby | flat panel UICore/Panel/SafeAreaRoot/LobbyPanel/Top: 100% one color in prefab/lobby/lobby_panel (en, macbook_air_13, lobby.open_lobby, text scale 1000) | lobby and HUD panels are one flat color, which the UI quality check fails | records/loops/create-1792989369596/check-1.json#UI quality, records/loops/create-1792989369596/evidence/check-1/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0001-en-macbook_air_13-lobby.open_lobby-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0003-en-macbook_air_13-play.open_play-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0003-en-macbook_air_13-play.open_play-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0004-en-macbook_air_13-play.open_pause-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0004-en-macbook_air_13-play.open_pause-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0007-en-display_16_9-lobby.open_lobby-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0009-en-display_16_9-play.open_play-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0009-en-display_16_9-play.open_play-1000.json, records/loops/create-1792989369596/evidence/check-1/ui-macos/0010-en-display_16_9-play.open_pause-1000.png, records/loops/create-1792989369596/evidence/check-1/ui-macos/0010-en-display_16_9-play.open_pause-1000.json | check | open |
| idle-motion-hud-result | major | client content | result panel | No element moves while no input is given for 2000 ms (idle motion 0). The reference `Well Done!` panel has 2 (sparkles, star glow) | The result screen is static where the reference keeps motion on the reward panel; this count is below the reference | `mvoswiok48da09-1792991993228.jpg` vs `mvoswiok48da09-1792991996026.jpg` (PSNR inf); ref video-2 44000/45000 ms, `mvoswiok48da09-1792992151985.jpg` vs `mvoswiok48da09-1792992154854.jpg` (top 260 px, PSNR inf); ref video-2 103000/105000 ms, captures `mvoswiok48da09-1792991642917-video` (lobby), `mvoswiok48da09-1792992151985.jpg` vs `…2154854.jpg` (HUD), `mvoswiok48da09-1792991993228.jpg` vs `…1996026.jpg` (result), `mvoswiok48da09-1792992163249.jpg` vs `…2175708.jpg` (press); ref frames video-2 at 44000/45000, 103000/105000, 126000–132000, 132000–140000, records/loops/create-1792989369596/judge-1-1.md | judge | open |
| option-sound-toggle-unreadable | major | client content | options | tap_anchor lobby_options → panel opened with `Sound`, `Account` (user code shown), `About` and `Close`. The `Music` and `Sound effects` labels are dark text on the dark green placeholder `BUTTON` letters and are nearly unreadable; the toggles show an orange box with no on/off word | cannot tell if sound is on or off from the screen | captures/mvoswof415ef25-1792991729473.jpg, records/loops/create-1792989369596/play-1-1.md:32, captures/mvoswtk90867df-1792991793813.jpg, records/loops/create-1792989369596/play-1-2.md:23, captures/mvosx0myf9cddf-1792991810221.jpg, records/loops/create-1792989369596/play-1-3.md:29 | play | open |
| reward-interval-short | minor | data | reward_interval_ms | value 1002 out of 2000..30000 | the measured reward interval is below the design.md target range | records/loops/create-1792989369596/measure-1.json#reward_interval_ms | check | open |
| goal-interval-short | minor | data | goal_interval_ms | value 11909 out of 15000..180000 | the measured goal interval is below the design.md target range | records/loops/create-1792989369596/measure-1.json#goal_interval_ms | check | open |
| play-dir-state-wrong | minor | client content | scene/play | tap_anchor lobby_play, step mode → first block slid from the left at speed 700; `offset` ran from -384 down to -629, then turned back toward 0 while `dir` read 1 the whole time | `dir` value does not match the direction of the offset change (offset got more negative with dir 1 moving right, then rose with dir still 1). The block moved, so play was not blocked | records/loops/create-1792989369596/play-1-3.md:18, step log, play ms 97869–98094 | play | open |
| panel-edge-line-fragments | minor | client content | terms, result and pause panels | Short white line fragments sit at the panel edges, not part of any drawn resource: a vertical stroke at the left edge, a dot or stroke at the right, and a dashed line under the score inset | They look like a partly drawn outline made in code, laid over the panels | `mvoswiok48da09-1792991618919.jpg` (x≈500, y 450–625), `mvoswiok48da09-1792991976939.jpg` (x≈520, y 430–650; dashed y≈515), `mvoswiok48da09-1792992163249.jpg` (x≈580, y 505–575) | judge | open |
| no-reward-popup | minor | design | reward | There is no reward popup screen; the reward is only the in-HUD `Perfect ×n` badge, ring and flash. The reference's reward moment has a panel, coins flying to the counter and a `+49` count-up | There is no screen to match the `reward popup` presentation moment | captures `mvoswiok48da09-1792991717312.jpg`; ref video-2 126000–132000 ms | judge | open |
| first-drop-too-early-miss | minor | design | scene/play/play | tap_anchor result_again then key Space about 3s later → A new run starts. A Space at the start of the run (block still far off the tower) ends it as `Tower fell`, score 0, best stays 44 | Dropping too early is a miss, as the rules say. A first-time player has no warning that the first drop must wait for the block to reach the tower | captures/mvoswtk90867df-1792991783647.jpg, records/loops/create-1792989369596/play-1-2.md:22 | play | open |
| end-run-result-title | minor | client content | play | key Space, key P, tap_anchor pause_end → `End run` ended the run with score 1 and opened `Tower fell`, 0 perfect, streak 0, best 17 | correct. The title is `Tower fell` for a run ended by the player, which is the same as for a miss | captures/mvoswof415ef25-1792991724394.jpg, records/loops/create-1792989369596/play-1-1.md:30 | play | open |
| cut-piece-trail-lingers | minor | client content | play | none → tower of 6 blocks over a dark base; the view did not scroll yet. A ghost `BLOCK` trail of the cut piece stays faded on the right of the tower after a trim | the tail of the fall looks like a smear that lingers; the sliding block drawn on the left was cut by the `S` letter shapes of the background | captures/mvoswof415ef25-1792991698561.jpg, records/loops/create-1792989369596/play-1-1.md:24 | play | open |
| step-advances-more-game-time | minor | client content | scene/play | repeated Space on offset near 0 → 11 blocks, score 22, 7 perfects, best streak 3, speed rose 700 -> 920; `Perfect ×1` badge under score; "SKY" backdrop stays the same color | speed ramp is felt and readable; the sky did not visibly darken in 11 blocks; each step of 50 ms moved the game 75 ms (play ms 31476 -> 31551) | captures/mvosx0myf9cddf-1792991771737.jpg, records/loops/create-1792989369596/play-1-3.md:21 | play | open |
| result-tap-lost-while-opening | minor | client content | scene/play | key Escape, tap_anchor pause_end → `End run` ended the 0-point run and the result panel opened, the following `result_lobby` tap returned `anchor is not there or not visible` once (panel still opening) | the first tap right after End run was lost; it was not retried | records/loops/create-1792989369596/play-1-3.md:27 | play | open |

## measurements

| metric | value | range | result |
|---|---|---|---|
| input_latency_ms | 1 | 0..100 | in |
| no_response_permille | 0 | 0..200 | in |
| feedback_per_input | 5 | 1..1000 | in |
| scene_load_ms | 509 | 0..3000 | in |
| restart_delay_ms | 8034 | 1000..20000 | in |
| first_reward_ms | 23366 | 3000..40000 | in |
| reward_interval_ms | 1002 | 2000..30000 | out |
| goal_interval_ms | 11909 | 15000..180000 | out |

## load

none

## temporary resources

none
