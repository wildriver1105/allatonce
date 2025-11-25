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
      
      // 기본 설정
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      // 기본값 설정 (선택사항)
      await _remoteConfig!.setDefaults({
        'welcome_message': 'Welcome to AI Marine Care',
        'app_version': '1.0.0',
      });

      // 원격에서 데이터 가져오기 및 활성화
      await _remoteConfig!.fetchAndActivate();
      
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
      await _remoteConfig!.fetchAndActivate();
      print('Remote Config fetched and activated');
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

