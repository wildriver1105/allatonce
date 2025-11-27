import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.grid_view, 'label': '전체'},
    {'icon': Icons.swap_horiz, 'label': '물물교환'},
    {'icon': Icons.people_alt, 'label': '크루 모집'},
    {'icon': Icons.info_outline, 'label': '정보 공유'},
  ];

  final List<Map<String, dynamic>> _posts = [
    {
      'type': 'trade',
      'author': '김세일러',
      'authorImage': null,
      'badge': '활동적인 세일러',
      'timeAgo': '2시간 전',
      'title': '요트 앵커 교환 원합니다',
      'content': '20kg 스테인리스 앵커를 15kg 알루미늄 앵커로 교환 원합니다. 상태 양호합니다.',
      'likes': 12,
      'comments': 5,
      'hasImage': true,
      'tags': ['물물교환', '장비'],
    },
    {
      'type': 'crew',
      'author': '캡틴박',
      'authorImage': null,
      'badge': '스키퍼',
      'timeAgo': '4시간 전',
      'title': '🚤 12월 제주 세일링 크루 모집',
      'content': '12월 15일-17일 제주 해안 세일링 함께하실 크루 2명 모집합니다.\n\n경험: 초보 환영\n보트: FarEast 28\n일정: 2박 3일',
      'likes': 45,
      'comments': 23,
      'hasImage': true,
      'tags': ['크루모집', '제주', '초보환영'],
      'crewInfo': {
        'currentCrew': 2,
        'maxCrew': 4,
        'date': '12월 15일 - 17일',
        'location': '제주도',
      },
    },
    {
      'type': 'info',
      'author': '요트매니아',
      'authorImage': null,
      'badge': '정보 기여자',
      'timeAgo': '어제',
      'title': '부산 마리나 시설 이용 후기',
      'content': '지난 주말 부산 마리나 이용했습니다. 시설이 깔끔하고 직원분들도 친절하셨어요. 주차 공간도 넉넉하고...',
      'likes': 34,
      'comments': 12,
      'hasImage': true,
      'tags': ['후기', '부산', '마리나'],
    },
    {
      'type': 'general',
      'author': '바다사랑',
      'authorImage': null,
      'badge': null,
      'timeAgo': '2일 전',
      'title': '오늘 날씨 좋네요 ⛵',
      'content': '한강에서 카약 타고 왔어요. 다음엔 요트 도전해보고 싶네요!',
      'likes': 28,
      'comments': 8,
      'hasImage': false,
      'tags': ['일상', '한강'],
    },
    {
      'type': 'crew',
      'author': '항해사이민',
      'authorImage': null,
      'badge': '베테랑 스키퍼',
      'timeAgo': '3일 전',
      'title': '주말 여수 데이세일링 스키퍼 구합니다',
      'content': '12월 21일 토요일 여수에서 데이세일링 예정입니다. 경험 있는 스키퍼분 모십니다.',
      'likes': 19,
      'comments': 7,
      'hasImage': true,
      'tags': ['스키퍼모집', '여수', '데이세일링'],
      'crewInfo': {
        'currentCrew': 3,
        'maxCrew': 5,
        'date': '12월 21일',
        'location': '여수',
      },
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredPosts {
    if (_selectedTabIndex == 0) return _posts;
    
    final filterType = ['all', 'trade', 'crew', 'info'][_selectedTabIndex];
    return _posts.where((post) {
      if (filterType == 'trade') return post['type'] == 'trade';
      if (filterType == 'crew') return post['type'] == 'crew';
      if (filterType == 'info') return post['type'] == 'info';
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _filteredPosts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: _filteredPosts.length,
                    itemBuilder: (context, index) {
                      return _buildPostCard(_filteredPosts[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostSheet();
        },
        backgroundColor: const Color(0xFF008489),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        '커뮤니티',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            // 검색 기능
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            // 알림 기능
          },
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _tabs.length,
              itemBuilder: (context, index) {
                final tab = _tabs[index];
                final isSelected = _selectedTabIndex == index;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = index;
                      _tabController.animateTo(index);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF008489) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          tab['icon'] as IconData,
                          size: 18,
                          color: isSelected ? Colors.white : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tab['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            '게시글이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final bool isCrew = post['type'] == 'crew';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, color: Colors.grey[400]),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post['author'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          if (post['badge'] != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: _getBadgeColor(post['type'] as String),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                post['badge'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        post['timeAgo'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.grey[400]),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // 타이틀
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              post['title'] as String,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 콘텐츠
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              post['content'] as String,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // 크루 모집 정보
          if (isCrew && post['crewInfo'] != null) ...[
            const SizedBox(height: 12),
            _buildCrewInfoCard(post['crewInfo'] as Map<String, dynamic>),
          ],
          // 이미지 플레이스홀더
          if (post['hasImage'] == true) ...[
            const SizedBox(height: 12),
            Container(
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _getTypeIcon(post['type'] as String),
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ],
          // 태그
          if (post['tags'] != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (post['tags'] as List).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          const SizedBox(height: 12),
          // 액션 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_border, size: 20, color: Colors.grey[600]),
                  label: Text(
                    '${post['likes']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey[600]),
                  label: Text(
                    '${post['comments']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.share_outlined, size: 20, color: Colors.grey[600]),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.bookmark_border, size: 20, color: Colors.grey[600]),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildCrewInfoCard(Map<String, dynamic> crewInfo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF008489).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF008489).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xFF008489),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      crewInfo['date'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(0xFF008489),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      crewInfo['location'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF008489),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '${crewInfo['currentCrew']}/${crewInfo['maxCrew']}명',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(String type) {
    switch (type) {
      case 'crew':
        return const Color(0xFF008489);
      case 'trade':
        return Colors.orange;
      case 'info':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'crew':
        return Icons.sailing;
      case 'trade':
        return Icons.swap_horiz;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.photo;
    }
  }

  void _showCreatePostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
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
                '새 게시글 작성',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildPostTypeOption(
                icon: Icons.article,
                title: '일반 게시글',
                subtitle: '자유롭게 소통해요',
                color: Colors.grey[700]!,
              ),
              _buildPostTypeOption(
                icon: Icons.swap_horiz,
                title: '물물교환',
                subtitle: '장비나 용품을 교환해요',
                color: Colors.orange,
              ),
              _buildPostTypeOption(
                icon: Icons.people_alt,
                title: '크루/스키퍼 모집',
                subtitle: '함께 항해할 멤버를 찾아요',
                color: const Color(0xFF008489),
              ),
              _buildPostTypeOption(
                icon: Icons.info_outline,
                title: '정보 공유',
                subtitle: '유용한 정보를 나눠요',
                color: Colors.blueGrey,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostTypeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
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
          SnackBar(content: Text('$title 작성 화면으로 이동')),
        );
      },
    );
  }
}

