import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'home/home_screen.dart';
import 'chat/chatroom.dart';
import 'marina/marinaMain.dart';
import 'profile/myProfile.dart';
// import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  String selectedModel = '';

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void setSelectedModel(String model) {
    setState(() {
      selectedModel = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        setScreen: setSelectedIndex,
        onModelSelected: setSelectedModel,
      ),
      ChatScreen(modelName: selectedModel),
      const MarinaServiceScreen(),
      const ProfileScreen(),
      // const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          // Settings 탭이 비활성화되어 있으므로 인덱스 2는 무시
          if (index < screens.length) {
            setSelectedIndex(index);
          }
        },
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.dock),
          //   label: '마리나',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: '프로필',
          // ),
        ],
      ),
    );
  }
}
