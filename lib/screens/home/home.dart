import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _recentlyViewed = [
    {
      'image': 'https://images.unsplash.com/photo-1540946485063-a40da27545f8?w=400',
      'location': '제주 마리나',
      'details': '요트 3대 · ★ 4.78',
    },
    {
      'image': 'https://images.unsplash.com/photo-1567899378494-47b22a2ae96a?w=400',
      'location': '부산 마리나',
      'details': '요트 5대 · ★ 4.82',
    },
    {
      'image': 'https://images.unsplash.com/photo-1605281317010-fe5ffe798166?w=400',
      'location': '여수 마리나',
      'details': '요트 4대',
    },
  ];

  final List<Map<String, dynamic>> _recommended = [
    {
      'image': 'https://images.unsplash.com/photo-1559190394-df5a28aab5c5?w=400',
      'title': 'FarEast 28 체험',
      'subtitle': '입문자를 위한 세일링',
      'isGuestFavorite': true,
    },
    {
      'image': 'https://images.unsplash.com/photo-1569263979104-865ab7cd8d13?w=400',
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
                    // 최근 검색 카드
                    _buildContinueSearchingCard(),
                    const SizedBox(height: 28),
                    // 최근 본 항목
                    _buildSectionTitle('최근 본 항목', onTap: () {}),
                    const SizedBox(height: 12),
                    _buildRecentlyViewedList(),
                    const SizedBox(height: 28),
                    // 추천 항목
                    _buildSectionTitle('인기 체험', onTap: () {}),
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

  Widget _buildContinueSearchingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // 검색 계속하기
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '제주 마리나 근처\n요트 체험 검색 계속하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '12월 9-12일',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          ' · ',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          '3명',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 100,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.sailing,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildRecentlyViewedList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _recentlyViewed.length,
        itemBuilder: (context, index) {
          final item = _recentlyViewed[index];
          return _buildRecentlyViewedCard(item);
        },
      ),
    );
  }

  Widget _buildRecentlyViewedCard(Map<String, dynamic> item) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 120,
                  width: 160,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.sailing,
                    size: 48,
                    color: Colors.grey[400],
                  ),
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
                  child: Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item['location'] as String,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item['details'] as String,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedList() {
    return SizedBox(
      height: 260,
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
      width: 220,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 180,
                  width: 220,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.sailing,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              if (item['isGuestFavorite'] == true)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      '인기 체험',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item['title'] as String,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item['subtitle'] as String,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
