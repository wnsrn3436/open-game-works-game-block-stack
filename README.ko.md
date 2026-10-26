# open-game-works-game-block-stack

[English](README.md)

**블록 스택**(`Block Stack`)은 Ketchapp의 Stack 스타일의 macOS용 원탭 블록 쌓기 게임으로, 좌우로 움직이는 블록을 탑 위에
떨어뜨리면 삐져나온 부분이 잘려 나가고, 딱 맞게 떨어뜨리면 폭이 그대로 유지된다. AI 에이전트가
[open-game-works](https://github.com/wnsrn3436/open-game-works-core)로 만들었다.

<p align="center"><img src=".github/media/block-stack.gif" alt="block-stack gameplay" width="640"></p>

## 상태

한 문단짜리 요청(`records/loops/create-1792989369596/request.md`)으로 open-game-works의 `create game` 루프를 3번 돌려
만들었다. 루프는 반복 한도에서 멈췄고, 아직 열려 있는 결함은 루프 종료 기록(`records/loops/create-1792989369596/end.md`)에
있다. 출시용 빌드는 아직 하지 않았다.

## 라이선스

| 대상 | 라이선스 |
|---|---|
| 이 저장소의 콘텐츠 | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) (`LICENSE`) |
| `client/core/`, `server/core/` (open-game-works core 릴리스의 사본) | Apache-2.0 (`LICENSES/Apache-2.0.txt`) |
| `resource/font/main.ttf` (Noto Sans) | SIL Open Font License 1.1 (`LICENSES/OFL-1.1-NotoSans.txt`) |

`resource/resources.csv`에는 모든 리소스 키가 있다. 생성 방법으로 만들었거나 고정된 카탈로그에서 가져온 최종
리소스에는 제작 방법과 라이선스도 적혀 있고, 폰트에는 출처와 저작권 표시도 적혀 있다. 그 리소스는 다음과 같다.

| 리소스 | 방법 | 라이선스 |
|---|---|---|
| `app_icon/main`, `splash/main`, `image/ui_kit`, `background/sky`, `nine_slice/*`, `icon/best` | `sprite-gen-codex` | OpenAI 출력물 약관 (`LicenseRef-OpenAI-Output`) |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `bgm/main` | `ace-step` | MIT |
| `font/main` | `font-catalog` | OFL-1.1 |

게임의 라이선스 매니페스트 `client/generated/licenses.json`에 Godot Engine 같은 서드파티 구성 요소와 그 라이선스,
고지문이 있다.
