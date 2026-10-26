# open-game-works-game-block-stack

[English](README.md)

**블록 스택**(`Block Stack`)은 Ketchapp의 Stack 스타일의 macOS용 원탭 블록 쌓기 게임으로, 좌우로 움직이는 블록을 탑 위에
떨어뜨리면 삐져나온 부분이 잘려 나가고, 딱 맞게 떨어뜨리면 폭이 그대로 유지된다. AI 에이전트가
[open-game-works](https://github.com/wnsrn3436/open-game-works-core)로 만들었다.

<p align="center"><img src=".github/media/block-stack.gif" alt="block-stack gameplay" width="640"></p>

## 현재 상태

한 문단짜리 요청으로 open-game-works의 `create game` 루프를 3번 돌려 만들었고, 개발 중에 macOS에서 플레이하며
확인했다. 루프는 반복 한도에서 멈췄고, 아직 열려 있는 결함은 루프 종료 기록(`records/loops/create-1792989369596/end.md`)에
있다. 출시용 빌드는 아직 하지 않았다. `build` 명령을 아직 돌리지 않았다.

## 어떤 게임인가

블록이 탑 위에서 좌우로 움직인다. 한 번 클릭해 떨어뜨리면 아래 블록 밖으로 삐져나온 부분이 잘려 떨어지고, 다음 블록은
그만큼 좁아진다. 아래 블록에 딱 맞게 떨어뜨리면 퍼펙트다. 블록 폭이 그대로 유지되고 연속 보너스가 붙으며, 세 번
연속 퍼펙트부터는 블록이 다시 넓어진다. 블록을 하나 쌓을 때마다 움직이는 속도가 빨라진다. 블록이 탑을 완전히
벗어나면 한 판이 끝난다.

이 게임은 하네스에 준 한 문단짜리 요청에서 시작했다. `brief.md`의 `## request`에 그 요청과, 요청에 없어서 콘텐츠
에이전트가 정한 항목이 있다. 레퍼런스 게임(Stack)과 연출 기준 게임(Royal Match)은 `setup game`에서 사람이 골랐다.

| | |
|---|---|
| 플레이어 | 1인 |
| 플랫폼 | macOS (`settings.json` `buildPlatforms`) |
| 입력 | 마우스, 키보드, 게임패드 |
| 화면 | 가로, 기준 해상도 1920x1080 |
| 언어 | 영어 |
| 클라이언트 / 서버 | Godot / TypeScript |
| core 버전 | `0.4.0` (`settings.json` `coreVersion`) |

### 한 판의 흐름

1. 로비: 게임 이름, 기록 줄(첫 판 전에는 `Stack your first tower`, 그 뒤로는 `Runs n · Best streak n`), 최고 점수
   패널, `Options`, 데모 탑, 큰 `Play` 버튼이 있다.
2. 시작: 서버가 판을 여는 동안 `Getting ready`가 보이고, 첫 블록이 받침 위로 왼쪽에서 들어온다. 첫 판에는 화면
   아래에 떨어뜨리는 법을 알려 주는 안내가 나온다.
3. 떨어뜨리기: 쌓은 블록마다 1점이다. 블록은 떨어뜨릴 때마다 반대쪽에서 들어오고, 움직이는 속도는 700에서 블록마다
   20씩 빨라져 1700까지 오른다(`data/system/game_setting.csv`).
4. 퍼펙트: 아래 블록과 12 이내로 맞으면 폭이 그대로 유지되고, 연속 횟수만큼 보너스가 붙는다(연속 첫 퍼펙트 +1, 두
   번째 +2, 최대 +5). 세 번 연속 퍼펙트부터는 블록이 24씩, 시작 폭 440까지 다시 넓어진다. 점수 아래에
   `Perfect ×n`이 보인다.
5. 실패: 아래 블록에 전혀 닿지 않게 떨어뜨리면 한 판이 끝난다. 블록이 빨간 플래시와 함께 탑에서 떨어지고, 약 1초 뒤
   결과 패널이 열린다. `New best!` 또는 `Tower fell`, 올라가며 세어지는 점수, `Best`, `Perfect drops`,
   `Best streak`가 나온다. 처음 포커스가 가 있는 `Play again`을 누르면 바로 다음 판이 시작된다.

일시 정지 팝업(`Resume`, `End run`)을 열면 게임 시간이 멈춘다. 새 플레이어는 로비 전에 약관 팝업을 한 번 본다. 판과
판 사이에 남는 것은 최고 점수, 최고 연속 퍼펙트, 판 수, 쌓은 블록 총수뿐이다. 보석, 코인, 스킨, 해금, 광고, 결제,
실패 후 이어하기는 없다.

### 조작

| 입력 | 동작 |
|---|---|
| 플레이 영역 왼쪽 클릭, `Space`, 게임패드 `A` | 움직이는 블록 떨어뜨리기 |
| `P`, `Esc`, 게임패드 `Start` 또는 `B` | 판 진행 중 일시 정지 |
| 마우스 클릭, `Enter` | UI 버튼 누르기 (`Enter`는 포커스된 버튼) |

### 그래픽과 소리

부드러운 그라데이션과 은은한 베벨의 밝은 플랫 2D다. 하늘은 연한 하늘색(`#8FD8F8`)에서 짙은 파랑(`#3F7FD9`)으로
이어지고, 탑이 높아질수록 해 질 녘과 밤 색으로 어두워진다. 블록 색은 블록마다 한 단계씩 코랄(`#FF7A59`), 해바라기
노랑(`#FFC94A`), 민트(`#3DDC97`), 라일락(`#9B8CFF`)을 거쳐 섞인다. 패널은 크림색 테두리의 남색(`#1E2A4A`)이고, 주요
버튼은 금색(`#FFB627`)이다. 블록이 놓이면 살짝 눌리고 잘린 조각은 돌며 떨어진다. 퍼펙트에는 흰 빛, 고리, 화면
플래시가, 실패에는 빨간 플래시가 붙는다. 블록이 놓일 때와 버튼을 누를 때는 부드러운 나무 소리, 퍼펙트에는 맑은
유리 차임, 실패에는 휙 하는 소리와 둔탁한 소리가 난다. 로비와 판 진행 중에는 잔잔한 로파이 마림바 루프가 흐른다.

## 동작 방식

탑은 클라이언트가 돌리고, 기록은 서버가 보관한다.

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

- `verify_run`은 판을 다시 계산하지 않고 상한만 확인한다. 블록 수는 판 진행 시간 동안 150ms마다 하나보다 많을 수
  없고, 점수는 블록 수 이상이면서 블록 수에 퍼펙트마다 5를 더한 값 이하여야 하며, 퍼펙트는 블록 수 이하, 최고 연속
  퍼펙트는 퍼펙트 수 이하여야 한다. `apply_run`은 판 수를 하나 더하고 최고 점수와 최고 연속 퍼펙트를 더 큰 값으로
  남긴다.
- 게임플레이 값(블록 크기, 움직이는 범위와 속도, 퍼펙트 허용 범위, 다시 넓어지는 양, 보너스 상한, 대기 시간)은 코드
  속 상수가 아니라 `data/system/game_setting.csv`의 행이다.
- 게임이 따로 정의한 요청은 없다. `contract/service.proto`에는 `PlaySessionResult`만 있고,
  `contract/user_state.proto`에는 `RecordUserState`가 있다.
- 게임이 고른 core 모듈(`settings.json` `coreModules`): 클라이언트 `TweenCore`, `ScreenEffectCore`, `InputCore`,
  `SoundCore`, `NativeUiCore`, 서버 `play-session`.

## open-game-works로 제작

[open-game-works](https://github.com/wnsrn3436/open-game-works-core)는 AI 에이전트가 서버-클라이언트 게임을 만드는
하네스다. 여러 게임이 되풀이하는 기능은 core로 미리 만들어 두고, 에이전트는 게임플레이만 content code로 쓴다. 게임은
루프를 돌며 만든다. 콘텐츠 에이전트가 고치고, 플레이 에이전트가 인스턴스를 실제 입력으로 플레이하고, 판정 에이전트가
그 인스턴스를 기준 게임과 비교하고 레퍼런스 게임의 플레이 영상과도 비교하며, 하네스 도구가 저지 결과와 자동 검사로
성공을 판정한다. 최종 리소스는 리소스 서브 에이전트가, 번역은 번역 서브 에이전트가 만든다.

이 게임은 `create game` 루프 한 번(반복 3번)으로 만들었고, `setup game`부터 main 병합까지 약 1시간 40분이
걸렸다(`records/loops/create-1792989369596/`).

| 반복 | 한 일 |
|---|---|
| 1 | 콘텐츠 에이전트가 브리프, 디자인 문서, 데이터, contract, 서버 훅, 장면과 프리팹을 쓰고 최종 리소스를 요청했다. UI 품질을 뺀 모든 검사를 통과했고, 판정 에이전트는 연출이 레퍼런스 게임보다 못하다고 판정했다 |
| 2 | 콘텐츠 에이전트가 결함 15개 중 12개를 고쳤고, 리소스 에이전트가 최종 그림과 소리를 만들었다. 트윈 프리셋 값이 범위를 벗어나 봇 플레이테스트가 멈춰서, 이 반복은 플레이와 판정을 하지 않았다 |
| 3 | 최종 리소스가 모두 들어간 상태에서 UI 품질을 뺀 모든 검사를 통과했다. 판정 에이전트는 퍼펙트 허용 범위가 더 넓었던 반복 1보다 못하다고 판정했다 |

루프는 반복 1의 커밋에, 그 뒤에 만들어진 최종 리소스를 더해 main에 병합했다. 에이전트가 쓴 content code는 약
2,300줄(GDScript와 TypeScript)이고, 그 아래의 미리 만든 core는 약 106,000줄이다.

`client/core/`와 `server/core/`는
[core 릴리스 v0.4.0](https://github.com/wnsrn3436/open-game-works-core-impl/releases/tag/v0.4.0)의 사본이고, 엔진
버전도 그 릴리스가 정한다(Godot 4.7.2). `update game`은 시작할 때 `coreVersion`을 이 게임이 쓸 수 있는 가장 새로운
core 릴리스로 올린다.

| 저장소 | 내용 |
|---|---|
| [open-game-works-core](https://github.com/wnsrn3436/open-game-works-core) | 하네스: 에이전트 규칙, 스킬, 모듈 스펙, CLI `ogw` |
| [open-game-works-core-impl](https://github.com/wnsrn3436/open-game-works-core-impl) | core 구현. core 릴리스는 이 저장소의 GitHub Releases |
| open-game-works-game-block-stack | 이 게임 |

## 저장소 구성

| 경로 | 내용 |
|---|---|
| `brief.md` | 브리프: 플레이어 판타지, 감정, 기억에 남을 순간, 장르 관습, 금지 사항, 실패 페널티, 예측, 레퍼런스 게임, 요청과 콘텐츠 에이전트가 정한 항목 |
| `design.md` | 디자인 문서: 코어 루프, 조작, 화면, 시스템(탑, 점수, 판과 기록), 감각과 튜닝 목표, 아트와 오디오 방향, 용어, core 사용 |
| `play-guide.md` | 플레이 에이전트와 판정 에이전트가 받는 플레이 가이드: 목표, 조작, 게임 흐름, 실패, 입력 잠금 구간, 가장 빠른 시작 경로, 장면별 플레이 모드 |
| `settings.json` | 게임 설정: core 버전, 엔진, core 모듈, 빌드 플랫폼, 언어, 해상도, 환경별 값, 약관 문서, core 설정 재정의 |
| `contract/` | contract(protobuf): `service.proto`, `user_state.proto`, `error.proto` |
| `data/` | CSV 테이블(`tables/`), 시스템 테이블(`system/`, `game_setting.csv` 포함), 번역(`translations/`), 용어집(`glossary.csv`), enum과 invariant |
| `resource/` | 리소스 키별 리소스: 앱 아이콘, 스플래시, 폰트, UI 키트, 하늘, 블록과 UI 테두리, 왕관 아이콘, BGM, 효과음, 장면, 프리팹, 트윈 프리셋. `resources.csv`에 모든 리소스 키와, 생성하거나 카탈로그에서 가져온 리소스의 제작 방법과 라이선스(폰트는 출처도)가 있음 |
| `client/` | Godot 프로젝트. content code는 `boot/`, `common/`, `features/`(`title`, `lobby`, `play`), 회귀 테스트는 `tests/`, DEV 코드는 `dev/`(봇 플레이테스트 시나리오 `dev/bot/scenario.json`). `core/`와 `generated/`는 하네스 도구가 씀. `resource`는 `../resource`로의 링크 |
| `server/` | TypeScript 서버. `main.ts`가 `hooks/play_session.ts`의 훅을 등록, 회귀 테스트는 `tests/`, DEV 코드는 `dev/`. `core/`와 `generated/`는 하네스 도구가 씀 |
| `records/` | 에이전트와 도구가 쓰는 작업 기록: 셋업 기록(`setup/`), 루프 기록(`loops/create-1792989369596/`: 요청, 콘텐츠 보고서, 검사 결과, 플레이 피드백, 판정 결과, 결함, 반복 기록, 종료 기록), core 제안(`core-proposals/`) |
| `LICENSE`, `LICENSES/` | 라이선스 전문 |

`id-registry` 브랜치에는 ID 레지스트리(`id_registry.json`)만 있다. 이 브랜치에는 데이터 도구만 쓰고, 다른 브랜치와
병합하지 않는다. 빌드 결과물(`builds/`), 데이터 바이너리(`client/build/`, `server/build/`), 캡처, 루프 증거 자료는
커밋하지 않는다.

### 언어

원문은 영어다. `settings.json`에 `sourceLanguage`가 없으므로 기본값 `en`이 적용되고, `supportedLanguages`는 `en`
하나다. 게임 텍스트는 `data/translations/en.csv`에 있고, 게임 제목 같은 이름은 `data/glossary.csv`가 고정한다.

## 요구 사항

- 하네스 [README](https://github.com/wnsrn3436/open-game-works-core)대로 하네스를 준비한 open-game-works 작업 공간
  (Node 24 이상, Git, GitHub CLI, buildx가 있는 Docker, uv와 Python, Claude Code 또는 Codex)
- Godot 4.7.2. 이 게임이 고정한 core 릴리스가 정한 엔진 버전이고, `update env`가 `<workspace>/.ogw/`에 설치한다
- macOS 앱을 빌드하려면 Xcode 27(core 릴리스 0.4.0의 `engine.json`이 지정)이 있는 Apple silicon Mac이 필요하다.
  macOS는 이 게임의 유일한 빌드 플랫폼이다
- Windows: `client/resource`는 심볼릭 링크다. 클론하기 전에 개발자 모드를 켜고
  `git config --global core.symlinks true`를 실행해야 한다. 그러지 않으면 링크가 일반 텍스트 파일로 체크아웃된다.
  플레이 에이전트와 판정 에이전트는 macOS와 Linux에서만 실행되므로, Windows에서는 루프와 빌드를 돌릴 수 없다

## 설치

작업 공간의 `games/` 아래에 저장소를 클론하고, 원격 브랜치에서 로컬 `id-registry` 브랜치를 만든다. 클론하면 로컬
브랜치는 `main`만 생기는데, 데이터 도구는 로컬 `id-registry` 브랜치에서 ID 레지스트리를 읽는다.

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

폴더 이름이 명령에서 쓰는 게임 이름이다. 그다음 `open-game-works-core/`에서 Claude Code나 Codex를 열고
`update env`를 실행한다. 이 명령은 이 게임의 빌드 도구를 확인하고 core 버전에 맞는 엔진을 설치한다.

### 레퍼런스 게임 영상

`records/setup/reference/reference.md`에는 `setup game`에서 사람이 고른 레퍼런스 게임(Stack)과 연출 기준
게임(Royal Match), 그 플레이 영상의 출처 URL, 판정 에이전트가 비교하는 영상 속 순간이 기록되어 있다. 영상 파일은
저장소에 없지만(`.gitignore`가 `records/setup/reference/`에서 `reference.md`를 뺀 모든 파일을 제외) `update game`의
판정 에이전트에게 필요하다. 루프를 돌리기 전에 `open-game-works-core/`에서 다음 명령으로 영상마다 받아 온다
(`yt-dlp` 필요).

```sh
tools/bin/ogw game reference open-game-works-game-block-stack <reference.md의 YouTube URL>
```

영상은 `records/setup/reference/`에 `<video id>.mp4`로 저장되고, 이 이름이 `reference.md`의 `## video`에 적힌 이름이다.

## 사용법

`open-game-works-core/`에서 연 Claude Code나 Codex 세션에 아래 명령을 준다. 명령을 받은 에이전트가 끝까지 진행하고
결과를 보고한다.

| 명령 | 하는 일 |
|---|---|
| `update game: open-game-works-game-block-stack <request>` | 루프로 게임을 고친다. 요청은 사람의 피드백이나 고칠 PROD 문제다. 루프가 멈추면, 그사이 main이 바뀌지 않았을 때 도구가 고른 커밋을 main에 병합하고 루프 종료 기록으로 보고한다 |
| `build: open-game-works-game-block-stack DEV` | 서버와 클라이언트 content code를 하드닝하고, PostgreSQL로 검사를 다시 돌리고, macOS 앱을 `builds/`에 빌드하고, 커밋에 `dev-<version>` 태그를 붙이고, DEV 서버를 배포한다. `--version`이 없으면 첫 빌드는 `0.1.0`이다 |

STG와 PROD 빌드는 서명된 결과물까지 만든다. STG는 서버도 배포하고, PROD 배포는 사람이 한다.

### 인스턴스 실행

인스턴스는 게임을 개발용으로 실행한 것으로, 자기 DB를 가진 로컬 서버 하나와 화면을 그리는 클라이언트로 이루어진다.
`ogw`는 하네스 저장소의 `tools/bin/ogw`이고, `open-game-works-core/`에서 실행한다.

```sh
tools/bin/ogw instance start open-game-works-game-block-stack   # 인스턴스 id와 주소를 출력
tools/bin/ogw instance stop <id>
```

클라이언트는 개발용 계정으로 로그인하고 약관 팝업 없이 시작한다. `--db postgresql`을 주지 않으면 DB는 SQLite이고,
`--commit <sha>`를 주면 다른 커밋으로 인스턴스를 시작한다. `ogw capture <id>`는 화면을 캡처하고, `ogw log <id>`는
오류 로그를 보여 주고, `ogw command <id> list_commands`는 게임의 content command 목록을 보여 준다.

### 첫 DEV 빌드 전에

`settings.json`에는 아직 빌드 단계 값(서버 URL, 배포 호스트, 서명, CDN, 서버 이미지)이 없다. 첫 `build`의 리드
에이전트가 이 값을 묻는다. `settings.json`에는 시크릿 이름만 있고, 값은 호스트의 시크릿 저장소에 넣는다. 생성할 수
있는 값은 `tools/bin/ogw secret generate open-game-works-game-block-stack DEV`로, 나머지는
`tools/bin/ogw secret set open-game-works-game-block-stack <DEV|signing> <name>`으로 넣는다. `secret set`은 값을
표준 입력으로 받는다.

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
