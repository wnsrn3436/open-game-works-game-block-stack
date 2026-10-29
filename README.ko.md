# open-game-works-game-block-stack

[English](README.md)

**블록 스택**(`Block Stack`)은 Ketchapp의 Stack 스타일의 macOS용 원탭 블록 쌓기 게임으로, AI 에이전트가
[open-game-works](https://github.com/wnsrn3436/open-game-works-core)로 만들었다.

<p align="center"><img src=".github/media/block-stack.gif" alt="block-stack gameplay" width="640"></p>

## 직접 플레이하기

하네스 README의 [Quick start](https://github.com/wnsrn3436/open-game-works-core#quick-start)대로 준비한
open-game-works 작업 공간이 필요하다.

```sh
cd <workspace>
git clone https://github.com/wnsrn3436/open-game-works-game-block-stack.git games/open-game-works-game-block-stack
git -C games/open-game-works-game-block-stack branch id-registry origin/id-registry   # 데이터 도구가 여기서 ID를 읽음
cd open-game-works-core
tools/bin/ogw instance start open-game-works-game-block-stack   # 인스턴스 id와 주소를 출력
tools/bin/ogw instance stop <id>
```

클론한 뒤 하네스 세션(`open-game-works-core/`에서 연 Claude Code나 Codex)에서 `update env`를 한 번 실행한다. 이
명령이 이 게임의 엔진(Godot 4.7.2)을 설치한다. 인스턴스는 개발용 계정으로 로그인하고 약관 팝업 없이 시작한다.

## 게임 소개

블록이 탑 위에서 좌우로 움직인다. 한 번 클릭해 떨어뜨리면 아래 블록 밖으로 삐져나온 부분이 잘려 나가 다음 블록이
그만큼 좁아지고, 블록을 쌓을 때마다 움직이는 속도가 빨라진다. 아래 블록에 딱 맞게 떨어뜨리면 퍼펙트다. 블록 폭이
그대로 유지되고 연속 보너스가 붙으며, 세 번 연속 퍼펙트부터는 블록이 다시 넓어진다. 블록이 탑을 벗어나면 한 판이
끝나고, `Play again`으로 바로 다음 판을 시작한다. 남는 것은 최고 점수, 최고 연속 퍼펙트, 판 수, 쌓은 블록 총수뿐이다.
코인, 스킨, 광고, 결제, 이어하기는 없다.

| 입력 | 동작 |
|---|---|
| 플레이 영역 왼쪽 클릭, `Space`, 게임패드 `A` | 움직이는 블록 떨어뜨리기 |
| `P`, `Esc`, 게임패드 `Start` 또는 `B` | 판 진행 중 일시 정지 |
| 마우스 클릭, `Enter` | UI 버튼 누르기 (`Enter`는 포커스된 버튼) |

## 상태

한 문단짜리 요청으로 `create game` 루프 한 번(반복 3번)을 돌려 만들었고, 개발 중에 macOS에서 플레이했다. 출시용
빌드는 아직 하지 않았고, 아직 열려 있는 결함은 [루프 종료 기록](records/loops/create-1792989369596/end.md)에 있다.

## AI로 고치기

`open-game-works-core/`에서 연 하네스 세션에 아래 명령을 준다.

- `update game: open-game-works-game-block-stack <request>`는 루프로 게임을 고치고 결과를 병합한다.
- `build: open-game-works-game-block-stack DEV`는 macOS 앱을 `builds/`에 빌드하고 DEV 서버를 배포한다.

`update game`의 판정 에이전트에게는 레퍼런스 게임 플레이 영상이 필요한데, 영상은 저장소에 없다. 먼저
[reference.md](records/setup/reference/reference.md)의 YouTube URL마다 받아 온다(`yt-dlp` 필요). 영상은
`reference.md`가 기대하는 이름으로 저장된다.

```sh
tools/bin/ogw game reference open-game-works-game-block-stack <reference.md의 YouTube URL>
```

<details><summary>첫 DEV 빌드 전에</summary>

- macOS 앱을 빌드하려면 Xcode 27이 있는 Apple silicon Mac이 필요하다.
- `settings.json`에는 아직 빌드 단계 값(서버 URL, 배포 호스트, 서명, CDN, 서버 이미지)이 없다. 첫 `build`의 리드
  에이전트가 이 값을 묻는다.
- `settings.json`에는 시크릿 이름만 있다. 값은 호스트의 시크릿 저장소에 넣는다. 생성할 수 있는 값은
  `tools/bin/ogw secret generate open-game-works-game-block-stack DEV`로, 나머지는
  `tools/bin/ogw secret set open-game-works-game-block-stack <DEV|signing> <name>`으로 넣는다(값은 표준 입력).

</details>

## 만든 방식

탑은 클라이언트가 시뮬레이션하고 그리며, 서버는 판 결과를 확인하고 기록을 보관한다.

```
client/ (Godot)                       server/ (TypeScript, core module play-session)
run start --- StartPlaySession ---->  prepare_run
run end   --- FinishPlaySession --->  verify_run (upper bounds only), apply_run
          <-- RecordUserState ------  runs, best score, best streak, total blocks
```

core `0.4.0`(`settings.json` `coreVersion`)을 고정한다. `client/core/`와 `server/core/`는
[core 릴리스 v0.4.0](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.4.0)의 사본이다.
`update game`은 시작할 때 `coreVersion`을 이 게임이 쓸 수 있는 가장 새로운 core 릴리스로 올린다.

| 경로 | 내용 |
|---|---|
| [brief.md](brief.md) | 요청, 플레이어 판타지, 감정, 장르 관습에 대한 결정 |
| [design.md](design.md) | 코어 루프, 화면, 시스템, 튜닝, 아트와 오디오 방향 |
| [play-guide.md](play-guide.md) | 플레이 에이전트와 판정 에이전트가 읽는 목표, 조작, 흐름 |
| [settings.json](settings.json) | core 버전, core 모듈, 플랫폼, 언어, 해상도 |
| [contract/](contract) | protobuf contract(판 결과, 사용자 기록, 오류) |
| [data/](data) | CSV 테이블, 게임플레이 값(`system/game_setting.csv`), 영어 텍스트 |
| [resource/](resource) | 그림, 소리, 장면, 프리팹, 트윈. [resources.csv](resource/resources.csv)에 목록이 있음 |
| [client/](client) | Godot 프로젝트. content code는 `boot/`, `common/`, `features/` |
| [server/](server) | TypeScript 서버. 훅은 `hooks/play_session.ts` |
| [records/](records) | 에이전트와 도구가 쓴 셋업 기록과 루프 기록 |

[open-game-works](https://github.com/wnsrn3436/open-game-works-core) 하네스로 만들었다.

## 라이선스

| 대상 | 라이선스 |
|---|---|
| 이 저장소의 콘텐츠 | [CC BY-NC-ND 4.0](https://creativecommons.org/licenses/by-nc-nd/4.0/) ([LICENSE](LICENSE)) |
| `client/core/`, `server/core/` (open-game-works core 릴리스의 사본) | Apache-2.0 ([LICENSES/Apache-2.0.txt](LICENSES/Apache-2.0.txt)) |
| `resource/font/main.ttf` (Noto Sans) | SIL Open Font License 1.1 ([LICENSES/OFL-1.1-NotoSans.txt](LICENSES/OFL-1.1-NotoSans.txt)) |

[resource/resources.csv](resource/resources.csv)에는 모든 리소스 키가 있고, 생성하거나 카탈로그에서 가져온 리소스의
제작 방법과 라이선스, 폰트의 출처와 저작권 표시도 적혀 있다.

| 리소스 | 방법 | 라이선스 |
|---|---|---|
| `app_icon/main`, `splash/main`, `image/ui_kit`, `background/sky`, `nine_slice/*`, `icon/best` | `sprite-gen-codex` | OpenAI 출력물 약관 (`LicenseRef-OpenAI-Output`) |
| `sfx/*` | `moss-sfx` | Apache-2.0 |
| `bgm/main` | `ace-step` | MIT |
| `font/main` | `font-catalog` | OFL-1.1 |

게임의 라이선스 매니페스트 [client/generated/licenses.json](client/generated/licenses.json)에 Godot Engine 같은
서드파티 구성 요소와 그 라이선스, 고지문이 있다.
