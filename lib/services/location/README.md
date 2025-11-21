# Location Service

위치 기반 지도 서비스를 관리하는 디렉토리입니다.

## 구조

- `location_service.dart`: 위치 권한 및 현재 위치 관리
- `map_service.dart`: Google Maps 관련 유틸리티 함수

## 사용 방법

### 1. 위치 권한 요청
```dart
final hasPermission = await LocationService.requestPermission();
```

### 2. 현재 위치 가져오기
```dart
final position = await LocationService.getCurrentLocation();
if (position != null) {
  print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
}
```

### 3. Google Maps 사용
```dart
GoogleMap(
  initialCameraPosition: MapService.defaultCameraPosition,
  markers: {
    MapService.createMarinaMarker(
      markerId: 'marina1',
      position: LatLng(37.5665, 126.9780),
      title: '제주 마리나',
    ),
  },
)
```

## 설정 필요 사항

1. **Google Maps API 키 발급**
   - [Google Cloud Console](https://console.cloud.google.com/)에서 API 키 발급
   - Android: `android/app/src/main/AndroidManifest.xml`의 `YOUR_GOOGLE_MAPS_API_KEY` 교체
   - iOS: `ios/Runner/AppDelegate.swift`의 `YOUR_GOOGLE_MAPS_API_KEY` 교체

2. **패키지 설치**
   ```bash
   flutter pub get
   ```

3. **iOS 설정**
   - `ios/Podfile`에 Google Maps SDK가 자동으로 추가됩니다.
   - `pod install` 실행 필요

