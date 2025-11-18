import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'schedule_selection_screen.dart';

class BerthReservationScreen extends StatefulWidget {
  const BerthReservationScreen({super.key});

  @override
  State<BerthReservationScreen> createState() => _BerthReservationScreenState();
}

class _BerthReservationScreenState extends State<BerthReservationScreen> {
  String? selectedSchedule;
  String? boatInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '빠른 예약하기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // 정박 일정 선택
              _buildInputSection(
                label: '정박 일정',
                value: selectedSchedule ?? '일정 선택',
                onTap: () async {
                  final result = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScheduleSelectionScreen(),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      selectedSchedule = result['display'];
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              // 선박 정보 입력
              _buildInputSection(
                label: '선박 정보',
                value: boatInfo ?? '정보 입력',
                onTap: () {
                  _showBoatInfoDialog();
                },
              ),
              const SizedBox(height: 24),
              // 조회하기 버튼
              ElevatedButton(
                onPressed: selectedSchedule != null && boatInfo != null
                    ? () {
                        // 조회하기 기능 구현
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('예약 조회 중...'),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  disabledBackgroundColor: Colors.grey[300],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '조회하기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // 실시간 정박 현황
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '실시간 정박 현황',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 자세히 보기 기능 구현
                    },
                    child: const Text(
                      '자세히 보기',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: const Text(
                  '현재 비어있는 공간: 400/1,000m²',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 마리나 지도 영역 (플레이스홀더)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '마리나 지도',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 비어있는 공간 표시 (초록색 영역)
                    Positioned(
                      right: 40,
                      top: 60,
                      child: Container(
                        width: 120,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        onTap: (index) {
          if (index == 1) {
            // 내 예약 화면으로 이동
          } else if (index == 2) {
            // 내 정보 화면으로 이동
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '예약하기',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: '내 예약',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '내 정보',
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: value == '일정 선택' || value == '정보 입력'
                        ? Colors.grey[600]
                        : Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBoatInfoDialog() {
    final boatNameController = TextEditingController();
    final boatLengthController = TextEditingController();
    final boatWidthController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('선박 정보 입력'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: boatNameController,
              decoration: const InputDecoration(
                labelText: '선박명',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: boatLengthController,
              decoration: const InputDecoration(
                labelText: '길이 (m)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: boatWidthController,
              decoration: const InputDecoration(
                labelText: '폭 (m)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (boatNameController.text.isNotEmpty) {
                setState(() {
                  boatInfo = boatNameController.text;
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text(
              '확인',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

