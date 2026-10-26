## defects

| id | result | note |
|---|---|---|
| tween-preset-invalid-value | fixed | |
| flat-panels | fixed | |
| idle-motion-hud-result | not done | awaiting confirmation of the iteration 2 fix; the `Play again` glow of that fix is the preset of `tween-preset-invalid-value`, fixed this time |
| option-sound-toggle-unreadable | not done | awaiting confirmation of the iteration 2 fix |
| reward-interval-short | not done | awaiting confirmation of the iteration 2 fix (needs `ogw measure`) |
| goal-interval-short | not done | awaiting confirmation of the iteration 2 fix (needs `ogw measure`) |
| play-dir-state-wrong | not done | awaiting confirmation of the iteration 2 fix |
| panel-edge-line-fragments | not done | awaiting confirmation (not reproduced in iteration 2) |
| first-drop-too-early-miss | not done | awaiting confirmation of the iteration 2 fix |
| end-run-result-title | not done | awaiting confirmation of the iteration 2 fix |
| cut-piece-trail-lingers | not done | awaiting confirmation of the iteration 2 fix |
| step-advances-more-game-time | not done | awaiting confirmation (not reproduced in iteration 2; core proposal records/core-proposals/1792993304467-qa-step-play-ms.md) |
| result-tap-lost-while-opening | not done | awaiting confirmation of the iteration 2 fix |

What was done per fixed defect:

- `tween-preset-invalid-value`: cause checked in `TweenCore._values_in_range`: a `COLOR` change must stay in 0..1, and `tween/common/button_glow` went to 1.2. It now dims `Play again` to 0.8 and back. On an instance, `play.open_result` gave `no error log` and the `Play again` pixels changed across a 2 s video (mean difference 4.7–16.5 against the first frame)
- `flat-panels`: the HUD score plate holds a cream `Score` tab above the number (`HudTab`, `TabLabel`, reserved string `[play_score]`); the streak badge moved down under it. On an instance, the harness `presentationProblems` on the captures and `list_ui` of `play.open_pause` and `play.open_play` reported no problem

## unverified

- The UI quality check and the bot playtest themselves were not run. The flat and contrast results come from `ogw capture` JPEGs at 1920x1080 only; the real check reads PNG captures at every `uiCheckScreens` size
- `ogw check --static` passed with a `COLOR` value of 1.2 in a tween preset, so this kind of preset error shows only at run time

## requests

- resource requests: none (`tween/common/button_glow` and `prefab/play/hud_panel` are content-made; their hashes were synced with `ogw resource sync`)
- core proposals: none

## assumptions

- records/loops/create-1792989369596/assumptions.md: `Score plate of the run HUD`; `Idle motion of the HUD and the result panel` edited (the glow dims instead of brightening)
