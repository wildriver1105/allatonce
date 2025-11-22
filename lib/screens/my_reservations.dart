import 'package:flutter/material.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 예약 데이터
    final List<Map<String, dynamic>> reservations = [
      {
        'boatName': '선박 1',
        'mooringDate': '12월 11일 오전 05시',
        'departureDate': '12월 15일 오후 02시',
        'status': '이용 전',
        'statusColor': const Color(0xff0088FF),
      },
      {
        'boatName': '선박 2',
        'mooringDate': '12월 11일 오전 05시',
        'departureDate': '12월 15일 오후 02시',
        'status': '취소 중',
        'statusColor': Colors.orange,
      },
      {
        'boatName': '선박 1',
        'mooringDate': '12월 11일 오전 05시',
        'departureDate': '12월 15일 오후 02시',
        'status': '이용 완료',
        'statusColor': Colors.grey,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '내 예약',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // 예약 카드 리스트
              ...reservations.map((reservation) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildReservationCard(
                      context,
                      boatName: reservation['boatName'] as String,
                      mooringDate: reservation['mooringDate'] as String,
                      departureDate: reservation['departureDate'] as String,
                      status: reservation['status'] as String,
                      statusColor: reservation['statusColor'] as Color,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationCard(
    BuildContext context, {
    required String boatName,
    required String mooringDate,
    required String departureDate,
    required String status,
    required Color statusColor,
  }) {
    return InkWell(
      onTap: () {
        // 예약 상세 화면으로 이동 (추후 구현)
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        boatName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 14,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '정박 일시 $mooringDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '출항 일시 $departureDate',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

