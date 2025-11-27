import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/main_screen.dart';
import 'constants/colors.dart';
import 'screens/dummy_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/firebase/remote_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isDummy = false;
  
  // try {
  //   await dotenv.load(fileName: ".env");
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
    
  //   // Remote Config 초기화
  //   await RemoteConfigService().initialize();
    
  //   // Remote Config 데이터 가져오기 예시
  //   final remoteConfig = RemoteConfigService();
  //   final welcomeMessage = remoteConfig.getString('welcome_message');
  //   final appVersion = remoteConfig.getString('app_version');
  //   isDummy = remoteConfig.getBool('dummy');
    
  //   print('Remote Config - Welcome Message: $welcomeMessage');
  //   print('Remote Config - App Version: $appVersion');
  //   print('Remote Config - Dummy: $isDummy');
  // } catch (e) {
  //   print('Warning: Could not load .env file or initialize Firebase: $e');
  // }
  runApp(MyApp(isDummy: isDummy));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDummy});
  final bool isDummy;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
    );
  }
}
