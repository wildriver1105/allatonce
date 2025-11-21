import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// 위치 서비스를 관리하는 클래스
class LocationService {
  /// 위치 권한 요청
  static Future<bool> requestPermission() async {
    final status = await ph.Permission.location.request();
    return status.isGranted;
  }

  /// 위치 권한 확인
  static Future<bool> checkPermission() async {
    final status = await ph.Permission.location.status;
    return status.isGranted;
  }

  /// 현재 위치 가져오기
  static Future<Position?> getCurrentLocation() async {
    try {
      // 위치 서비스 활성화 확인
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // 위치 서비스가 비활성화되어 있음
        return null;
      }

      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // 권한이 거부됨
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // 권한이 영구적으로 거부됨
        return null;
      }

      // 현재 위치 가져오기
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  /// 위치 스트림 구독 (실시간 위치 업데이트)
  static Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10미터마다 업데이트
      ),
    );
  }

  /// 두 위치 간 거리 계산 (미터 단위)
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// 위치 서비스 설정 열기
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// 앱 설정 열기
  static Future<bool> openAppSettings() async {
    return await ph.openAppSettings();
  }
}

