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
