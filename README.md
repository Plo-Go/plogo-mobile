
# 📱 PloGo – 국내 생태관광지 플로깅 코스 추천 앱

홍익대학교 2025학년도 2학기 졸업프로젝트

플로깅 기록 웹앱 '플로고'의 모바일 앱 버전

Flutter 기반 안드로이드 프로젝트 (크로스플랫폼으로 iOS빌드도 지원)


## 주요 기능

🔎 플로깅 코스 추천
- 선호도 기반 추천, 인기/최근 코스 조회

🗺 지도 기반 완주 로그
- Kakao Map 기반, 전국 생태관광지 기록/조회
- 사진·글 업로드

📸 플로깅 코스 검색
- 지역 및 코스명 기반의 코스 검색 및 최근 검색어 불러오기

👤 로그인 & 유저 정보
- 카카오 로그인, 토큰 인증, 최근 활동 불러오기



## 🔧 기술 스택
| 영역                   | 사용 기술                                   |
| -------------------- | --------------------------------------- |
| **Framework**        | Flutter 3.x, Dart                       |
| **State Management** | Riverpod 3.x                            |
| **Networking**       | Dio + Interceptor                       |
| **Routing**          | go_router                               |
| **Map**              | kakao_map_plugin                        |
| **Storage**          | SharedPreferences (최근 검색어 등), 이미지 로컬 캐싱 |
| **Env & Config**     | flutter_dotenv                          |
| **Image / Media**    | image_picker, permission_handler        |
| **Build & Deploy**   | Android APK, iOS Xcode 빌드               |




## 📦 프로젝트 구조

```
plogo/
├── lib/               # 앱 소스 코드
      ├── core/
            ├── api/
            ├── constants/
            └── router/
      ├── features     # 페이지 및 기능별 분리
            ├── auth/
                  ├── models/
                  ├── providers/
                  ├── screens/
                  ├── services/
                  └── widgets/
            ├── detail/
            ├── home/
            ├── log/
            ├── mypage/
            ├── onboarding/
            ├── region/
            └── search/
      ├── layout/
            ├── app_layout.dart
            └── main_layout.dart
      ├── shared
      └── main.dart
├── ios/
├── android/
├── pubspec.yaml       # 의존성 및 설정
├── .gitignore         # 빌드, 캐시 제외 설정
├── .env               # 환경 변수 및 KEY 값
```


## 🚀 개발 & 빌드 흐름

### Flutter 의존성 설치 (의존성 변경 시)

```bash
flutter pub get
```

### 안드로이드 빌드 & 실행

```bash
flutter run
# 또는
flutter build apk
```
- Android Studio 또는 VS Code에서 직접 실행 가능
- APK 파일은 build/app/outputs/flutter-apk/app-release.apk에 생성

### iOS 빌드 & 실행 (항상 Xcode 사용)

```bash
open ios/Runner.xcworkspace
# 이후 Xcode에서 ⌘ + R
```

✅ codesign, build conflict 없이 안정적으로 실행 가능
- flutter build ios 사용 금지
- flutter build ios는 내부 code signing 설정과 충돌 발생 → Xcode로 빌드하는 것이 가장 안정적


## 🧹 문제 발생시 클린 빌드

```bash
flutter clean
flutter pub get
# iOS의 경우
cd ios && pod install && cd ..
open ios/Runner.xcworkspace
```


## 🛠 코드사인 설정

- Xcode → Signing & Capabilities → 자동서명 사용
- Team (Apple 계정) 지정


## 💻 M1/M2 팁

- 최신 Flutter scaffold 기준, 별도 아키텍처 설정 불필요
- cocoapods 업데이트 권장

```bash
sudo gem install cocoapods
pod repo update
```


## 👨‍💻 개발 환경 및 버전 정보

- Flutter SDK 버전: 3.13.x 이상 (권장: 3.16.x)
- Dart SDK 버전: 3.2.x
- Android minSdkVersion: 24
- Android compileSdkVersion: 36
- iOS Deployment Target: 11.0 이상 (권장: 15.0 이상)
- Xcode: 15.x 권장
