## goal

Stack as many blocks as possible. A block slides left and right above the tower; the player drops it so that it lands on the block below. The part that hangs over is cut off, so the next block is narrower. A drop that lines up with the block below within a few pixels is a perfect drop: the block keeps its width and scores a streak bonus, and from the third perfect in a row the block grows back. The run ends when a block misses the tower completely. The score and the best score are shown on the result panel.

## controls

- `Space` (key name `Space`), left mouse click on the play area, or gamepad `A` (button name `a`): drops the sliding block where it is. Ignored while no block slides (about 150ms after each drop, during the fall after a miss, while paused)
- `P` (key name `P`), gamepad `Start`, `Esc` (key name `Escape`) or gamepad `B`: during a run, opens the pause popup
- Buttons on screen are pressed by click; the focused button also by `Enter`
- Scoring: each placed block +1. A perfect drop adds the streak count as a bonus (1st perfect in a row +1, 2nd +2, … at most +5). The streak badge `Perfect ×n` shows under the score
- The block slides faster with every placed block, and the side it comes from alternates (left first)

## game flow

1. Terms consent popup (new user only): `Agree to all` (anchor `terms_agree_all`) turns on both consent checkboxes, then `Confirm` (anchor `terms_confirm`)
2. Lobby: the game name and the record line at the top (`Stack your first tower` before the first run, then `Runs n · Best streak n`), the best score plate at the top right, `Options` (anchor `lobby_options`) at the top left, a demo tower in the middle and the large `Play` (anchor `lobby_play`, first focus) at the bottom center
3. Run: `Getting ready` shows briefly, then the first block slides from the left over the base slab. On the first run, `Click or press Space to drop the block` shows at the bottom until the first drop. The score is at the top center, the best score at the top right
4. Each drop: the block lands (trim or perfect), the cut piece falls, and after about 150ms the next block slides in from the other side. The view scrolls up as the tower grows and the sky darkens
5. Miss: the block falls off the tower, the screen flashes red, and after about 1 second the result panel opens: `New best!` or `Tower fell`, the score counting up, `Best`, `Perfect drops`, `Best streak`. `Play again` (anchor `result_again`, first focus, right) starts a new run; `Lobby` (anchor `result_lobby`, left) goes to the lobby
6. Pause popup: `Resume` (anchor `pause_resume`) continues; `End run` (anchor `pause_end`) ends the run with the score so far and opens the result panel
7. Option panel (from the lobby): `Music` and `Sound effects` toggles, the user code with `Copy code`, `Get account deletion code`, `Withdraw`, `Terms of service`, `Privacy policy`, `Licenses`, and `Close` (anchor `option_close`)

## failure

- A drop that does not touch the block below (the sliding block's offset from the top block is its width or more) is a miss: the run ends. Restart: `Play again` (anchor `result_again`) on the result panel, or `Lobby` then `Play`
- A drop that only partly overlaps is not a failure: the overhang is cut off and the run continues with a narrower block

## input lock window

- boot and title: input is not accepted until login finishes (about 1000ms~3000ms)
- scene change (lobby ↔ run): input is not accepted during the loading screen (about 300ms~2000ms)
- run start: no block slides until the server answers (about 100ms~500ms); a drop does nothing
- after each drop: 150ms (`[next_block_delay]`) until the next block slides; a drop does nothing
- after a miss: 1000ms (`[fall_wait]`) of fall plus the result save before the result panel; input does nothing
- pause popup: while it is open, game time stops and the block holds. In step mode during this time `ogw step` fails with game time paused. Close it with `tap_anchor pause_resume`

## fastest start path

1. (new user) terms popup `tap_anchor terms_agree_all` → `tap_anchor terms_confirm`
2. Lobby: `tap_anchor lobby_play`
3. About 300ms~2000ms of loading and the server answer, then the first block slides; `key Space` drops it

## play mode

| scene | mode | step ms |
|---|---|---|
| `scene/title/title` | `free` | |
| `scene/lobby/lobby` | `free` | |
| `scene/play/play` | `step` | 50 |

- In step mode, `ogw step <instance> 50 --state` shows `content.play`: `offset` (the sliding block's left edge minus the top block's left edge; 0 is perfectly lined up), `width` (sliding block width), `perfect_tolerance` (|offset| at or below this is a perfect drop), `speed` (units per second), `dir` (1 moving right, -1 moving left), `phase` (`sliding`, `waiting`, `fallen`), `score`, `blocks`, `streak`. The block moves `speed` × step ms ÷ 1000 units per step; drop with `ogw input <instance> key Space` when `offset` is closest to 0 (`unconfirmed`: whether one key event between steps lands at the shown offset or 1ms later)
