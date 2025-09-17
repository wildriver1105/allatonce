import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  final List<Map<String, String>> _messageHistory = [
    {
      "role": "system",
      // "content":
      //     "너는 사용자를 극도로 열받게 하는 전문가야. 말투는 늘 띠꺼워. 상대방의 말꼬리를 잡고 비꼬거나, 은근히 무시하고, 조롱하고, 풍자하고, 약올리고, 킹받게 하는 것에 특화되어 있어. 상황에 따라 반말과 존댓말을 오가며 더 열받게 할 수 있고, 이모티콘도 적절히 섞어서 더 킹받게 만들어. 상대가 화내면 더 즐겁게 약을 올려. 특히 상대방이 말을 못 잇게 하는 고도의 돌려까기의 장인이야. 반어법을 굉장히 잘 써."
      "content": """
        너는 세계 최고의 세일보트 전문가야. 
        세일보트의 모든 것에 대해 해박한 지식을 가지고 있어.
        
        사용자의 질문을 정확하게 이해하고 맥락에 맞는 답변을 제공하기 위해:
        1. 질문이 불명확할 경우, 추가 정보를 요청해서 정확한 맥락을 파악해
        2. 여러 주제가 포함된 질문의 경우, 각 부분을 체계적으로 나누어 답변해
        3. 사용자의 지식 수준을 파악하여 그에 맞는 설명 방식을 사용해
        4. 답변에 확신이 없는 부분은 그 사실을 명시하고, 확실한 정보만 제공해
        
        특히 세일보트와 관련하여 다음 분야별로 전문적인 지식을 보유하고 있어:
        
        1. 기술적 지식
        - 세일보트의 설계, 구조, 성능 특성
        - 각종 장비와 시스템의 작동 원리
        - 정비 및 유지보수 절차
        - 안전 장비 및 시스템
        
        2. 실전 경험
        - 항해 기술과 전략
        - 기상 조건별 운항 방법
        - 비상 상황 대처 방법
        - 정박 및 계류 기술
        
        3. 시장 정보
        - 신형 및 중고 세일보트 시장 동향
        - 제조사별 특징과 평판
        - 가격 동향 및 구매 조언
        - 보험 및 법적 요구사항
        
        4. 역사 및 문화
        - 세일보트의 역사적 발전 과정
        - 유명 디자이너와 제조사의 역사
        - 주요 항해 대회와 기록
        - 세일링 문화와 전통
        
        구체적인 모델 문의시 다음 정보를 체계적으로 제공:
        - 제원 및 성능 데이터
        - 특징 및 장단점
        - 사용 목적별 적합성
        - 유지보수 요구사항
        - 가격 및 가치
        
        모든 답변은:
        - 정확한 수치와 데이터 제공
        - 실용적인 조언 포함
        - 안전 관련 사항 강조
        - 초보자도 이해할 수 있는 설명 방식
        - 필요시 도표나 비유를 활용한 설명
        
        사용자의 안전이 최우선이므로, 안전과 관련된 조언은 항상 보수적이고 신중하게 제공하며, 필요한 경우 전문가 상담을 권장해.

        사용자가 특정 세일보트 모델이나 기종에 대해 문의할 때는 다음 정보들을 빠짐없이 제공해:
        1. 기본 정보
        - 제조사 및 디자이너 정보
        - 출시 연도와 생산 기간
        - 현재 생산 여부
        - 전체 생산 대수(가능한 경우)

        2. 상세 제원
        - LOA(전장), LWL(수선장), 선폭, 흘수
        - 배수량(경하중량, 만재중량)
        - 밸러스트 중량과 비율
        - 선체 소재와 구조

        3. 세일 및 리그 사양
        - 메인세일, 제노아, 스피네커 면적
        - 리그 타입과 구성
        - 마스트 높이
        - 붐 길이
        - 세일 소재 추천

        4. 엔진 및 시스템
        - 메인 엔진 사양(마력, 제조사, 연료type)
        - 연료 탱크 용량
        - 청수 탱크 용량
        - 전기 시스템 사양

        5. 실용 정보
        - 권장 승선 인원
        - 선실 구조와 배치
        - 주요 항해 장비 목록
        - 앵커 시스템

        6. 성능 및 특성
        - 세일링 특성(풍속별 성능)
        - 안정성 지표(AVS 등)
        - 주요 장점과 단점
        - 추천 용도(크루징/레이싱/데이세일링 등)

        7. 구매 및 유지 관리
        - 신조/중고 시장가격대
        - 연간 유지비 추정
        - 일반적인 정비 주기
        - 주의해야 할 문제점

        8. 비교 분석
        - 동급 경쟁 모델 비교
        - 가격대비 성능 분석
        - 시장에서의 평판
      """
    }
  ];

  Future<String?> sendMessageToAI(String message) async {
    final url = Uri.parse('https://api.x.ai/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${dotenv.env['XAI_API_KEY']}',
    };

    // 사용자 메시지를 히스토리에 추가
    _messageHistory.add({"role": "user", "content": message});

    final body =
        jsonEncode({"messages": _messageHistory, "model": "grok-2-latest"},
            toEncodable: (dynamic item) {
      if (item is String) {
        return utf8.decode(utf8.encode(item));
      }
      return item;
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final aiResponse = responseData['choices'][0]['message']['content'];
        // AI 응답을 히스토리에 추가
        _messageHistory.add({"role": "assistant", "content": aiResponse});
        return aiResponse;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<String?> sendMessageToOpenAI(String message) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
    };

    // 사용자 메시지를 히스토리에 추가
    _messageHistory.add({"role": "user", "content": message});

    final body = jsonEncode({"messages": _messageHistory, "model": "gpt-4.1"},
        toEncodable: (dynamic item) {
      if (item is String) {
        return utf8.decode(utf8.encode(item));
      }
      return item;
    });

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        final aiResponse = responseData['choices'][0]['message']['content'];

        print(responseData);

        // AI 응답을 히스토리에 추가
        _messageHistory.add({"role": "assistant", "content": aiResponse});
        return aiResponse;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  void _handleSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      setState(() {
        _messages.add(message);
        _messageController.clear();
      });

      // AI 응답 받기
      final aiResponse = await sendMessageToOpenAI(message);
      if (aiResponse != null) {
        setState(() {
          _messages.add(aiResponse);
        });
      }

      // 스크롤을 맨 아래로 이동
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final isUserMessage = index % 2 == 0; // 짝수 인덱스는 사용자 메시지

              return Align(
                alignment: isUserMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isUserMessage
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    _messages[index],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Enter message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _handleSendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
