# open-game-works-game-block-stack

[한국어](README.ko.md)

**Block Stack** is a one-tap block stacking game for macOS in the style of Stack by Ketchapp: drop each sliding block on
the tower, the overhang is cut off, and a perfect drop keeps the full width.
AI agents made it with [open-game-works](https://github.com/wnsrn3436/open-game-works-core).

<p align="center"><img src=".github/media/block-stack.gif" alt="block-stack gameplay" width="640"></p>

## Status

The game was made with open-game-works through one `create game` loop of 3 iterations from a one-paragraph request
(`records/loops/create-1792989369596/request.md`). The loop stopped at its iteration limit, and its loop end record
(`records/loops/create-1792989369596/end.md`) lists the defects still open. It has not been built for release yet.

## License

| part | license |
|---|---|
| The content of this repository | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) (`LICENSE`) |
| `client/core/`, `server/core/` (copies of an open-game-works core release) | Apache-2.0 (`LICENSES/Apache-2.0.txt`) |
| `resource/font/main.ttf` (Noto Sans) | SIL Open Font License 1.1 (`LICENSES/OFL-1.1-NotoSans.txt`) |

`resource/resources.csv` lists every resource key. For the final resources made by a generation method or taken from a
pinned catalog, it also gives the method and license, and for the font the source and attribution. Those resources
are:

| resources | method | license |
|---|---|---|
| `app_icon/main`, `splash/main`, `image/ui_kit`, `background/sky`, `nine_slice/*`, `icon/best` | `sprite-gen-codex` | OpenAI output terms (`LicenseRef-OpenAI-Output`) |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `bgm/main` | `ace-step` | MIT |
| `font/main` | `font-catalog` | OFL-1.1 |

The license manifest of the game, `client/generated/licenses.json`, lists the third-party components, such as the
Godot Engine, with their licenses and notices.
