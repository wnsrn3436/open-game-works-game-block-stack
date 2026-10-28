# open-game-works-game-block-stack

[한국어](README.ko.md)

**Block Stack** is a one-tap block stacking game for macOS in the style of Stack by Ketchapp. When you drop a block
sliding left and right onto the tower, the part that hangs over is cut off, and a drop that lines up exactly keeps the
full width. AI agents made it with [open-game-works](https://github.com/wnsrn3436/open-game-works-core).

<p align="center"><img src=".github/media/block-stack.gif" alt="block-stack gameplay" width="640"></p>

## Status

The game was made from a one-paragraph request in a single 3-iteration run of the open-game-works `create game` loop,
and was played and checked on macOS during development. The loop stopped at its iteration limit, and the open defects
are listed in the loop end record (`records/loops/create-1792989369596/end.md`). The `build` command
has not been run yet, so there is no release build.

## What it is

A block slides left and right over the tower. You drop it with one click, and the part that hangs over the block below
is cut off and falls, so the next block is narrower by that much. A drop that lines up exactly with the block below is
a perfect drop: the block keeps its width, a streak bonus is added, and from the third perfect in a row the block grows
back. The slide gets faster with every block stacked. The run ends when a block misses the tower completely.

The game started from a one-paragraph request to the harness. Under `## request`, `brief.md` holds that request along
with the items the content agent decided because the request did not cover them. A human picked the reference game (Stack) and the
presentation game (Royal Match) during `setup game`.

| | |
|---|---|
| Players | one player |
| Platform | macOS (`settings.json` `buildPlatforms`) |
| Input | mouse, keyboard and gamepad |
| Screen | landscape, base resolution 1920x1080 |
| Languages | English |
| Client / server | Godot / TypeScript |
| Core version | `0.4.0` (`settings.json` `coreVersion`) |

### A run

1. Lobby: the game name, the record line (`Stack your first tower` before the first run, then `Runs n · Best streak n`),
   the best score plate, `Options`, a demo tower and the large `Play` button.
2. Start: `Getting ready` shows while the server opens the run, and the first block slides in from the left over the
   base slab. On the first run, a hint at the bottom of the screen explains how to drop.
3. Drops: every placed block scores 1. The block comes from the other side after each drop, and the slide speed starts
   at 700 and rises by 20 per block, up to 1700 (`data/system/game_setting.csv`).
4. Perfect: a drop within 12 units of the block below keeps the width and adds the streak count as a bonus (+1 for the
   first perfect in a row, +2 for the second, at most +5). From the third perfect in a row the block grows back by 24
   units, up to the starting width of 440. `Perfect ×n` shows under the score.
5. Miss: a drop that does not touch the block below at all ends the run. The block falls off the tower with a red
   flash, and after about a second the result panel opens with `New best!` or `Tower fell`, the score counting up,
   `Best`, `Perfect drops` and `Best streak`. `Play again` has focus first, and pressing it starts the next run right
   away.

Opening the pause popup (`Resume`, `End run`) stops game time. A new player sees the terms popup once before the
lobby. The best score, the best streak, the run count and the total blocks stacked are the only things kept between
runs. There are no gems, coins, skins, unlocks, ads, payments or continues after a miss.

### Controls

| input | action |
|---|---|
| left click on the play area, `Space`, gamepad `A` | drop the sliding block |
| `P`, `Esc`, gamepad `Start` or `B` | pause during a run |
| mouse click, `Enter` | press a UI button (`Enter` presses the focused one) |

### Look and sound

The art is bright flat 2D with soft gradients and gentle bevels. The sky goes from light blue (`#8FD8F8`) to deep blue
(`#3F7FD9`) and darkens toward dusk and night colors as the tower rises. The block colors blend through coral
(`#FF7A59`), sun yellow (`#FFC94A`), mint (`#3DDC97`) and lilac (`#9B8CFF`), one step per block. Panels are navy
(`#1E2A4A`) with a cream frame, and main buttons are gold (`#FFB627`). A placed block squashes slightly and the cut
piece spins as it falls. A perfect drop brings a white glow, a ring and a screen flash, and a miss brings a red flash.
Landing blocks and button presses make a soft wooden sound, a perfect drop rings a clear glassy chime, and a miss
makes a whoosh and a thud. A calm lo-fi marimba loop plays in the lobby and during a run.

## How it works

The client runs the tower, and the server keeps the record.

```
client/ (Godot)                               server/ (TypeScript)
features/play/play_tower.gd                   server core module play-session
  integer tower simulation in game
  units, advanced with game time

run start --- StartPlaySession -----------> hooks/play_session.ts prepare_run
run end   --- FinishPlaySession ----------> verify_run, apply_run
              PlaySessionResult
              (blocks, score, perfects,
               best_streak)
          <-- updated RecordUserState ----- runs, best_score, best_streak, total_blocks
```

- `verify_run` does not replay the run and checks only upper bounds. The block count cannot exceed one block per 150 ms
  of run time. The score must be at least the block count and at most the block count plus 5 per perfect, the perfect
  count must not exceed the block count, and the best streak must not exceed the perfect count. `apply_run` adds one to
  the run count and keeps the higher of the old and new values for the best score and the best streak.
- Gameplay values (block size, slide range and speed, perfect tolerance, regrow amount, bonus cap, delays) are rows of
  `data/system/game_setting.csv`, not constants in code.
- The game defines no requests of its own. `contract/service.proto` holds only `PlaySessionResult`, and
  `contract/user_state.proto` holds `RecordUserState`.
- Core modules the game chose (`settings.json` `coreModules`): client `TweenCore`, `ScreenEffectCore`, `InputCore`,
  `SoundCore`, `NativeUiCore`; server `play-session`.

## Made with open-game-works

[open-game-works](https://github.com/wnsrn3436/open-game-works-core) is a harness for AI agents to build server-client
games. The features that many games repeat are prebuilt as core, and agents write only the gameplay as content code. A
game is made in a loop. The content agent edits, and the play agent plays an instance with real input. The judge agent
compares that instance with the baseline game and also with the gameplay video of the reference game, and the harness
tool decides success from the judge results and automated checks. Resource sub-agents generate the final resources, and
translation sub-agents handle the translations.

This game was made with one `create game` loop (3 iterations) and took about 1 hour 40 minutes from `setup game` to the
merge into main (`records/loops/create-1792989369596/`).

| iteration | what happened |
|---|---|
| 1 | The content agent wrote the brief, the design doc, the data, the contract, the server hooks, the scenes and prefabs, and requested the final resources. Every check passed except UI quality. The judge agent rated the presentation below the reference game |
| 2 | The content agent fixed 12 of the 15 defects, and the resource agents generated the final art and sound. A tween preset value went out of range and the bot playtest stopped, so this iteration was not played or judged |
| 3 | With every final resource in place, every check passed except UI quality. The judge agent rated it below iteration 1, which had a wider perfect tolerance |

The loop merged iteration 1's commit into main, with the final resources generated after it added on top. The content
code the agents wrote is about 2,300 lines (GDScript and TypeScript), on top of about 106,000 lines of prebuilt core.

`client/core/` and `server/core/` are copies of
[core release v0.4.0](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.4.0), and the engine
version also comes from that release (Godot 4.7.2). When it starts, `update game` raises `coreVersion` to the newest core
release this game can use.

| repository | contents |
|---|---|
| [open-game-works-core](https://github.com/wnsrn3436/open-game-works-core) | the harness: agent rules, skills, module specs, the CLI `ogw` |
| [open-game-works-core-impl](https://github.com/wnsrn3436/open-game-works-core-impl) | the core implementation. Core releases are its GitHub Releases |
| open-game-works-game-block-stack | this game |

## Repository layout

| path | contents |
|---|---|
| `brief.md` | The brief: player fantasy, emotion, memorable moment, genre conventions, prohibitions, failure penalty, prediction, reference game, the request and the items the content agent decided |
| `design.md` | The design doc: core loop, controls, screens, systems (tower, score, run and record), feel and tuning targets, art and audio direction, terms, core usage |
| `play-guide.md` | The play guide that the play agent and the judge agent receive: goal, controls, game flow, failure, input lock windows, fastest start path, play mode per scene |
| `settings.json` | Game settings: core version, engine, core modules, build platforms, languages, resolutions, per-environment values, terms documents, core settings overrides |
| `contract/` | Contract (protobuf): `service.proto`, `user_state.proto`, `error.proto` |
| `data/` | CSV tables (`tables/`), system tables (`system/`, including `game_setting.csv`), translations (`translations/`), glossary (`glossary.csv`), enums and invariants |
| `resource/` | Resources by resource key: app icon, splash, font, UI kit, sky, block and UI frames, crown icon, BGM, sound effects, scenes, prefabs, tween presets. `resources.csv` lists every resource key, with the method and license of each generated or catalog resource (and the source of the font) |
| `client/` | Godot project. Content code in `boot/`, `common/` and `features/` (`title`, `lobby`, `play`), regression tests in `tests/`, DEV code in `dev/` (bot playtest scenario `dev/bot/scenario.json`). `core/` and `generated/` are written by the harness tool. `resource` is a link to `../resource` |
| `server/` | TypeScript server. `main.ts` registers the hooks in `hooks/play_session.ts`, regression tests in `tests/`, DEV code in `dev/`. `core/` and `generated/` are written by the harness tool |
| `records/` | Process records that agents and the tool write: the setup records (`setup/`), the loop records (`loops/create-1792989369596/`: request, content reports, check results, play feedback, judge results, defects, iteration records, end record) and a core proposal (`core-proposals/`) |
| `LICENSE`, `LICENSES/` | License texts |

The `id-registry` branch holds only the ID registry (`id_registry.json`). Only the data tool writes to this branch, and
it is never merged with another branch. Build artifacts (`builds/`), the data binaries (`client/build/`,
`server/build/`), captures and loop evidence are not committed.

### Languages

The source language is English. `settings.json` sets no `sourceLanguage`, so the default `en` applies, and
`supportedLanguages` contains only `en`. The game text is in `data/translations/en.csv`, and `data/glossary.csv` fixes
names such as the game title.

## Requirements

- An open-game-works workspace with the harness set up as its
  [README](https://github.com/wnsrn3436/open-game-works-core) describes (Node 24 or later, Git, GitHub CLI, Docker with
  buildx, uv and Python, Claude Code or Codex)
- Godot 4.7.2. The engine version is set by the core release this game pins, and `update env` installs it into
  `<workspace>/.ogw/`
- Building the macOS app needs an Apple silicon Mac with Xcode 27 (named by `engine.json` of core release 0.4.0).
  macOS is the only build platform for this game
- Windows: `client/resource` is a symbolic link. Enable Developer Mode and run `git config --global core.symlinks true`
  before cloning, or the link checks out as a plain text file. The play agent and the judge agent run only on macOS and
  Linux, so the loop and builds cannot run on Windows

## Setup

Clone the repository into the workspace's `games/` folder, and create the local branch `id-registry` from the remote one. A
clone has only `main` as a local branch, and the data tool reads the ID registry from the local `id-registry` branch.

```
<workspace>/
  open-game-works-core/
  open-game-works-core-impl/
  games/open-game-works-game-block-stack/
```

```sh
cd <workspace>
git clone https://github.com/wnsrn3436/open-game-works-game-block-stack.git games/open-game-works-game-block-stack
git -C games/open-game-works-game-block-stack branch id-registry origin/id-registry
```

The folder name is the game name in commands. Then open Claude Code or Codex in `open-game-works-core/` and run
`update env`. This command checks this game's build tools and installs the engine that matches its core version.

### Reference game videos

`records/setup/reference/reference.md` records the reference game (Stack) and the presentation game (Royal Match). A
human picked both games during `setup game`, and the file also records the source URLs of their gameplay videos and
the moments in the videos that the judge agent compares against. The video files are not in the repository (`.gitignore`
excludes every file in `records/setup/reference/` except `reference.md`), but the judge agent of `update game` needs
them. Before you run the loop, fetch each video by running this from `open-game-works-core/` (needs `yt-dlp`):

```sh
tools/bin/ogw game reference open-game-works-game-block-stack <a YouTube URL in reference.md>
```

The video is saved in `records/setup/reference/` as `<video id>.mp4`, which is the name listed under `## video`
in `reference.md`.

## Usage

Give these commands in a Claude Code or Codex session opened in `open-game-works-core/`. The agent that receives a
command carries it to the end and reports the result.

| command | what it does |
|---|---|
| `update game: open-game-works-game-block-stack <request>` | Changes the game through the loop. The request is human feedback or a PROD problem to fix. When the loop stops and main has not changed in the meantime, the commit the tool picked is merged into main, and the result is reported in the loop end record |
| `build: open-game-works-game-block-stack DEV` | Hardens the server and client content code, runs the checks again with PostgreSQL, builds the macOS app into `builds/`, tags the commit `dev-<version>` and deploys the DEV server. Without `--version`, the first build is `0.1.0` |

STG and PROD builds also produce signed artifacts. STG also deploys the server, and a human deploys PROD.

### Running an instance

An instance is a dev run of the game, made up of one local server with its own DB and a client that draws the screen.
`ogw` is `tools/bin/ogw` in the harness repository, and you run it from `open-game-works-core/`.

```sh
tools/bin/ogw instance start open-game-works-game-block-stack   # prints the instance id and address
tools/bin/ogw instance stop <id>
```

The client logs in with a dev account and starts without the terms popup. The DB is SQLite unless you pass
`--db postgresql`, and `--commit <sha>` starts the instance from another commit. `ogw capture <id>` captures the
screen. `ogw log <id>` shows the error log, and `ogw command <id> list_commands` lists the content commands of the
game.

### Before the first DEV build

`settings.json` does not have the build stage values yet (server URLs, deploy hosts, signing, CDN, server image). The
lead agent of the first `build` asks for them. `settings.json` holds only the names of secrets, and the values go into
the host's secret store. Values that can be generated go in with
`tools/bin/ogw secret generate open-game-works-game-block-stack DEV`, and the others with
`tools/bin/ogw secret set open-game-works-game-block-stack <DEV|signing> <name>`. `secret set` reads the value from
standard input.

## License

| part | license |
|---|---|
| The content of this repository | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) (`LICENSE`) |
| `client/core/`, `server/core/` (copies of an open-game-works core release) | Apache-2.0 (`LICENSES/Apache-2.0.txt`) |
| `resource/font/main.ttf` (Noto Sans) | SIL Open Font License 1.1 (`LICENSES/OFL-1.1-NotoSans.txt`) |

`resource/resources.csv` lists every resource key. For the final resources made by a generation method or taken from a
pinned catalog, it also gives the method and license, and for the font the source and attribution as well. Those
resources are:

| resources | method | license |
|---|---|---|
| `app_icon/main`, `splash/main`, `image/ui_kit`, `background/sky`, `nine_slice/*`, `icon/best` | `sprite-gen-codex` | OpenAI output terms (`LicenseRef-OpenAI-Output`) |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `bgm/main` | `ace-step` | MIT |
| `font/main` | `font-catalog` | OFL-1.1 |

The license manifest of the game, `client/generated/licenses.json`, lists the third-party components, such as the
Godot Engine, with their licenses and notices.
