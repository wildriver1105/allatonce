import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '프로필',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // 프로필 이미지 및 기본 정보
              _buildProfileHeader(),
              const SizedBox(height: 32),
              // 메뉴 리스트
              _buildMenuSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        // 프로필 이미지
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.1),
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
          ),
          child: Icon(
            Icons.person,
            size: 60,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        // 이름
        const Text(
          '사용자',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // 이메일
        Text(
          'user@example.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        // 편집 버튼
        OutlinedButton.icon(
          onPressed: () {
            // 프로필 편집 기능
          },
          icon: const Icon(Icons.edit),
          label: const Text('프로필 편집'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuTile(
          icon: Icons.person_outline,
          title: '내 정보',
          onTap: () {
            // 내 정보 화면으로 이동
          },
        ),
        _buildMenuTile(
          icon: Icons.bookmark_outline,
          title: '내 예약',
          onTap: () {
            // 내 예약 화면으로 이동
          },
        ),
        _buildMenuTile(
          icon: Icons.history,
          title: '이용 내역',
          onTap: () {
            // 이용 내역 화면으로 이동
          },
        ),
        _buildMenuTile(
          icon: Icons.favorite_outline,
          title: '즐겨찾기',
          onTap: () {
            // 즐겨찾기 화면으로 이동
          },
        ),
        const Divider(height: 32),
        _buildMenuTile(
          icon: Icons.notifications_none,
          title: '알림 설정',
          onTap: () {
            // 알림 설정 화면으로 이동
          },
        ),
        _buildMenuTile(
          icon: Icons.lock_outline,
          title: '보안',
          onTap: () {
            // 보안 설정 화면으로 이동
          },
        ),
        _buildMenuTile(
          icon: Icons.help_outline,
          title: '도움말',
          onTap: () {
            // 도움말 화면으로 이동
          },
        ),
        _buildMenuTile(
          icon: Icons.info_outline,
          title: '앱 정보',
          onTap: () {
            // 앱 정보 화면으로 이동
          },
        ),
        const Divider(height: 32),
        _buildMenuTile(
          icon: Icons.logout,
          title: '로그아웃',
          titleColor: Colors.red,
          onTap: () {
            // 로그아웃 기능
            _showLogoutDialog();
          },
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: titleColor ?? AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // 로그아웃 처리
            },
            child: const Text(
              '로그아웃',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

