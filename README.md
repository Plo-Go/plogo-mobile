
# 🏃‍♂️ Plogo iOS Flutter Project

플로깅 기록 웹앱 '플로고'의 모바일 앱 버전
Flutter 기반 iOS 프로젝트

---

## 📦 프로젝트 구조

```
plogo/
├── lib/               # 앱 소스 코드
├── ios/               # iOS scaffold (Flutter 최신 scaffold)
├── pubspec.yaml       # 의존성 및 설정
├── .gitignore         # 빌드, 캐시 제외 설정
```

---

## 🚀 개발 & 빌드 흐름

### Flutter 의존성 설치 (의존성 변경 시)

```bash
flutter pub get
```

### iOS 빌드 & 실행 (항상 Xcode 사용)

```bash
open ios/Runner.xcworkspace
# 이후 Xcode에서 ⌘ + R
```

✅ codesign, build conflict 없이 안정적으로 실행 가능


## 🔧 flutter build ios 사용 금지

- flutter build ios 사용 금지
- flutter build ios는 내부 code signing 설정과 충돌 발생 → Xcode로 빌드하는 것이 가장 안정적


## 📂 Git 관리 규칙

- 커밋 대상: `lib/`, `ios/`, `pubspec.yaml`, `.gitignore`
- 커밋 제외: `build/`, `.dart_tool/`, `Pods/`, `DerivedData/`, `.packages` 등


## 📄 .gitignore 예시

```gitignore
# Flutter/Dart
.dart_tool/
.packages
.pub-cache/
build/
.flutter-plugins
.flutter-plugins-dependencies

# iOS
ios/Flutter/
ios/Pods/
ios/Podfile.lock
DerivedData/

# macOS
*.DS_Store

# IDE
.idea/
.vscode/
```


## 🧹 문제 발생시 클린 빌드

```bash
flutter clean
flutter pub get
cd ios
pod install
cd ..
open ios/Runner.xcworkspace
```


## 🛠 코드사인 설정

- Xcode → Signing & Capabilities → 자동서명 사용
- Team (Apple 계정) 지정


## 💻 M1/M2 팁

- 최신 Flutter 3.x scaffold 기준, 별도 아키텍처 설정 불필요
- cocoapods 업데이트 권장

```bash
sudo gem install cocoapods
pod repo update
```


## 👨‍💻 추가 참고사항

- Flutter SDK 버전: `3.16.x`
- Dart SDK 버전: `3.2.x`
- iOS Deployment Target: `15.0` 이상 권장
- Xcode 15.x 권장

