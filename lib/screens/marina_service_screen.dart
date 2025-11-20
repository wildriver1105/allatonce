import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'berth_reservation_screen.dart';

class MarinaServiceScreen extends StatefulWidget {
  const MarinaServiceScreen({super.key});

  @override
  State<MarinaServiceScreen> createState() => _MarinaServiceScreenState();
}

class _MarinaServiceScreenState extends State<MarinaServiceScreen> {
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
      appBar: AppBar(
        title: const Text(
          '마리나 서비스',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return _buildServiceCard(
                icon: service['icon'] as IconData,
                title: service['title'] as String,
                description: service['description'] as String,
                onTap: () => (service['onTap'] as Function(BuildContext))(context),
              );
            },
          ),
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

