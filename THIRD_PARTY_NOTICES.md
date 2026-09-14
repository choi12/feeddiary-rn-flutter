# Third-party notices — 에셋 출처와 라이선스

이 저장소의 **코드**는 루트 [`LICENSE`](LICENSE)(MIT)를 따릅니다. 아래 **에셋**(폰트 · 아이콘 폰트 · 이미지 · Lottie)은 MIT 적용 대상이 아니며 각 원저작자의 라이선스를 따릅니다. 이 저장소를 포크하거나 에셋을 따로 꺼내 쓸 때는 원 라이선스를 확인하세요.

## 폰트

| 파일 | 위치 | 저작자 | 라이선스 |
|---|---|---|---|
| `Ownglyph_PDH-Rg.ttf` (온글잎 박다현체) | `flutter/assets/fonts/` · `rn/assets/fonts/` · `rn/android/app/src/main/assets/fonts/` | © 2023 VoyagerX, inc. & Dahyeon Park | 온글잎 무료 배포 폰트. 개인·상업 이용 가능, 파일 수정 금지(폰트 내 고지). 온글잎 서비스가 2023-07 종료돼 재배포 조건 원문을 확인할 수 없어 **원저작자 권리를 유보**합니다 |
| `Dovemayo_gothic.ttf` (둘기마요 고딕) | 위와 같은 세 곳 | © 2023 둘기마요 | 저자 배포 공지 「판매를 제외한 모든 것이 가능합니다. 개인 및 상업용 사용 허용」([공지](https://x.com/oters1225/status/1621264594034659328)) |

## 아이콘 폰트

`react-native-vector-icons` 배포본의 폰트 파일을 복사해 번들했습니다. 라이선스는 해당 패키지 README 의 표기를 따릅니다.

| 파일 | 위치 | 라이선스 |
|---|---|---|
| `AntDesign.ttf` | RN 두 곳 · `flutter/assets/fonts/icons/` | MIT |
| `Entypo.ttf` | RN 두 곳 · `flutter/assets/fonts/icons/` | CC BY-SA 4.0 (Daniel Bruce) |
| `EvilIcons.ttf` | RN 두 곳 | MIT |
| `Feather.ttf` | RN 두 곳 · `flutter/assets/fonts/icons/` | MIT |
| `FontAwesome.ttf` | RN 두 곳 · `flutter/assets/fonts/icons/` | SIL OFL 1.1 (폰트) |
| `FontAwesome5_*.ttf` · `FontAwesome6_*.ttf` (Free) | RN 두 곳 · `FontAwesome5_Solid.ttf` 는 Flutter 도 | 폰트 SIL OFL 1.1 · 아이콘 CC BY 4.0 |
| `Fontisto.ttf` | RN 두 곳 | MIT |
| `Foundation.ttf` | RN 두 곳 | MIT |
| `Ionicons.ttf` | RN 두 곳 · `flutter/assets/fonts/icons/` | MIT |
| `MaterialCommunityIcons.ttf` | RN 두 곳 · `flutter/assets/fonts/icons/` | Apache 2.0 (Pictogrammers) |
| `MaterialIcons.ttf` | RN 두 곳 | Apache 2.0 (Google) |
| `Octicons.ttf` | RN 두 곳 · `flutter/assets/fonts/icons/` | MIT (GitHub) |
| `SimpleLineIcons.ttf` · `Zocial.ttf` | RN 두 곳 | MIT |

「RN 두 곳」은 `rn/assets/fonts/` 와 `rn/android/app/src/main/assets/fonts/` 입니다.

## 이미지

- **캐릭터 · 감정 스티커 · 날씨 아이콘** — `flutter/assets/images/character/`(36) · `flutter/assets/images/sticker/`(27) · `rn/src/assets/images/profile/character/`(36) · `rn/src/assets/images/diary/sticker/`(18) · `rn/src/assets/images/diary/weather/`(9).
  Designed by [Freepik](https://www.freepik.com) — Freepik 무료 라이선스(출처 표기 필수). 재배포가 금지되는 편집 원본(AI·PSD·EPS·SVG)은 이 저장소에 없고, 앱에 그대로 쓰이는 512px PNG 렌더본만 담았습니다. 원저작자 권리를 유보합니다.
- 그 밖의 이미지(마스코트 「레모니」, 로고, 앱 아이콘, 스플래시, 화면 일러스트 `home/` · `letter/` · `signin/` · `profile/` · `diary/` 의 나머지)와 README 의 스크린샷·데모 GIF(`assets/readme/`)는 새싹일기 프로젝트에서 제작했습니다.

## Lottie

`birds.json` · `heart.json` · `heart_baloon.json` · `heart_green.json` · `rain.json` (`flutter/assets/lottie/` · `rn/src/assets/lottie/`) — 애니메이션 파일에 저작자 정보가 없고 다운로드 출처를 확인하지 못했습니다. 원저작자 권리를 유보합니다.

## 오픈소스 패키지

npm · pub 의존성의 라이선스는 앱 설정 화면의 라이선스 목록(`rn/src/screens/home/setting/License/data.ts` · `flutter/lib/ui/features/setting/license_data.dart`)과 각 패키지의 LICENSE 를 따릅니다. 위 폰트·아이콘·이미지의 출처 표기도 같은 화면에 실려 있습니다.
