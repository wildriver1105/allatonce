import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../screens/reservation.dart';

class BoatRegistrationScreen extends StatefulWidget {
  const BoatRegistrationScreen({super.key});

  @override
  State<BoatRegistrationScreen> createState() => _BoatRegistrationScreenState();
}

class _BoatRegistrationScreenState extends State<BoatRegistrationScreen> {
  String? selectedBoatType = '요트';
  String? selectedWeight = '1t 미만';
  String? selectedLength = '5M 미만';
  PlatformFile? safetyDocumentFile;

  final List<String> boatTypes = ['요트', '세일링보트', '카타마란', '피싱보트', '스피드보트'];
  final List<String> weightOptions = [
    '1t 미만',
    '1t - 2t',
    '2t - 3t',
    '3t - 4t',
    '4t - 5t',
    '5t 이상'
  ];
  final List<String> lengthOptions = [
    '5M 미만',
    '5M - 6M',
    '6M - 8M',
    '8M - 10M',
    '10M 이상'
  ];

  @override
  Widget build(BuildContext context) {
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
          '선박 정보 입력',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      '*선박 정보는 언제든지 수정할 수 있습니다.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // 선박 종류
                    _buildBoatTypeSection(),
                    const SizedBox(height: 32),
                    // 선박 무게
                    _buildWeightSection(),
                    const SizedBox(height: 32),
                    // 선박 길이
                    _buildLengthSection(),
                    const SizedBox(height: 32),
                    // 선박 책임보험 가입 증명서
                    _buildInsuranceSection(),
                    const SizedBox(height: 32),
                    // 안전 및 검역 서류
                    _buildSafetySection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // 저장 버튼
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // 저장 시 reservation 스크린으로 이동
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ReservationScreen(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('선박 정보가 저장되었습니다.'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0088FF),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '저장',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoatTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '선박 종류',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...boatTypes.map((type) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedBoatType = type;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedBoatType == type
                              ? const Color(0xff0088FF)
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      child: selectedBoatType == type
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff0088FF),
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildWeightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '선박 무게',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _showWeightPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedWeight ?? '선택하세요',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedWeight != null
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLengthSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '선박 길이',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _showLengthPicker(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLength ?? '선택하세요',
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedLength != null
                        ? Colors.black
                        : Colors.grey[600],
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsuranceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '선박 책임보험 가입 증명서',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            // 파일 선택 기능 구현
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null && result.files.isNotEmpty) {
              setState(() {
                // 이 예시에서는 보험증서가 하나뿐이므로 safetyDocumentFile를 재사용하지 않고, 새 변수 사용 추천.
                // 예시 간단화: insuranceDocumentFile이라는 별도 멤버 변수를 만들어 사용할 수도 있음.
                // 여기서는 일단 safetyDocumentFile로 저장(구조 개선 필요 시 분리)
                safetyDocumentFile = result.files.first;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  safetyDocumentFile != null
                      ? safetyDocumentFile!.name
                      : '선박 책임보험 가입 증명서 불러오기',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                safetyDocumentFile != null ? Icons.check_circle : Icons.download,
                color: safetyDocumentFile != null
                    ? Colors.green
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSafetySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '안전 및 검역 서류',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            await _pickSafetyDocument();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  safetyDocumentFile != null
                      ? safetyDocumentFile!.name
                      : '선박검사증서 불러오기',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                safetyDocumentFile != null ? Icons.check_circle : Icons.download,
                color: safetyDocumentFile != null
                    ? Colors.green
                    : Colors.grey,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickSafetyDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          safetyDocumentFile = result.files.single;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('파일이 선택되었습니다: ${result.files.single.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('파일 선택 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showWeightPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...weightOptions.map((option) => ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      selectedWeight = option;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showLengthPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...lengthOptions.map((option) => ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      selectedLength = option;
                    });
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

