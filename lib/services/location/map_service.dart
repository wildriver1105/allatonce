import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 지도 서비스를 관리하는 클래스
class MapService {
  /// 기본 카메라 위치 (서울)
  static const CameraPosition defaultCameraPosition = CameraPosition(
    target: LatLng(37.5665, 126.9780), // 서울시청
    zoom: 14.0,
  );

  /// 마리나 마커 생성
  static Marker createMarinaMarker({
    required String markerId,
    required LatLng position,
    required String title,
    String? snippet,
    VoidCallback? onTap,
  }) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(
        title: title,
        snippet: snippet,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      onTap: onTap != null ? () => onTap() : null,
    );
  }

  /// 사용자 위치 마커 생성
  static Marker createUserLocationMarker({
    required String markerId,
    required LatLng position,
  }) {
    return Marker(
      markerId: MarkerId(markerId),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(
        title: '내 위치',
      ),
    );
  }

  /// 카메라 위치 업데이트
  static CameraPosition updateCameraPosition({
    required LatLng target,
    double zoom = 14.0,
    double tilt = 0.0,
    double bearing = 0.0,
  }) {
    return CameraPosition(
      target: target,
      zoom: zoom,
      tilt: tilt,
      bearing: bearing,
    );
  }

  /// 여러 위치를 포함하는 카메라 위치 계산
  static CameraPosition fitBounds({
    required List<LatLng> positions,
    double padding = 50.0,
  }) {
    if (positions.isEmpty) {
      return defaultCameraPosition;
    }

    if (positions.length == 1) {
      return CameraPosition(
        target: positions.first,
        zoom: 14.0,
      );
    }

    // 경계 계산
    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (var position in positions) {
      minLat = minLat < position.latitude ? minLat : position.latitude;
      maxLat = maxLat > position.latitude ? maxLat : position.latitude;
      minLng = minLng < position.longitude ? minLng : position.longitude;
      maxLng = maxLng > position.longitude ? maxLng : position.longitude;
    }

    // 중심점 계산
    final center = LatLng(
      (minLat + maxLat) / 2,
      (minLng + maxLng) / 2,
    );

    // 줌 레벨 계산 (간단한 근사치)
    final latDiff = maxLat - minLat;
    final lngDiff = maxLng - minLng;
    final maxDiff = latDiff > lngDiff ? latDiff : lngDiff;
    
    double zoom = 14.0;
    if (maxDiff > 0) {
      zoom = 15.0 - (maxDiff * 10);
      if (zoom < 10.0) zoom = 10.0;
      if (zoom > 18.0) zoom = 18.0;
    }

    return CameraPosition(
      target: center,
      zoom: zoom,
    );
  }
}

