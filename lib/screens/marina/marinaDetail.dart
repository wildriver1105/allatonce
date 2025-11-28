import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../reservation.dart';

class MarinaDetailScreen extends StatefulWidget {
  final String marinaName;
  final String location;

  const MarinaDetailScreen({
    super.key,
    required this.marinaName,
    required this.location,
  });

  @override
  State<MarinaDetailScreen> createState() => _MarinaDetailScreenState();
}

class _MarinaDetailScreenState extends State<MarinaDetailScreen> {
  final List<Map<String, dynamic>> _services = [
    {
      'icon': Icons.dock,
      'title': '부두 예약',
      'description': '마리나 부두 예약 및 관리',
      'color': const Color(0xFF008489),
    },
    {
      'icon': Icons.local_gas_station,
      'title': '연료 주유',
      'description': '연료 주유 서비스 예약',
      'color': const Color(0xFFFF6B6B),
    },
    {
      'icon': Icons.cleaning_services,
      'title': '청소 서비스',
      'description': '보트 청소 및 유지보수',
      'color': const Color(0xFF4ECDC4),
    },
    {
      'icon': Icons.restaurant,
      'title': '레스토랑',
      'description': '마리나 레스토랑 정보 및 예약',
      'color': const Color(0xFFFFBE0B),
    },
    {
      'icon': Icons.hotel,
      'title': '숙박 시설',
      'description': '마리나 근처 숙박 시설 정보',
      'color': const Color(0xFF9B59B6),
    },
    {
      'icon': Icons.build,
      'title': '수리 서비스',
      'description': '보트 수리 및 정비 서비스',
      'color': const Color(0xFF3498DB),
    },
    {
      'icon': Icons.people,
      'title': '세일러 매칭',
      'description': '함께 항해할 세일러 찾기',
      'color': const Color(0xFFE91E63),
    },
    {
      'icon': Icons.school,
      'title': '아카데미',
      'description': '요트 및 항해 교육 프로그램',
      'color': const Color(0xFF2ECC71),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 헤더 이미지
          _buildSliverAppBar(),
          // 마리나 정보
          SliverToBoxAdapter(child: _buildMarinaInfo()),
          // 빠른 액션 버튼
          SliverToBoxAdapter(child: _buildQuickActions()),
          // 서비스 섹션 타이틀
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: const Text(
                '이용 가능한 서비스',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // 서비스 그리드
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final service = _services[index];
                  return _buildServiceCard(service);
                },
                childCount: _services.length,
              ),
            ),
          ),
          // 하단 여백
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      // 예약하기 버튼
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.sailing,
                  size: 100,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarinaInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.marinaName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF008489).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFF008489), size: 18),
                    const SizedBox(width: 4),
                    const Text(
                      '4.8',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008489),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                widget.location,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 정보 태그
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildInfoChip(Icons.directions_boat, '50+ 선석'),
              _buildInfoChip(Icons.access_time, '24시간 운영'),
              _buildInfoChip(Icons.local_parking, '주차 가능'),
              _buildInfoChip(Icons.wifi, 'WiFi 제공'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickActionItem(Icons.call, '전화'),
          _buildQuickActionItem(Icons.navigation, '길찾기'),
          _buildQuickActionItem(Icons.web, '웹사이트'),
          _buildQuickActionItem(Icons.camera_alt, '사진'),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF008489).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF008489)),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        if (service['title'] == '부두 예약') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReservationScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${service['title']} 서비스')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (service['color'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                service['icon'] as IconData,
                color: service['color'] as Color,
                size: 26,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              service['title'] as String,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              service['description'] as String,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₩50,000',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '/1박 기준',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReservationScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008489),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '예약하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

