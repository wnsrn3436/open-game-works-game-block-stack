## overview

- genre: one-tap timing stacker (arcade), single player
- one-line pitch: a block slides left and right over a tower; one click drops it, the overhang is cut off and falls, a perfect drop keeps the width and scores a streak bonus, and the run ends on the first block that misses the tower
- target platform: macOS (game settings `buildPlatforms`). Mouse, keyboard and gamepad
- screen orientation: landscape
- base resolution: 1920x1080. The tower is drawn in 2D side view in game coordinates (1 unit = 1 px of the base resolution); the UI is drawn over it

## core loop

1. Lobby: see the best score and the run count; press `Play` (first focus)
2. Run: the server starts a play session; the first block slides over the base slab
3. Drop: one click, `Space` or gamepad `A` stops the block where it is. The part over the block below stays and becomes the new top; the overhang is cut off and falls. A perfect drop keeps the whole width and adds the streak bonus
4. The next block, as wide as the new top, comes from the other side after `[next_block_delay]`, a little faster. The tower view scrolls up as it grows and the sky darkens
5. A block that does not touch the block below falls off: the run ends. After `[fall_wait]` the result is sent with `FinishPlaySession`; the server keeps the best score, the best streak and the run count
6. Result panel: score counting up, best score, perfects and best streak of the run. `Play again` (first focus) starts the next run at once; `Lobby` goes back

- Target duration of one drop cycle (block spawn to drop): 600ms~2500ms
- Target duration of one run: 15000ms~180000ms (a first run of about 15 to 40 blocks)

## controls

| input | action | result |
|---|---|---|
| left mouse click on the play area, `Space`, gamepad `A`, a tap | `drop` (the tap is the `TapEvent` of a touch pointer) | In a run, drops the sliding block. Ignored while no block slides (the `[next_block_delay]` between blocks, the fall wait, the pause) |
| `Esc`, gamepad `B` | `back` | In a run, opens the pause popup. In a popup or panel, its back behavior. On the lobby, the quit confirmation |
| `P`, gamepad `Start` | `pause` | In a run, opens the pause popup |
| mouse click, `Enter`/`Space` (focus), gamepad `A` (focus) | UI button | Buttons on every screen |

- Per-platform differences: none (macOS is the only target)

## screens

| scene | contents | next |
|---|---|---|
| `scene/title/title` | Sky backdrop (`background/sky`), a small three-block tower and the game name during boot. Terms popup `prefab/common/terms_popup` for a new user | After login, `scene/lobby/lobby` |
| `scene/lobby/lobby` | Sky backdrop. Root panel `prefab/lobby/lobby_panel`: the game name at the top center; a demo tower in the middle (base slab, five stacked blocks in the palette, one block sliding left and right on top, `tween/lobby/demo_slide`); the best score plate at the top right (`icon/best`, `Best`, value) and the record line under the title (`{runs} runs · best streak {streak}`, or `Stack your first tower` before the first run); `Options` at the top left; the large `Play` at the bottom center (first focus, breathing `tween/lobby/play_pulse`). Option panel `prefab/lobby/option_panel` | `Play` → `scene/play/play` |
| `scene/play/play` | The tower over the sky (`prefab/play/block` per block). Root panel `prefab/play/hud_panel`: the score at the top center, the best score plate at the top right, the streak badge under the score (`Perfect ×n`, `Grow!` added when the block grew), the drop hint at the bottom (first run only, until the first drop), `Getting ready` until the server starts the run. Pause popup `prefab/play/pause_popup`. Result panel `prefab/play/result_panel` | Result `Play again` → a new `scene/play/play`; result `Lobby` → `scene/lobby/lobby` |

- Terms popup: `Agree to all` turns both consent checkboxes on or off; confirm stays disabled until both are on, and the hint line above it says so
- Lobby: pressing `Play` twice changes the scene once. The back input on the root panel opens the quit confirmation; on the option panel it closes the panel
- Run start: until the server answers `StartPlaySession`, `Getting ready` shows and no block slides; a drop input does nothing. On failure, core shows an error and the scene returns to the lobby
- Drop: the block stops at once (the `Response` mark), lands with a squash (`tween/play/land`) and the place sound; the cut piece falls and spins away from the tower (`tween/play/cut_fall`). A perfect drop instead flashes a white glow over the block (`tween/play/perfect_glow`), plays the perfect chime, pops the streak badge (`tween/play/streak_pop`) and lights the screen for a moment (`tween/play/perfect_flash`). The score pops (`tween/play/score_pop`) on every drop. A drop input during the `[next_block_delay]` after a drop, during the fall wait or while paused is ignored
- Miss: the block falls off spinning (`tween/play/cut_fall`), the miss sound plays and the screen flashes red (`tween/play/fail_flash`). Inputs during the fall wait are ignored. After `[fall_wait]` the result is sent
- The tower view scrolls with `tween/play/tower_scroll` so the top block stays at the same screen height once the tower is high; the sky tint shifts from day blue toward dusk lilac and night navy with the height
- Pause: `Esc`, gamepad `B`, `P` or gamepad `Start` during a run opens the pause popup (`Resume`, `End run`). While it is open, game time stops (`TimeCore.set_paused`) and the sliding block holds. `End run` ends the run as a miss with the score so far. The pause popup does not open before the run starts, during the fall wait or on the result
- Result panel: the title is `New best!` when the score is above the best score before the run, otherwise `Tower fell`; the score counts up from 0 (`tween/play/count_up`); rows for `Best` (crown icon), `Perfect drops` and `Best streak`. `Lobby` on the left, `Play again` (first focus) on the right. Either button works once; a second press is ignored. The back input goes to the lobby. When the server refuses the result because the play session expired or is unknown, the panel shows `This run was not recorded` without a core error popup; other failures keep the core error handling and show the same line
- Every panel and popup opens with `tween/common/panel_in` and closes with `tween/common/panel_out`; every button press plays the click sound (`[ui_button_click]`) and the press bounce (`tween/common/button_press`)

## systems

### tower

- The tower simulation (`client/features/play/play_tower.gd`) is integer arithmetic in game coordinates with x relative to the tower axis, advanced with game time ms (`TimeCore.get_game_frame_ms`). It is not a deterministic simulation of `client-content`: the server does not recalculate it
- The base slab has width `[block_width]`, centered on the axis. Every block has height `[block_height]`
- A block slides at the height of the next tower level with the width of the top block. Its left edge is the left edge of the top block plus the offset o(t). With s the slide speed of that block, d = ⌊s × t ÷ 1000⌋ (t: game ms since the block appeared), R = `[slide_half_range]`, L = 2R, u = d mod 2L, p = u when u ≤ L, otherwise 2L − u: o = −R + p for a block from the left, R − p for a block from the right. Blocks alternate sides, the first from the left
- Slide speed of the n-th dropped block (n from 0): s = min(`[slide_speed]` + n × `[slide_speed_step]`, `[slide_speed_max]`) units per second
- Drop with offset o and width w:
  - |o| ≤ `[perfect_tolerance]`: perfect. The block lands exactly on the top block with width w; the streak grows by 1. From the `[regrow_streak]`th perfect in a row, the width grows by min(`[regrow_amount]`, `[block_width]` − w), half on each side (the left edge moves left by ⌊grow ÷ 2⌋)
  - |o| ≥ w: miss. The run ends
  - otherwise: trim. The overlap with the top block stays (width w − |o|); the rest falls; the streak resets to 0
- The next block appears `[next_block_delay]` after a drop

### score

- Each placed block scores 1. A perfect also scores min(streak, `[perfect_bonus_max]`) (the streak counts this perfect)
- The best streak of a run is the longest run of perfects in a row

### run and record

- A run is one play session of `play-session`. The mode is reserved ID `[run_mode]` → `[mode_tower]` of `play_session_mode` (`min_duration` 0, `max_duration` 2h), `level_id` 0 (any other value is `GAME_ERROR_LEVEL_NOT_FOUND`). There is no choice before the run, no continue (`max_continue_count` 0) and no loadout
- Result `PlaySessionResult`: `blocks` (placed blocks), `score`, `perfects`, `best_streak`. The client simulation decides it. Upper bounds checked by `verify_play_session` (it does not recalculate the run): `blocks` ≤ ⌊(`finished_at` − `started_at`) ÷ `[next_block_delay]`⌋ + 1; `blocks` ≤ `score` ≤ `blocks` × (1 + `[perfect_bonus_max]`); `perfects` ≤ `blocks`; `best_streak` ≤ `perfects`; `score` − `blocks` ≤ `perfects` × `[perfect_bonus_max]`. There is no ranking board
- `apply_play_session` counts the run in `RecordUserState`: `runs` + 1, `best_score` = max, `best_streak` = max, `total_blocks` += `blocks`. No item is granted

## progression

- Within a run: the slide speeds up every block; misses narrow the block; perfect streaks score more and grow the block back
- Between runs: the best score to beat. Nothing unlocks
- Tutorial steps: none. The first run shows the drop hint `Click or press {action:drop} to drop the block` until the first drop

## economy

none. The game has no items, currency, shop or store products

## new user

- Initial state: no `RecordUserState` row (no runs, best score 0). No server request creates an initial state
- First run: after the terms popup (`Agree to all`, `Confirm`) the lobby opens with `Stack your first tower`; one press of the focused `Play` starts the run

## feel targets

| metric | min | max | data |
|---|---|---|---|
| `input_latency_ms` | 0 | 100 | |
| `no_response_permille` | 0 | 200 | `game_setting.next_block_delay` |
| `feedback_per_input` | 1 | 1000 | |
| `scene_load_ms` | 0 | 3000 | |
| `restart_delay_ms` | 1000 | 20000 | `game_setting.fall_wait` |

## tuning targets

| metric | min | max | data |
|---|---|---|---|
| `first_reward_ms` | 3000 | 40000 | `game_setting.perfect_tolerance` |
| `reward_interval_ms` | 2000 | 30000 | `game_setting.perfect_tolerance` |
| `goal_interval_ms` | 15000 | 180000 | `game_setting.slide_speed_step` |

## art direction

- style: bright flat casual 2D with soft gradients and gentle bevels: clean geometric blocks with a subtle top highlight and soft shadow, rounded UI panels with layered frames, crisp sans-serif type. No pixel art, no outline heavier than 3 px (`records/setup/art-direction.md`)
- hex palette and roles:
  - background: sky gradient `#8FD8F8` (top of a low tower) to `#3F7FD9`; the run tints it toward dusk lilac and night navy as the tower rises
  - blocks: coral `#FF7A59`, sun `#FFC94A`, mint `#3DDC97`, lilac `#9B8CFF`; the block colors blend through them in that order, one step per block
  - panel: navy `#1E2A4A` with frame `#F4E7C5`
  - accent: gold `#FFB627` (primary buttons, streak badge, the crown)
  - reward: white glow and gold `#FFB627` (perfect glow, `New best!`)
  - danger: `#FF4D5E` (miss flash, the not-recorded line)
  - text: `#FFFFFF`, with a navy `#1E2A4A` shadow over the sky
- mood: calm, satisfying and upbeat; a relaxing rhythm that turns tense as the tower narrows
- outline: none on blocks; UI frames have the 2 px cream `#F4E7C5` frame of the panel art; text over the sky has a soft navy drop shadow
- text style: body text at font weight 500; titles, button labels, the score and other numbers, the streak badge in the heading text style at weight 800 (`LocalizationCore` font weights)
- proportions: a block is 440x56 at the start (about 8:1), and it narrows from there; the base slab is the same width and runs off the bottom of the screen
- light direction: soft light from the top; each block has a lighter top face band and a soft darker bottom edge
- camera view: flat 2D side view, the tower axis at the horizontal center of the screen; the view scrolls up with the tower
- screen density: the tower, the sliding block, the falling scraps and up to three HUD elements; large calm areas of sky
- UI frame: panel and popup titles sit on a header band of the panel art; stat rows are icon rows on inset plates; main actions are large gold buttons, secondary actions navy buttons
- representative resource keys: `background/sky`, `nine_slice/block`, `nine_slice/ui/panel`, `nine_slice/ui/button`, `icon/best`, `image/ui_kit`, `app_icon/main`, `splash/main`
- style block: Bright flat casual 2D game art with soft gradients and gentle bevels, clean geometric shapes with a subtle top highlight and soft shadow, rounded corners, no pixel art, no outlines heavier than 3 px, palette of sky blue #8FD8F8 to #3F7FD9, coral #FF7A59, sun yellow #FFC94A, mint #3DDC97, lilac #9B8CFF, navy #1E2A4A, cream #F4E7C5 and gold #FFB627, calm and upbeat mood.

## audio direction

- mood: calm, satisfying, upbeat; soft wooden and glassy tones that stay pleasant when heard every second
- BGM per scene: lobby and run `bgm/main` (one relaxed loop); title none
- events that play a sound: block landing (trim or perfect) and every UI press `sfx/place` (`[ui_button_click]`, `[block_place]`); perfect drop `sfx/perfect` (`[block_perfect]`); miss `sfx/fail` (`[block_miss]`)

## terms

- words used: `block`, `tower`, `drop`, `perfect`, `streak`, `score`, `best`, `run`, `grow`
- words not used: Stack (the reference game), Ketchapp, `gem`, `level`, `stage`, `combo`
- glossary terms: `Block Stack` (game name), `Perfect`, `streak`, the input prompt names

## core usage

- client hook: none
- server hooks: `play-session` `prepare_play_session` (`server/hooks/play_session.ts` `prepare_run`), `verify_play_session` (`verify_run`), `apply_play_session` (`apply_run`)
