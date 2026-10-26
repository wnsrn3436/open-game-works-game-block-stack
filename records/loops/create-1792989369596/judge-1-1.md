# judge result — run create-1792989369596, iteration 1

Input: `A` = instance `mvoswiok48da09` (this instance). `B` = `null`, so there is no baseline comparison. No save fixtures. Reference: `Stack` (core moments, `reference-video-1.mp4`); presentation reference: `Royal Match` (`reference-video-2.mp4`).

All instance captures below are from `mvoswiok48da09`, recorded on 2026-10-26 (unix ms in the file name). Telemetry was read with `ogw telemetry mvoswiok48da09`. The metric values come from `ogw telemetry compare` run with A's guide on both sides. B is null, so only the `A` column is used, and the winner and margin it printed are ignored. Window bounds are wall-clock ms since instance start, the same clock as the `play ms` that `ogw step` prints.

Placeholder resources: almost every UI surface is a placeholder (resource key word drawn on a flat color: `BUTTON`, `PANEL`, `BLOCK`, `SKY`, `BEST`). This covers the terms popup, the lobby, HUD plates, blocks, the background, the result panel and the pause popup. As the criteria say, `presentation` does not judge those places. Only idle motion, press feedback and non-placeholder drawing were compared.

## vs baseline

none

## vs reference

| instance | element | result | reason | evidence |
|---|---|---|---|---|
| A | game feel | pass | Every drop responds within 1 ms. Each drop logs Sound + Tween plus a ScreenEffect or Effect: the landed block gets an expanding translucent ring, the background flashes lighter and a `Perfect ×n` badge pops. On a trimmed drop the cut piece falls and rotates. Each drop in the reference core action shows a landing, a score tick and a white outline ring on perfect, so A is at that level | telemetry `input_latency_ms` 1, `feedback_per_input` 7 (whole session; 8 over the play window 95000–400000 ms); captures `mvoswiok48da09-1792991717312..825.jpg` (perfect drop, play ms 113076–113590), `mvoswiok48da09-1792991838213..918.jpg` (trim); ref frames 16000–20000 ms |
| A | tension and release | pass | There are 2 failure points: a full miss ends the run, and every non-perfect drop trims the block, which brings the miss closer (width 440→416→399→288 over run 1). A success gets its reward presentation at the same `play_at` as the input: `Reward` mark with `Response` at 97122, 98174, 99176… The reference first failure (59000–64000 ms) has the same structure (miss ends the run, camera pulls back) | telemetry marks `Response`/`Reward` pairs at identical `play_at`; `Fail` at play_at 113802 → `Goal` at 114845; captures `mvoswiok48da09-1792991953712..1955222.jpg` (miss, play ms 349476–350987) |
| A | progression | pass | Perfect drops produce a `Reward` mark every 902–1002 ms of game time. The score rises on every drop, with a streak bonus of +1…+5. From the 3rd perfect in a row the block grows +24 (254→278→302→326→350). Reference first reward (17000–21000 ms): score tick plus a perfect ring every ~1 s and a +1 gem. A is at that level | telemetry `reward_interval_ms` 902 (session), 1002 (window 112000–210000); state log streak 3→6 with `top_width` 278/302/326/350 |
| A | one more run | pass | After the miss, `Restart` is logged 1053 ms after `Fail`, when `Play again` is pressed as soon as the panel opens. The reference video goes from miss to a new run in about 2000–3000 ms (63000→66000 ms). The cause is on screen: the missed block tumbles off the tower's side, the screen flashes red, and the camera pulls back to show the whole tower before the result panel opens | telemetry `restart_delay_ms` 1053 (run 2, Fail play_at 125113 → Restart 126166). The first measurement, 4603, includes 2000 ms the judge deliberately idled on the result panel. Captures `mvoswiok48da09-1792991953712.jpg`–`1955222.jpg`, `mvoswiok48da09-1792992111286..112892.jpg` (restart, block sliding ~300 ms after the tap) |
| A | no friction | pass | Over the play window, `idle_span_ms` is 0. The game's own waits are short: scene loads of 26 ms (title), 517 ms (lobby) and 502 ms (play), and a 150 ms lock after each drop. The session-wide `idle_span_ms` of 69192 (and 23337) are spans in the lobby and on the terms popup before the judge's first input. No game wait was running there; the judge was reading reference frames. Start path: 2 taps on the terms popup (new user), 1 tap on `Play`, then drops. The reference's first 30000 ms (14000–44000) go from menu to stacking within ~2 s | telemetry window 95000–400000: `idle_span_ms` 0; `scene_loads` 26/517/502 ms; `goal_input_count` 24 (run 1, including terms and Play), 8 (run 2) |
| A | presentation | fail | Idle motion with no input for 2000 ms is lower than the reference on two screens. **HUD**: A has 0 (HUD band pixel-identical across 2000 ms of game time; PSNR inf); Royal Match HUD has ≥2 (king avatar animates, board pieces shimmer; diff 103000 vs 105000 ms). **Result**: A has 0 (whole frame pixel-identical over 2000 ms; PSNR inf); the `Well Done!` panel has 2 (twinkling sparkles around the star, star glow; diff 44000 vs 45000 ms). **Lobby**: A 2 (demo top block slides, `Play` pulses), reference ≥1. **Reward popup**: A has no reward popup screen; its reward is the in-HUD `Perfect ×n` badge and ring. The reference (126000–132000) has a `Well Done` panel, coins flying to the counter with `+49`, and a `Castle` panel. **Press feedback**: A 1 (Resume darkens and its label shifts; Sound + Tween on mouse_down); reference not visible in frames. Panel layers were not compared: all of A's panels are placeholders | captures `mvoswiok48da09-1792991642917-video` (lobby), `mvoswiok48da09-1792992151985.jpg` vs `…2154854.jpg` (HUD), `mvoswiok48da09-1792991993228.jpg` vs `…1996026.jpg` (result), `mvoswiok48da09-1792992163249.jpg` vs `…2175708.jpg` (press); ref frames video-2 at 44000/45000, 103000/105000, 126000–132000, 132000–140000 |

## moments

- first 30000ms of `A`: the terms popup is up at 14174 ms. After `Agree to all` and `Confirm`, the lobby loads in 517 ms; `Play` loads the run in 502 ms, and the first block slides about 550 ms after the tap. Over the play window, telemetry `idle_span_ms` is 0.
- core action of `A`: Space drops the block with 1 ms latency. A perfect drop shows an expanding translucent ring, a lighter background flash, `Perfect ×1` and the score going 0→2. A trimmed drop shows the cut piece falling and rotating (capture `mvoswiok48da09-1792991838213.jpg`).
- first reward of `A`: the first perfect drop logs `Reward` at the same play_at (97122) as the input. Score +2, the `Perfect ×1` badge appears and Best updates live to 2 (capture `mvoswiok48da09-1792991717312.jpg`).
- first failure of `A`: a drop at offset -627 with width 350 misses. The screen flashes red, the block tumbles off the left side, the camera pulls back to the whole tower, and after 1043 ms of game time (`Fail`→`Goal`) the result panel fades in: `New best!`, score 57, Best 57, Perfect drops 15, Best streak 6.
- restart of `A`: `Play again` shows a single Loading frame, then score 0, Best 57, and a block sliding from the left about 300 ms after the tap. Telemetry `restart_delay_ms` 1053 (run 2).
- lobby of `A`: title `Block Stack`, `Stack your first tower`, Best plate 0, `Options`, demo tower with a sliding top block, pulsing `Play`. All art is placeholder (`SKY`, `BLOCK`, `BUTTON`, `BEST`).
- hud of `A`: score at top center, Best plate at top right, `Perfect ×n` badge under the score; nothing in the HUD moves while no input is given.
- reward popup of `A`: no reward popup screen exists. The per-drop reward is shown inside the HUD (`Perfect ×n` badge, ring, flash).
- result of `A`: the panel has a header band (`New best!`/`Tower fell`), a score inset with count-up, and 3 stat rows. `Lobby` is on the left, `Play again` (focused) on the right. The panel has no idle motion.

## loser better

none

## strengths

- Input response is immediate: `input_latency_ms` 1, with 6–8 feedback events per drop (Sound, Tween, ScreenEffect/Effect).
- The streak rules work as the play guide says: the bonus goes +1→+5 and is capped, and from the 3rd perfect in a row the block regrows +24 (254→350 over 4 perfects). This gives a way to recover from trims.
- The cause of failure is on screen: the red flash, the block tumbling off the side, and the camera pulling back to the whole tower all happen before the result panel.
- Restart is fast: `Restart` 1053 ms after `Fail`, and a new block slides ~300 ms after `Play again`. No error log during the session.

## defects

| instance | where | what | why | severity | evidence |
|---|---|---|---|---|---|
| A | result panel | No element moves while no input is given for 2000 ms (idle motion 0). The reference `Well Done!` panel has 2 (sparkles, star glow) | The result screen is static where the reference keeps motion on the reward panel; this count is below the reference | major | `mvoswiok48da09-1792991993228.jpg` vs `mvoswiok48da09-1792991996026.jpg` (PSNR inf); ref video-2 44000/45000 ms |
| A | play HUD | No HUD element moves while no input is given for 2000 ms (idle motion 0). The reference HUD has ≥2 (animated avatar, shimmering pieces) | The HUD idle motion count is below the reference | major | `mvoswiok48da09-1792992151985.jpg` vs `mvoswiok48da09-1792992154854.jpg` (top 260 px, PSNR inf); ref video-2 103000/105000 ms |
| A | reward | There is no reward popup screen; the reward is only the in-HUD `Perfect ×n` badge, ring and flash. The reference's reward moment has a panel, coins flying to the counter and a `+49` count-up | There is no screen to match the `reward popup` presentation moment | minor | captures `mvoswiok48da09-1792991717312.jpg`; ref video-2 126000–132000 ms |
| A | terms, result and pause panels | Short white line fragments sit at the panel edges, not part of any drawn resource: a vertical stroke at the left edge, a dot or stroke at the right, and a dashed line under the score inset | They look like a partly drawn outline made in code, laid over the panels | minor | `mvoswiok48da09-1792991618919.jpg` (x≈500, y 450–625), `mvoswiok48da09-1792991976939.jpg` (x≈520, y 430–650; dashed y≈515), `mvoswiok48da09-1792992163249.jpg` (x≈580, y 505–575) |
| A | play state (`content.play.dir`) | `dir` stays `1` after the block bounces at offset 625 and moves left (offset 625→590→555→520) | The play guide tells agents to read the direction from `dir`; the shown value does not match the motion. Not visible on screen | minor | step log, play ms 97869–98094 |
