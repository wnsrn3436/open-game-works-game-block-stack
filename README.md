# open-game-works-game-block-stack

[한국어](README.ko.md)

**Block Stack** is a one-tap block stacking game for macOS in the style of Stack by Ketchapp, made by AI agents with
[open-game-works](https://github.com/wnsrn3436/open-game-works-core).

<p align="center"><img src=".github/media/block-stack.gif" alt="block-stack gameplay" width="640"></p>

## Play it

You need an open-game-works workspace set up as the harness README
[Quick start](https://github.com/wnsrn3436/open-game-works-core#quick-start) describes:

```sh
cd <workspace>
git clone https://github.com/wnsrn3436/open-game-works-game-block-stack.git games/open-game-works-game-block-stack
git -C games/open-game-works-game-block-stack branch id-registry origin/id-registry   # the data tool reads IDs from it
cd open-game-works-core
tools/bin/ogw instance start open-game-works-game-block-stack   # prints the instance id and address
tools/bin/ogw instance stop <id>
```

After cloning, run `update env` once in the harness session (Claude Code or Codex in `open-game-works-core/`): it
installs this game's engine (Godot 4.7.2). The instance logs in with a dev account and skips the terms popup.

## The game

A block slides left and right over the tower. One click drops it: the part that hangs over the block below is cut off,
so the next block is narrower, and the slide gets faster with every block. A drop that lines up with the block below is
a perfect drop: the block keeps its width and scores a streak bonus, and from the third perfect in a row it grows back.
The run ends when a block misses the tower; `Play again` starts the next run at once. Only the best score, best streak,
run count and total blocks are kept. There are no coins, skins, ads, payments or continues.

| input | action |
|---|---|
| left click on the play area, `Space`, gamepad `A` | drop the sliding block |
| `P`, `Esc`, gamepad `Start` or `B` | pause during a run |
| mouse click, `Enter` | press a UI button (`Enter` presses the focused one) |

## Status

Made from a one-paragraph request in one `create game` loop of 3 iterations, and played on macOS during development.
Not built for release yet; open defects are in [the loop end record](records/loops/create-1792989369596/end.md).

## Change it with AI

Give these commands in the harness session opened in `open-game-works-core/`:

- `update game: open-game-works-game-block-stack <request>` changes the game through the loop and merges the result.
- `build: open-game-works-game-block-stack DEV` builds the macOS app into `builds/` and deploys the DEV server.

The judge agent of `update game` needs the reference gameplay videos, which are not in the repository. Fetch each
YouTube URL in [reference.md](records/setup/reference/reference.md) first (needs `yt-dlp`); it is saved under the name
`reference.md` expects:

```sh
tools/bin/ogw game reference open-game-works-game-block-stack <YouTube URL from reference.md>
```

<details><summary>Before the first DEV build</summary>

- Building the macOS app needs an Apple silicon Mac with Xcode 27.
- `settings.json` has no build stage values yet (server URLs, deploy hosts, signing, CDN, server image); the lead agent
  of the first `build` asks for them.
- `settings.json` holds only secret names. Put the values in your host's secret store with
  `tools/bin/ogw secret generate open-game-works-game-block-stack DEV` (generated values) and
  `tools/bin/ogw secret set open-game-works-game-block-stack <DEV|signing> <name>` (the others, read from stdin).

</details>

## How it is built

The client simulates the tower and draws the game; the server checks each run result and keeps the record.

```
client/ (Godot)                       server/ (TypeScript, core module play-session)
run start --- StartPlaySession ---->  prepare_run
run end   --- FinishPlaySession --->  verify_run (upper bounds only), apply_run
          <-- RecordUserState ------  runs, best score, best streak, total blocks
```

It pins core `0.4.0` (`settings.json` `coreVersion`): `client/core/` and `server/core/` are copies of
[core release v0.4.0](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.4.0). At its start,
`update game` raises `coreVersion` to the newest core release the game can use.

| path | contents |
|---|---|
| [brief.md](brief.md) | the request, player fantasy, emotion and genre decisions |
| [design.md](design.md) | core loop, screens, systems, tuning, art and audio direction |
| [play-guide.md](play-guide.md) | what the play and judge agents read: goal, controls, flow |
| [settings.json](settings.json) | core version, core modules, platform, language, resolution |
| [contract/](contract) | protobuf contract (run result, user record, errors) |
| [data/](data) | CSV tables, gameplay values (`system/game_setting.csv`), English text |
| [resource/](resource) | art, sound, scenes, prefabs, tweens; [resources.csv](resource/resources.csv) lists them |
| [client/](client) | Godot project; content code in `boot/`, `common/`, `features/` |
| [server/](server) | TypeScript server; hooks in `hooks/play_session.ts` |
| [records/](records) | setup and loop records written by the agents and the tool |

Made with the [open-game-works](https://github.com/wnsrn3436/open-game-works-core) harness.

## License

| part | license |
|---|---|
| The content of this repository | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) ([LICENSE](LICENSE)) |
| `client/core/`, `server/core/` (copies of an open-game-works core release) | Apache-2.0 ([LICENSES/Apache-2.0.txt](LICENSES/Apache-2.0.txt)) |
| `resource/font/main.ttf` (Noto Sans) | SIL Open Font License 1.1 ([LICENSES/OFL-1.1-NotoSans.txt](LICENSES/OFL-1.1-NotoSans.txt)) |

[resource/resources.csv](resource/resources.csv) lists every resource key, with the method and license of each
generated or catalog resource, and the source and attribution of the font:

| resources | method | license |
|---|---|---|
| `app_icon/main`, `splash/main`, `image/ui_kit`, `background/sky`, `nine_slice/*`, `icon/best` | `sprite-gen-codex` | OpenAI output terms (`LicenseRef-OpenAI-Output`) |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `bgm/main` | `ace-step` | MIT |
| `font/main` | `font-catalog` | OFL-1.1 |

The license manifest of the game, [client/generated/licenses.json](client/generated/licenses.json), lists the
third-party components, such as the Godot Engine, with their licenses and notices.
