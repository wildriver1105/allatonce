import 'package:allatonce/screens/chat/chatroomList.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'home/home.dart';
import 'voyage/voyage_main.dart';
import 'community/community_main.dart';
import 'profile/myProfile.dart';

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
      const VoyageScreen(),
      const CommunityScreen(),
      ChatroomListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
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
            icon: Icon(Icons.explore),
            label: 'Voyage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
