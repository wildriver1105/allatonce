# Assets Directory

앱에서 사용하는 이미지, 아이콘, 폰트 등의 리소스 파일들을 관리하는 디렉토리입니다.

## 구조

- `images/`: 이미지 파일들 (PNG, JPG, SVG 등)
- `icons/`: 아이콘 파일들
- `fonts/`: 커스텀 폰트 파일들

## 사용 방법

1. 리소스 파일을 해당 디렉토리에 추가
2. `pubspec.yaml`의 `flutter.assets` 섹션에 경로 등록
3. 앱에서 `AssetImage('assets/images/example.png')` 형태로 사용

