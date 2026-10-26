## defects

| id | result | note |
|---|---|---|
| lobby-title-options-overlap | fixed | |
| hud-text-low-contrast | fixed | |
| flat-panels | fixed | |
| idle-motion-hud-result | fixed | |
| option-sound-toggle-unreadable | fixed | |
| reward-interval-short | fixed | |
| goal-interval-short | fixed | |
| play-dir-state-wrong | fixed | |
| panel-edge-line-fragments | not reproduced | With the final `nine_slice/ui/panel` and `nine_slice/ui/button` art (resource commit 03cd303, after the judged commit 43d4062), the pause popup (`captures/mvotht9e8598db-1792992697804.jpg`) and the result panel (`captures/mvothti754df1e-1792992881140.jpg`) show no line fragments. The fragments in the judge captures are strokes of the placeholder `PANEL`/`BUTTON` letters cut by the 9-slice margins. The terms popup was not opened (dev accounts start without it); it uses the same panel and button styles |
| no-reward-popup | refused | The reference reward popup shows coins flying to a counter; `brief.md` `## prohibitions` has no gems, coins, skins or unlocks, and a popup per perfect drop would stop the one-input rhythm of `## emotion`. A perfect drop stays rewarded on the run screen at the moment of the drop; `design.md` `## screens` now says so |
| first-drop-too-early-miss | fixed | |
| end-run-result-title | fixed | |
| cut-piece-trail-lingers | fixed | |
| step-advances-more-game-time | not reproduced | The game advances by exactly the step: on an instance in step mode the tower moved 35 units per 50 ms step at speed 700 (50 ms of game time); only the `play ms` that `ogw step` prints, which `QACore` counts, rose by 75 per step (132538 → 133363 over 11 steps). Core proposal written. The sky tint that did not darken in 11 blocks was changed in the same iteration: it now reaches dusk at 15 blocks and night at 40 (was 40 and 100) |
| result-tap-lost-while-opening | fixed | |

What was done per fixed defect:

- `lobby-title-options-overlap`, `flat-panels`: the lobby title and record line are no longer in a full-width layout box; the title is 920 wide at the top center and clears `Options` and the best plate. The HUD score sits on a `HudPlate` the size of the number
- `hud-text-low-contrast`: the score, `Getting ready` and the drop hint are on `HudPlate` plates, so they keep their contrast over the sky and under the pause dim
- `idle-motion-hud-result`: the crown of the HUD best plate and of the result `Best` row pulses (`tween/common/icon_pulse`); `Play again` glows in a loop (`tween/common/button_glow`)
- `option-sound-toggle-unreadable`: the toggles read `Music: On`/`Music: Off` and `Sound effects: On`/`Sound effects: Off` and change with each press (checked on an instance)
- `reward-interval-short`, `goal-interval-short`: `[perfect_tolerance]` 12 → 7, `[slide_speed_step]` 20 → 10
- `play-dir-state-wrong`: content state `play.dir` is the direction the block moves now (`PlayTower.motion_dir`), with a regression test; checked on an instance that it flips at each far end
- `first-drop-too-early-miss`: the drop hint says `when the block is over the tower` and shows in each of the first `[hint_runs]` (3) runs until the run's first drop
- `end-run-result-title`: a run ended with `End run` shows `Run ended` (checked on an instance)
- `cut-piece-trail-lingers`: the lingering trail was the perfect glow, which the glow tween scaled from 1 while the glow rect was drawn at scale 0.5, so it doubled in size and shifted right. The glow now widens around a centered `GlowRoot` (checked on an instance after a perfect drop)
- `result-tap-lost-while-opening`: reproduced (the tap went in while the result panel was opening after the run save); the wait after `End run` is now in `play-guide.md` `## input lock window`. The game behavior is unchanged

## unverified

- `reward_interval_ms` and `goal_interval_ms` with the new data were not measured; they need the play instances of `ogw loop evaluate`
- The UI quality check itself was not run. A local copy of its layout and presentation rules (the harness functions `layoutProblems` and `presentationProblems` on `ogw capture` JPEGs and `list_ui`) reported no problem for `lobby.open_lobby`, `lobby.open_option`, `play.open_play`, `play.open_pause` and `play.open_result` at 1440x900 and 1920x1080. The real check reads PNG captures, so a contrast value near 3:1 can differ
- The backdrop `background/sky` is still a placeholder (pink with `SKY`); the HUD plates and the contrast were checked only over it
- The terms popup was not opened on an instance

## requests

- core proposal: records/core-proposals/1792993304467-qa-step-play-ms.md
- resource requests: none. The rows still `requested` from records/loops/create-1792989369596/resource-requests/1792990167257.md (`app_icon/main`, `splash/main`, `font/main`, `image/ui_kit`, `background/sky`, the sounds and the BGM) have no result yet; `tween/common/icon_pulse` and `tween/common/button_glow` are new `final` tween rows

## assumptions

- records/loops/create-1792989369596/assumptions.md: bringing the reward and goal intervals into range; the drop hint in the first 3 runs; the `Run ended` title; idle motion of the HUD and the result panel; no reward popup; the tap lost while the result panel opens; HUD texts on plates
