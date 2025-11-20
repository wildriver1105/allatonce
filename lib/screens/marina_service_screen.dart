import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'berth_reservation_screen.dart';

class MarinaServiceScreen extends StatefulWidget {
  const MarinaServiceScreen({super.key});

  @override
  State<MarinaServiceScreen> createState() => _MarinaServiceScreenState();
}

class _MarinaServiceScreenState extends State<MarinaServiceScreen> {
  final List<Map<String, dynamic>> _nearbyMarinas = [
    {
      'name': '제주 마리나',
      'location': '제주시',
      'image': Icons.sailing,
    },
    {
      'name': '부산 마리나',
      'location': '부산시',
      'image': Icons.sailing,
    },
    {
      'name': '인천 마리나',
      'location': '인천시',
      'image': Icons.sailing,
    },
    {
      'name': '여수 마리나',
      'location': '여수시',
      'image': Icons.sailing,
    },
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'icon': Icons.dock,
      'title': '부두 예약',
      'description': '마리나 부두 예약 및 관리',
      'onTap': (BuildContext context) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BerthReservationScreen(),
          ),
        );
      },
    },
    {
      'icon': Icons.local_gas_station,
      'title': '연료 주유',
      'description': '연료 주유 서비스 예약',
      'onTap': (BuildContext context) {
        // 연료 주유 기능 구현
      },
    },
    {
      'icon': Icons.cleaning_services,
      'title': '청소 서비스',
      'description': '보트 청소 및 유지보수',
      'onTap': (BuildContext context) {
        // 청소 서비스 기능 구현
      },
    },
    {
      'icon': Icons.restaurant,
      'title': '레스토랑',
      'description': '마리나 레스토랑 정보 및 예약',
      'onTap': (BuildContext context) {
        // 레스토랑 기능 구현
      },
    },
    {
      'icon': Icons.hotel,
      'title': '숙박 시설',
      'description': '마리나 근처 숙박 시설 정보',
      'onTap': (BuildContext context) {
        // 숙박 시설 기능 구현
      },
    },
    {
      'icon': Icons.build,
      'title': '수리 서비스',
      'description': '보트 수리 및 정비 서비스',
      'onTap': (BuildContext context) {
        // 수리 서비스 기능 구현
      },
    },
    {
      'icon': Icons.people,
      'title': '세일러 매칭',
      'description': '함께 항해할 세일러 찾기',
      'onTap': (BuildContext context) {
        // 세일러 매칭 기능 구현
      },
    },
    {
      'icon': Icons.school,
      'title': '교육 찾는 서비스',
      'description': '요트 및 항해 교육 프로그램 찾기',
      'onTap': (BuildContext context) {
        // 교육 찾는 서비스 기능 구현
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더 섹션
            SliverToBoxAdapter(
              child: _buildHeaderSection(),
            ),
            // 검색창
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
            // 근처 마리나 섹션
            SliverToBoxAdapter(
              child: _buildNearbyMarinasSection(),
            ),
            // 서비스 그리드 섹션
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = _services[index];
                    return _buildServiceCard(
                      icon: service['icon'] as IconData,
                      title: service['title'] as String,
                      description: service['description'] as String,
                      onTap: () => (service['onTap'] as Function(BuildContext))(context),
                    );
                  },
                  childCount: _services.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.7),
          ],
        ),
        image: DecorationImage(
          image: const AssetImage('assets/images/marina_background.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.primary.withOpacity(0.6),
            BlendMode.overlay,
          ),
          onError: (exception, stackTrace) {
            // 이미지가 없으면 그라데이션만 사용
          },
        ),
      ),
      child: Stack(
        children: [
          // 배경 패턴 (임시로 아이콘 사용)
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.sailing,
                size: 200,
                color: Colors.white,
              ),
            ),
          ),
          // 콘텐츠
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Welcome to\nMarina Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '도시, 마리나 이름 또는 코드 검색',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyMarinasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Text(
            '근처 마리나',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: _nearbyMarinas.length,
            itemBuilder: (context, index) {
              final marina = _nearbyMarinas[index];
              return _buildMarinaCard(
                name: marina['name'] as String,
                location: marina['location'] as String,
                icon: marina['image'] as IconData,
                onTap: () {
                  // 마리나 상세 화면으로 이동
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMarinaCard({
    required String name,
    required String location,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 배경 패턴
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Icon(
                  icon,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            ),
            // 콘텐츠
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

