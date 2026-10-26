## player fantasy

The player is a calm sky builder who raises a tower of bright blocks one click at a time, chasing the clean click of a perfect fit as the tower climbs and narrows.

## emotion

Core emotion: absorbed rhythm that tightens into suspense (flow, then held breath).

Curve of one run (about 30 to 90 seconds):

1. 0 to 10 s: a wide block slides slowly over the tower. Each click lands with a soft tock; the rhythm is easy and pleasant
2. 10 to 30 s: the slide speeds up with every block. Small misses trim the overhang off, and the falling scraps make each mistake visible. The first `Perfect` chime is a small thrill
3. Perfect streaks: three perfects in a row and the block starts to grow back. Relief and pride; the player leans in to keep the streak
4. 30 s and later: the block is narrow and fast. Every click is a held breath; the sky color has shifted far from the start, showing how high the tower is
5. The miss: the block slides off the tower and falls. A short sting, the score, the best score, and one press to try again at once

## memorable moment

The block has been trimmed down to a sliver at high speed, the player lands three perfects in a row, and on the fourth `Perfect ×4` the sliver grows back with a bright chime and a white flash while the tower keeps climbing into a darker, deeper sky.

## genre conventions

| convention | decision | reason |
|---|---|---|
| One input: click or tap drops the sliding block | accept | It is the whole identity of the genre and makes the game readable at a glance |
| The overhang is cut off and falls; the tower narrows | accept | Mistakes stay visible and raise the tension of the next drop |
| A perfect drop keeps the full width | accept | The request asks for it, and it is the skill reward of the genre |
| The perfect bonus is only a sound and a combo count | twist | Each perfect in a streak adds bonus points (the streak count, up to 5), and from the third perfect in a row the block grows back. A streak is worth chasing, and a narrow tower can be saved |
| 3D isometric tower with a moving camera | twist | A 2D side view with a soft gradient sky. The block slides left and right over the tower, so the timing reads exactly on a flat screen |
| Endless tower, the run ends on the first miss | accept | Short runs and an instant restart make the "one more try" loop |
| Collected gems unlock block skins and themes | reject | One clean look and one score to beat; nothing to grind |
| Revive by watching an ad | reject | A premium macOS game without ads; the miss is final and the restart is instant |

## prohibitions

- No gems, coins, skins or unlocks (removes the genre-standard gem collection and skin shop). The only progress is the best score
- No ads, no payments, no revive or continue after a miss
- No input other than the drop (and pause): no aiming, no moving the tower, no power-ups
- No speed jump without the speed growing a little every block; the slide never changes speed in the middle of a block
- No miss without the falling block shown: the run never ends off screen

## failure penalty

- Share of progress lost per mistake: a partial overlap trims the block (0‰ of the run; the score and height stay, only the width shrinks). A miss (no overlap) ends the run: 1000‰ of that run's tower is lost, while the best score and the run count are kept by the server (0‰ of the record)
- Duration limit of the loss state: 2500ms. It is the fall wait `[fall_wait]` (1000ms) while the missed block falls, plus the result save
- Delay limit from the end of the loss until control is possible again: 2000ms. `Play again`, the first focus of the result panel, is pressed with one click, `Space` or `Enter`, and the next tower takes drops as soon as the server starts its play session

## prediction

If it works, after the first miss the player will press `Play again` within 5 seconds of the result panel and play at least three runs in a row.

## reference game

Stack

records/setup/reference/reference.md

How this game differs from the reference game:

- A 2D side view of the tower over a gradient sky that darkens as the tower rises, instead of a 3D isometric tower
- The block slides left and right over the tower, alternating the side it comes from
- Each perfect in a streak adds bonus points equal to the streak count (up to 5), and from the third perfect in a row the block grows back
- No gems and no block skins; the best score is the only record
- A lobby with the best score and a result panel with the score, the best score and the best streak of the run (the presentation follows the presentation game Royal Match)
- macOS with mouse, keyboard and gamepad, in English

## request

2D block stacking game like Stack by Ketchapp, for macOS, in English. A block slides left and right above the tower; a click or tap drops it, and the part that hangs over the block below is cut off. A perfect drop keeps the full width and gives a bonus. The run ends when a block misses the tower; the result screen shows the score and the best score, and the player can play again. Keep it very small: one play screen, a lobby, a result screen, about 5 images, 3 sound effects and 1 background music.

Items the content agent decided because the request did not have them:

- The game name is `Block Stack` from `records/setup/name.md`
- Score: 1 point per placed block; a perfect adds the streak count (1st perfect +1, 2nd +2, up to `[perfect_bonus_max]`)
- Perfect: the moving block lands within `[perfect_tolerance]` of the block below. From the `[regrow_streak]`th perfect in a row, the block grows back by `[regrow_amount]` up to the start width
- The slide speed starts at `[slide_speed]` and grows by `[slide_speed_step]` per block up to `[slide_speed_max]`
- The best score, the best streak and the run count are kept on the server; the first run starts after the terms consent
- Controls: left click, `Space` or gamepad `A` drops; `Esc`, `P` or gamepad `Start` pauses during a run
- The target platform is macOS of game settings `buildPlatforms`; the screen is landscape, base resolution 1920x1080
- The images are the sky backdrop, the block, the panel frame, the button, the crown icon and the UI kit sheet; the sounds are the block landing, the perfect chime and the miss; one BGM plays in the lobby and in the run
