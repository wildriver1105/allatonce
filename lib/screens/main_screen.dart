import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

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
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setSelectedIndex(index);
        },
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
