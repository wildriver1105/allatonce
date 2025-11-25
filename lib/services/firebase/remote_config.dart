import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  FirebaseRemoteConfig? _remoteConfig;
  bool _isInitialized = false;

  /// Remote Config 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      
      // 기본 설정 (개발 중에는 minimumFetchInterval을 0으로 설정하여 항상 fetch 가능)
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero, // 개발 중에는 0으로 설정
        ),
      );

      // 원격에서 데이터 가져오기 및 활성화
      final bool updated = await _remoteConfig!.fetchAndActivate();
      
      if (updated) {
        print('Remote Config fetched and activated successfully');
      } else {
        print('Remote Config fetched but no changes detected');
      }
      
      _isInitialized = true;
      print('Remote Config initialized successfully');
    } catch (e) {
      print('Error initializing Remote Config: $e');
      _isInitialized = false;
    }
  }

  /// Remote Config 데이터 새로고침
  Future<void> fetchAndActivate() async {
    if (_remoteConfig == null) {
      await initialize();
      return;
    }

    try {
      final bool updated = await _remoteConfig!.fetchAndActivate();
      if (updated) {
        print('Remote Config fetched and activated successfully');
      } else {
        print('Remote Config fetched but no changes detected');
      }
    } catch (e) {
      print('Error fetching Remote Config: $e');
    }
  }

  /// String 값 가져오기
  String getString(String key, {String defaultValue = ''}) {
    if (_remoteConfig == null) {
      print('Remote Config not initialized. Returning default value.');
      return defaultValue;
    }
    return _remoteConfig!.getString(key);
  }

  /// Int 값 가져오기
  int getInt(String key, {int defaultValue = 0}) {
    if (_remoteConfig == null) {
      print('Remote Config not initialized. Returning default value.');
      return defaultValue;
    }
    return _remoteConfig!.getInt(key);
  }

  /// Double 값 가져오기
  double getDouble(String key, {double defaultValue = 0.0}) {
    if (_remoteConfig == null) {
      print('Remote Config not initialized. Returning default value.');
      return defaultValue;
    }
    return _remoteConfig!.getDouble(key);
  }

  /// Bool 값 가져오기
  bool getBool(String key, {bool defaultValue = false}) {
    if (_remoteConfig == null) {
      print('Remote Config not initialized. Returning default value.');
      return defaultValue;
    }
    return _remoteConfig!.getBool(key);
  }

  /// 모든 파라미터 가져오기
  Map<String, dynamic> getAll() {
    if (_remoteConfig == null) {
      print('Remote Config not initialized. Returning empty map.');
      return {};
    }
    return _remoteConfig!.getAll();
  }

  /// 초기화 상태 확인
  bool get isInitialized => _isInitialized;
}

