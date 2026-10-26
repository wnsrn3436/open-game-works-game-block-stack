## Which UI art keys can be requested in this iteration
- decision: `image/ui_kit` is requested now with the platform, font, backdrop and audio keys. `nine_slice/block`, `nine_slice/ui/panel`, `nine_slice/ui/button` and `icon/best` stay `placeholder`: the `resource` skill requests them with `--see image/ui_kit`, and `ogw resource request` refuses `--see` of a key that is not final yet (`image/ui_kit is not final`). They are to be requested with `--see image/ui_kit` once it is final
- evidence: `resource` skill `## placeholder resource` (UI kit first, then `nine_slice` and `icon` keys with `--see image/ui_kit`); the refusal of `ogw resource request ... --see image/ui_kit` in this iteration

## Slide, perfect and regrow numbers of the first tower
- decision: start width 440, block height 56, slide half range 640, speed 700 units/s plus 20 per block up to 1700, perfect tolerance 12, regrow from the 3rd perfect in a row by 24, streak bonus at most 5, 150ms between blocks, 1000ms fall wait (`data/system/game_setting.csv`). `first_reward_ms`, `reward_interval_ms` and `goal_interval_ms` in `## tuning targets` are to be brought into range with `ogw measure`
- evidence: genre convention of one-tap stackers (a full sweep of about 2 s at the start and under 1 s late, a perfect window of a few frames at 60 fps); `game-design` `## deciding without asking` rule 3

## How a perfect drop is rewarded
- decision: a perfect drop scores 1 plus the streak count (at most `[perfect_bonus_max]`), and from the `[regrow_streak]`th perfect in a row the block grows back. The request says only that a perfect drop keeps the full width and gives a bonus
- evidence: `brief.md` `## genre conventions` (twist of the perfect bonus); the reference game grows the block back after a perfect streak

## Pause in a run
- decision: `Esc`, `P` and gamepad `Start`/`B` open a pause popup (`Resume`, `End run`) during a run. The request does not name a pause; the reference game has none
- evidence: platform convention on macOS: `Esc` must not open the quit confirmation in the middle of a run (`ui-core` `### back input` sends back on a root panel with `Close` to the quit confirmation); a run can be left without losing its score

## Verification of the run result
- decision: `verify_play_session` checks bounds (blocks per play session time, score per block and perfect, perfects and best streak) and does not recalculate the run. There is no ranking board and no item reward, so no result value becomes a reward amount or a rewarded ranking score
- evidence: `play-session` `### result verification`; `game-design` `## design doc` (recalculation is required only with a `ranking_reward` board)

## Sound of a UI press
- decision: `[ui_button_click]` plays `sfx/place` (the soft tock of a landing block), so the game keeps the 3 sound effects of the request
- evidence: the request ("3 sound effects"); `audio direction` of `design.md`

## Gamepad prompt names
- decision: the `input_prompt` names of the bottom face button are `A` (Generic, Xbox), `Cross` (PlayStation) and `B` (Nintendo); `Start` is `Start`, `Menu`, `Options` and `+`. The touch prompt of `drop` is `Space`, because the macOS build has no touch screen
- evidence: the button labels of the controller families; `input-core` `### input prompt`

## Toast of the option panel
- decision: the copy and failure toasts of the option panel use the toast that `MessageCore` builds in code (white text on a dark band); the game has no toast prefab
- evidence: `message-core` `## settings` (`MessageCore.toastResource` empty means the code-made toast); the toast shows only after option panel buttons

## How to bring `reward_interval_ms` (1002) and `goal_interval_ms` (11909) into range
- decision: `[perfect_tolerance]` 12 → 7 so fewer drops are perfect and the time between two perfects grows; `[slide_speed_step]` 20 → 10 so the slide speeds up half as fast and a run lasts more blocks. The values are to be checked with the next `ogw measure`
- evidence: `records/loops/create-1792989369596/measure-1.json` (`reward_interval_ms` 1002 out of 2000..30000 with data `game_setting.perfect_tolerance`; `goal_interval_ms` 11909 out of 15000..180000 with data `game_setting.slide_speed_step`); one block cycle lasts about 1.06 s at the start (640 units at 700 units/s plus 150 ms), so a median of 1002 ms means almost every drop was perfect; `game-design` `## deciding without asking` rule 3

## How a new player learns that an early drop misses
- decision: the drop hint reads `Click or press {action:drop} when the block is over the tower` and shows in each run until its first drop while the record has fewer than `[hint_runs]` (3) runs, instead of only in the first run. The early drop stays a miss
- evidence: play-1-2 (an early `Space` at the start of a later run ended it as `Tower fell` with no warning); the genre rule that a block that does not touch the tower misses (`brief.md` `## genre conventions`)

## Title of a run ended with `End run`
- decision: the result title is `Run ended` for a run the player ended from the pause popup, `New best!` still first when the score beats the best
- evidence: play-1-1 (`Tower fell` after `End run` read as a miss that did not happen)

## Idle motion of the HUD and the result panel
- decision: the crown of the HUD best plate and of the result `Best` row pulses in a loop (`tween/common/icon_pulse`), and `Play again` dims to 80% and brightens back in a loop (`tween/common/button_glow`, color only; `TweenCore` refuses a color above 1, so its size and the text sizes the UI quality check counts do not change). A looping scale on `Play again` was tried and dropped: the UI quality capture caught it mid-scale as an overlap with `Lobby` and a seventh text size
- evidence: judge-1-1 (`idle-motion-hud-result`: 0 idle motions where the reference result panel has 2); local captures of `play.open_result` with the scale loop

## Reward popup
- decision: no reward popup is added; a perfect drop keeps being rewarded on the run screen at the moment of the drop (`design.md` `## screens`)
- evidence: `brief.md` `## prohibitions` (no gems, coins, skins or unlocks; the reference reward popup shows coins flying to a counter); `brief.md` `## emotion` (the flow of one input per block)

## The tap lost while the result panel opens after `End run`
- decision: the result panel keeps opening after the server saves the run; `play-guide.md` `## input lock window` now states this wait after `End run`, so a play agent waits for the panel instead of tapping into it
- evidence: reproduced on an instance: `tap_anchor result_lobby` right after `tap_anchor pause_end` failed with `anchor is not there or not visible` while `get_state` showed `ui_flow` `true`; 0.5 s later the same tap went to the lobby. `client-content` `## scene and prefab` (panels open with tween presets)

## HUD texts over the sky
- decision: the score, `Getting ready` and the drop hint sit on HUD plates (`HudPlate`) instead of floating over the sky, and the lobby title and record line are direct children of the lobby panel instead of a layout box
- evidence: check-1 UI quality (`flat panel .../Hud/Top`, `.../LobbyPanel/Top`, `low contrast .../Hud/Top/Score` 2.94:1 and `.../Hud/Hint` under the pause dim); `client-content` `### UI composition` (a HUD plate is the size of what it holds)

## Score plate of the run HUD
- decision: the score plate holds a cream `Score` tab (`HudTab`, the panel frame color) above the number, the same way the best plate holds its crown and `Best`; the streak badge moves down under the taller plate. The tab is cream, not gold, because the pause dim darkens a gold tab under the navy caption below 3:1
- evidence: check-2 UI quality (`flat panel .../Hud/ScorePlate: 86% one color` under the pause dim); the harness `presentationProblems` on `ogw capture` JPEGs and `list_ui` of `play.open_pause` and `play.open_play` at 1920x1080 (a gold tab left `low contrast .../Tab/Caption: 2.96:1`; the cream tab leaves no problem)
