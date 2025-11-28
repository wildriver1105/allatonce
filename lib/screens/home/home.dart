import 'package:flutter/material.dart';
import '../marina/marinaDetail.dart';

class HomeScreen extends StatefulWidget {
  final void Function(int)? setScreen;
  final void Function(String)? onModelSelected;

  const HomeScreen({
    super.key,
    this.setScreen,
    this.onModelSelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.sailing, 'label': '요트', 'isNew': false},
    {'icon': Icons.directions_boat, 'label': '마리나', 'isNew': true},
    {'icon': Icons.build_circle, 'label': '서비스', 'isNew': true},
    {'icon': Icons.school, 'label': '교육', 'isNew': false},
    {'icon': Icons.event, 'label': '이벤트', 'isNew': false},
  ];

  final List<Map<String, dynamic>> _crewMembers = [
    {
      'name': '김스키퍼',
      'badge': '스키퍼',
      'isOnline': true,
      'color': const Color(0xFF4A90D9),
    },
    {
      'name': '박세일러',
      'badge': '크루',
      'isOnline': true,
      'color': const Color(0xFF50C878),
    },
    {
      'name': '이항해',
      'badge': '베테랑',
      'isOnline': false,
      'color': const Color(0xFFFF6B6B),
    },
    {
      'name': '최바다',
      'badge': '초보',
      'isOnline': true,
      'color': const Color(0xFFFFB347),
    },
    {
      'name': '정요트',
      'badge': '스키퍼',
      'isOnline': false,
      'color': const Color(0xFF9B59B6),
    },
    {
      'name': '한마린',
      'badge': '크루',
      'isOnline': true,
      'color': const Color(0xFF1ABC9C),
    },
  ];

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
      'name': '부산 수영만 요트경기장',
      'location': '부산시 해운대구',
      'rating': 4.8,
      'reviews': 342,
      'distance': '15.2km',
      'available': true,
    },
    {
      'name': '인천 영종도 마리나',
      'location': '인천시 중구',
      'rating': 4.7,
      'reviews': 256,
      'distance': '28.5km',
      'available': false,
    },
  ];

  final List<Map<String, dynamic>> _popularMarinas = [
    {
      'name': '여수 엑스포 마리나',
      'location': '여수시',
      'rating': 4.9,
      'reviews': 198,
    },
    {
      'name': '통영 마리나',
      'location': '통영시',
      'rating': 4.8,
      'reviews': 156,
    },
    {
      'name': '거제 마리나',
      'location': '거제시',
      'rating': 4.7,
      'reviews': 89,
    },
  ];

  final List<Map<String, dynamic>> _recommended = [
    {
      'title': 'FarEast 28 체험',
      'subtitle': '입문자를 위한 세일링',
      'isGuestFavorite': true,
    },
    {
      'title': '선상 파티',
      'subtitle': '프리미엄 요트 파티',
      'isGuestFavorite': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // 검색 바
            _buildSearchBar(),
            const SizedBox(height: 20),
            // 카테고리 탭
            _buildCategoryTabs(),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // 크루 찾기
                    _buildSectionTitle('크루 찾기', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildCrewList(),
                    const SizedBox(height: 28),
                    // 근처 마리나
                    _buildSectionTitle('📍 근처 마리나', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildNearbyMarinasList(),
                    const SizedBox(height: 28),
                    // 인기 마리나
                    _buildSectionTitle('⭐ 인기 마리나', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildPopularMarinasList(),
                    const SizedBox(height: 28),
                    // 추천 체험
                    _buildSectionTitle('🎯 추천 체험', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildRecommendedList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // 검색 화면으로 이동
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black87, size: 22),
              const SizedBox(width: 12),
              Text(
                '어디로 항해할까요?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        category['icon'] as IconData,
                        size: 28,
                        color: isSelected ? Colors.black : Colors.grey[500],
                      ),
                      if (category['isNew'] == true)
                        Positioned(
                          right: -20,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF008489),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2,
                    width: 50,
                    color: isSelected ? Colors.black : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        },
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

  Widget _buildCrewList() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _crewMembers.length,
        itemBuilder: (context, index) {
          final crew = _crewMembers[index];
          return _buildCrewAvatar(crew);
        },
      ),
    );
  }

  Widget _buildCrewAvatar(Map<String, dynamic> crew) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${crew['name']} 프로필 보기')),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        crew['color'] as Color,
                        (crew['color'] as Color).withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                if (crew['isOnline'] == true)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              crew['name'] as String,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: (crew['color'] as Color).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                crew['badge'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: crew['color'] as Color,
                ),
              ),
            ),
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
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFF008489).withOpacity(0.8),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  if (marina['available'] == true)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          marina['location'] as String,
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.star, size: 14, color: Color(0xFFFFB800)),
                      const SizedBox(width: 2),
                      Text(
                        '${marina['rating']}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
      height: 180,
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
        width: 160,
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
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF008489),
                    const Color(0xFF008489).withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.sailing,
                      size: 40,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    marina['name'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Color(0xFFFFB800)),
                      const SizedBox(width: 2),
                      Text(
                        '${marina['rating']}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ' (${marina['reviews']})',
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
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

  Widget _buildRecommendedList() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _recommended.length,
        itemBuilder: (context, index) {
          final item = _recommended[index];
          return _buildRecommendedCard(item);
        },
      ),
    );
  }

  Widget _buildRecommendedCard(Map<String, dynamic> item) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 150,
                  width: 200,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.sailing,
                    size: 56,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              if (item['isGuestFavorite'] == true)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      '인기 체험',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
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
                  child: Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item['title'] as String,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item['subtitle'] as String,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
