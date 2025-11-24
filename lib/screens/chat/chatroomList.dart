import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import 'chatroom.dart';

class ChatroomListScreen extends StatelessWidget {
  const ChatroomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 채팅방 목록 데이터
    final List<Map<String, dynamic>> chatrooms = [
      {
        'id': '1',
        'title': 'FarEast28',
        'lastMessage': '안녕하세요, 선박 관리에 대해 문의드립니다.',
        'timestamp': '오전 10:30',
        'unreadCount': 2,
        'modelName': 'fareast28',
      },
      {
        'id': '2',
        'title': 'Farr 40',
        'lastMessage': '정비 일정을 확인해주세요.',
        'timestamp': '어제',
        'unreadCount': 0,
        'modelName': 'farr40',
      },
      {
        'id': '3',
        'title': 'Benetaur 473',
        'lastMessage': '감사합니다!',
        'timestamp': '3일 전',
        'unreadCount': 0,
        'modelName': 'benetau473',
      },
      {
        'id': '4',
        'title': 'J/24',
        'lastMessage': '다음 주 예약 가능한가요?',
        'timestamp': '1주 전',
        'unreadCount': 1,
        'modelName': 'j24',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '채팅',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: chatrooms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '채팅방이 없습니다',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: chatrooms.length,
              itemBuilder: (context, index) {
                final chatroom = chatrooms[index];
                return _buildChatroomCard(context, chatroom);
              },
            ),
    );
  }

  Widget _buildChatroomCard(
    BuildContext context,
    Map<String, dynamic> chatroom,
  ) {
    final unreadCount = chatroom['unreadCount'] as int;
    
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              modelName: chatroom['modelName'] as String,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // 채팅방 아이콘
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sailing,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // 채팅방 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chatroom['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        chatroom['timestamp'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatroom['lastMessage'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
}

