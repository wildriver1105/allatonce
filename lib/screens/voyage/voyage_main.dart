import 'package:flutter/material.dart';

class VoyageScreen extends StatefulWidget {
  const VoyageScreen({super.key});

  @override
  State<VoyageScreen> createState() => _VoyageScreenState();
}

class _VoyageScreenState extends State<VoyageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _upcomingVoyages = [
    {
      'title': '제주 해안 세일링',
      'date': '2024년 12월 15일',
      'duration': '3일',
      'departure': '제주 마리나',
      'destination': '서귀포',
      'crew': 4,
      'status': 'confirmed',
    },
    {
      'title': '부산 → 여수 항해',
      'date': '2024년 12월 28일',
      'duration': '2일',
      'departure': '부산 수영만',
      'destination': '여수 엑스포 마리나',
      'crew': 3,
      'status': 'planning',
    },
  ];

  final List<Map<String, dynamic>> _pastVoyages = [
    {
      'title': '통영 데이 세일링',
      'date': '2024년 11월 23일',
      'duration': '1일',
      'distance': '45km',
      'maxSpeed': '12 knots',
      'avgSpeed': '7 knots',
    },
    {
      'title': '거제도 일주',
      'date': '2024년 11월 10일',
      'duration': '2일',
      'distance': '120km',
      'maxSpeed': '15 knots',
      'avgSpeed': '8 knots',
    },
    {
      'title': '여수 해안 투어',
      'date': '2024년 10월 28일',
      'duration': '1일',
      'distance': '38km',
      'maxSpeed': '10 knots',
      'avgSpeed': '6 knots',
    },
  ];

  final List<Map<String, dynamic>> _liveTraffic = [
    {
      'name': 'SEASCAPE II',
      'type': 'Sailing Yacht',
      'speed': '8.5 knots',
      'heading': 'NE',
      'distance': '2.3km',
    },
    {
      'name': 'BLUE HORIZON',
      'type': 'Motor Yacht',
      'speed': '12.0 knots',
      'heading': 'E',
      'distance': '4.1km',
    },
    {
      'name': 'WAVE RIDER',
      'type': 'Catamaran',
      'speed': '6.2 knots',
      'heading': 'S',
      'distance': '5.8km',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildQuickStats(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUpcomingTab(),
                  _buildHistoryTab(),
                  _buildLiveTrafficTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateVoyageSheet();
        },
        backgroundColor: const Color(0xFF008489),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          '새 항해 계획',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Voyage',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '나의 항해 기록 및 계획',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Icon(Icons.notifications_none, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF008489), Color(0xFF00A693)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF008489).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('12', '총 항해', Icons.sailing),
          _buildStatDivider(),
          _buildStatItem('856', '총 거리(km)', Icons.straighten),
          _buildStatDivider(),
          _buildStatItem('48', '항해 시간', Icons.access_time),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      height: 50,
      width: 1,
      color: Colors.white.withOpacity(0.3),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFF008489),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: '예정된 항해'),
          Tab(text: '항해 기록'),
          Tab(text: '실시간'),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    if (_upcomingVoyages.isEmpty) {
      return _buildEmptyState(
        icon: Icons.sailing,
        title: '예정된 항해가 없습니다',
        subtitle: '새로운 항해를 계획해보세요!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _upcomingVoyages.length,
      itemBuilder: (context, index) {
        return _buildUpcomingVoyageCard(_upcomingVoyages[index]);
      },
    );
  }

  Widget _buildUpcomingVoyageCard(Map<String, dynamic> voyage) {
    final bool isConfirmed = voyage['status'] == 'confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConfirmed
              ? const Color(0xFF4CAF50).withOpacity(0.3)
              : const Color(0xFFFF9800).withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF008489).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.sailing, color: Color(0xFF008489)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voyage['title'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      voyage['date'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isConfirmed
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFFF9800),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isConfirmed ? '확정' : '계획 중',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildVoyageInfoChip(Icons.flag, '${voyage['departure']}'),
              const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
              _buildVoyageInfoChip(Icons.location_on, '${voyage['destination']}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildVoyageInfoChip(Icons.schedule, '${voyage['duration']}'),
              const SizedBox(width: 12),
              _buildVoyageInfoChip(Icons.people, '${voyage['crew']}명'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoyageInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_pastVoyages.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: '항해 기록이 없습니다',
        subtitle: '첫 번째 항해를 기록해보세요!',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pastVoyages.length,
      itemBuilder: (context, index) {
        return _buildPastVoyageCard(_pastVoyages[index]);
      },
    );
  }

  Widget _buildPastVoyageCard(Map<String, dynamic> voyage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                voyage['title'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                voyage['date'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHistoryStatItem('거리', voyage['distance'] as String),
              _buildHistoryStatItem('최고 속도', voyage['maxSpeed'] as String),
              _buildHistoryStatItem('평균 속도', voyage['avgSpeed'] as String),
              _buildHistoryStatItem('기간', voyage['duration'] as String),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF008489),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveTrafficTab() {
    return Column(
      children: [
        // 지도 플레이스홀더
        Container(
          height: 200,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text(
                      '실시간 해상 교통 지도',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(
                      'Marine Traffic API 연동 예정',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // 근처 선박 리스트
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Text(
                '근처 선박',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF008489),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_liveTraffic.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _liveTraffic.length,
            itemBuilder: (context, index) {
              return _buildTrafficCard(_liveTraffic[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrafficCard(Map<String, dynamic> vessel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF008489).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.directions_boat, color: Color(0xFF008489)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vessel['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  vessel['type'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.speed, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    vessel['speed'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${vessel['distance']} ${vessel['heading']}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateVoyageSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '새 항해 계획',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildCreateOption(
                icon: Icons.route,
                title: '새 항해 계획하기',
                subtitle: '출발지와 목적지를 설정하고 항해를 계획하세요',
                color: const Color(0xFF008489),
              ),
              _buildCreateOption(
                icon: Icons.upload_file,
                title: '항해 기록 불러오기',
                subtitle: 'GPX/KML 파일에서 항해 기록을 가져오세요',
                color: const Color(0xFF9B59B6),
              ),
              _buildCreateOption(
                icon: Icons.group_add,
                title: '크루와 함께 계획하기',
                subtitle: '크루를 초대하여 함께 항해를 계획하세요',
                color: const Color(0xFFE91E63),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title 화면으로 이동')),
        );
      },
    );
  }
}

