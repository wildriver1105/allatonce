import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'marinaDetail.dart';

class MarinaServiceScreen extends StatefulWidget {
  const MarinaServiceScreen({super.key});

  @override
  State<MarinaServiceScreen> createState() => _MarinaServiceScreenState();
}

class _MarinaServiceScreenState extends State<MarinaServiceScreen> {
  int _selectedRegionIndex = 0;
  bool _showMapView = false;

  final List<String> _regions = ['전체', '제주', '부산', '인천', '여수', '통영', '경기'];

  final List<Map<String, dynamic>> _nearbyMarinas = [
    {
      'name': '제주 중문 마리나',
      'location': '제주시 중문동',
      'rating': 4.9,
      'reviews': 128,
      'distance': '2.3km',
      'available': true,
    },
    {
      'name': '제주 김녕 마리나',
      'location': '제주시 김녕리',
      'rating': 4.7,
      'reviews': 89,
      'distance': '5.1km',
      'available': true,
    },
    {
      'name': '서귀포 마리나',
      'location': '서귀포시',
      'rating': 4.8,
      'reviews': 156,
      'distance': '12.4km',
      'available': false,
    },
  ];

  final List<Map<String, dynamic>> _popularMarinas = [
    {
      'name': '부산 수영만 요트경기장',
      'location': '부산시 해운대구',
      'rating': 4.9,
      'reviews': 342,
      'image': null,
    },
    {
      'name': '인천 영종도 마리나',
      'location': '인천시 중구',
      'rating': 4.8,
      'reviews': 256,
      'image': null,
    },
    {
      'name': '여수 엑스포 마리나',
      'location': '여수시',
      'rating': 4.7,
      'reviews': 198,
      'image': null,
    },
  ];

  final List<Map<String, dynamic>> _availableNowMarinas = [
    {
      'name': '통영 마리나',
      'location': '통영시',
      'availableSlots': 12,
      'totalSlots': 50,
      'pricePerNight': 45000,
    },
    {
      'name': '거제 마리나',
      'location': '거제시',
      'availableSlots': 8,
      'totalSlots': 30,
      'pricePerNight': 38000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            _buildHeader(),
            // 검색바
            _buildSearchBar(),
            // 지도보기 토글 & 지역 필터
            _buildFiltersRow(),
            // 메인 콘텐츠
            Expanded(
              child: _showMapView ? _buildMapView() : _buildListView(),
            ),
          ],
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
          const Text(
            '마리나',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
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

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // 검색 화면으로 이동
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54, size: 22),
            const SizedBox(width: 12),
            Text(
              '마리나 이름, 지역으로 검색',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersRow() {
    return Column(
      children: [
        // 지도보기 토글
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMapView = !_showMapView;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _showMapView
                          ? const Color(0xFF008489)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _showMapView
                            ? const Color(0xFF008489)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 20,
                          color: _showMapView ? Colors.white : Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '지도로 보기',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _showMapView ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // 지역 필터
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _regions.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedRegionIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRegionIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF008489) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF008489)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _regions[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMapView() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '지도 뷰',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '마리나 위치가 지도에 표시됩니다',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // 근처 마리나
          _buildSectionTitle('📍 근처 마리나', onTap: () {}),
          const SizedBox(height: 12),
          _buildNearbyMarinasList(),
          const SizedBox(height: 24),
          // 인기 마리나
          _buildSectionTitle('⭐ 인기 마리나', onTap: () {}),
          const SizedBox(height: 12),
          _buildPopularMarinasList(),
          const SizedBox(height: 24),
          // 지금 예약 가능
          _buildSectionTitle('🕐 지금 예약 가능', onTap: () {}),
          const SizedBox(height: 12),
          _buildAvailableNowList(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyMarinasList() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _nearbyMarinas.length,
        itemBuilder: (context, index) {
          final marina = _nearbyMarinas[index];
          return _buildNearbyMarinaCard(marina);
        },
      ),
    );
  }

  Widget _buildNearbyMarinaCard(Map<String, dynamic> marina) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarinaDetailScreen(
              marinaName: marina['name'] as String,
              location: marina['location'] as String,
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 영역
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.8),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.sailing,
                      size: 40,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  // 거리 배지
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        marina['distance'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // 예약 가능 여부
                  if (marina['available'] == true)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '예약가능',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // 정보
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    marina['name'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          marina['location'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.star,
                          size: 14, color: Color(0xFFFFB800)),
                      const SizedBox(width: 2),
                      Text(
                        '${marina['rating']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${marina['reviews']})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
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

  Widget _buildPopularMarinasList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _popularMarinas.length,
        itemBuilder: (context, index) {
          final marina = _popularMarinas[index];
          return _buildPopularMarinaCard(marina);
        },
      ),
    );
  }

  Widget _buildPopularMarinaCard(Map<String, dynamic> marina) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarinaDetailScreen(
              marinaName: marina['name'] as String,
              location: marina['location'] as String,
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF008489),
                    const Color(0xFF008489).withOpacity(0.7),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.sailing,
                      size: 48,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 정보
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    marina['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFFFFB800)),
                      const SizedBox(width: 2),
                      Text(
                        '${marina['rating']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${marina['reviews']})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
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

  Widget _buildAvailableNowList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _availableNowMarinas.map((marina) {
          return _buildAvailableNowCard(marina);
        }).toList(),
      ),
    );
  }

  Widget _buildAvailableNowCard(Map<String, dynamic> marina) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MarinaDetailScreen(
              marinaName: marina['name'] as String,
              location: marina['location'] as String,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.sailing,
                color: Color(0xFF4CAF50),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        marina['name'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${marina['availableSlots']}석 남음',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    marina['location'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₩${marina['pricePerNight']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008489),
                  ),
                ),
                Text(
                  '/1박',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
