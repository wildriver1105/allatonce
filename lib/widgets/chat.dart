import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../constants/colors.dart';

class ChatWidget extends StatefulWidget {
  final String modelName;

  const ChatWidget({
    super.key,
    this.modelName = '',
  });

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<String> _messages = [];
  final List<bool> _isUserMessages = [];
  final List<bool> _isCompleteMessages = [];
  String _currentStreamingMessage = '';
  bool _isStreaming = false;

  void _addMessage(String content, bool isUser, bool isComplete) {
    setState(() {
      _messages.add(content);
      _isUserMessages.add(isUser);
      _isCompleteMessages.add(isComplete);
    });
  }

  void _updateLastMessage(String content, bool isComplete) {
    if (_messages.isNotEmpty) {
      setState(() {
        _messages[_messages.length - 1] = content;
        _isCompleteMessages[_isCompleteMessages.length - 1] = isComplete;
      });
    }
  }

  final List<Map<String, String>> _messageHistory = [
    {
      "role": "system",
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

        <critical>
          답변을 할 때는 어떠한 주석과 출처도 달지 말고 그냥 답변을 해.
          마크다운 절대 쓰지마.
        </critical>
      """
    }
  ];

  Stream<String> sendMessageToPerplexity(String message) async* {
    try {
      final apiKey = dotenv.env['PERPLEXITY_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        print('Error: API key not found');
        _addMessage(
            'Error: Could not connect to AI service. Please check your configuration.',
            false,
            true);
        yield* Stream.empty();
        return;
      }

      final url = Uri.parse('https://api.perplexity.ai/chat/completions');
      final headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $apiKey',
      };

      // 사용자 메시지를 히스토리에 추가
      _messageHistory.add({"role": "user", "content": message});

      final body = jsonEncode({
        "messages": _messageHistory,
        "model": "sonar-pro",
        "stream": true,
      }, toEncodable: (dynamic item) {
        if (item is String) {
          return utf8.decode(utf8.encode(item));
        }
        return item;
      });

      try {
        final request = http.Request('POST', url);
        request.headers.addAll(headers);
        request.body = body;

        final response = await http.Client().send(request);

        if (response.statusCode == 200) {
          String accumulatedContent = '';

          await for (final chunk in response.stream
              .transform(utf8.decoder)
              .transform(const LineSplitter())) {
            if (chunk.startsWith('data: ')) {
              final data = chunk.substring(6);
              if (data == '[DONE]') break;

              try {
                final jsonData = jsonDecode(data);
                final content =
                    jsonData['choices'][0]['delta']['content'] ?? '';
                accumulatedContent += content;
                yield content;
              } catch (e) {
                print('Error parsing chunk: $e');
              }
            }
          }

          // AI 응답을 히스토리에 추가
          _messageHistory
              .add({"role": "assistant", "content": accumulatedContent});
        } else {
          print('Error: ${response.statusCode}');
          _addMessage(
              'Error: Failed to get response from AI service.', false, true);
          yield* Stream.empty();
        }
      } catch (e) {
        print('Network error: $e');
        _addMessage('Error: Network connection failed.', false, true);
        yield* Stream.empty();
      }
    } catch (e) {
      print('General error: $e');
      _addMessage('Error: An unexpected error occurred.', false, true);
      yield* Stream.empty();
    }
  }

  void _handleSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      _messageController.clear();

      // 사용자 메시지 추가
      _addMessage(message, true, true);

      // AI 응답 준비
      setState(() {
        _isStreaming = true;
        _currentStreamingMessage = '';
      });
      _addMessage('', false, false);

      // 스크롤을 맨 아래로 이동
      _scrollToBottom();

      // AI 응답 스트리밍 시작
      await for (final chunk in sendMessageToPerplexity(message)) {
        _currentStreamingMessage += chunk;
        _updateLastMessage(_currentStreamingMessage, false);
        _scrollToBottom();
      }

      // 스트리밍 완료
      setState(() {
        _isStreaming = false;
      });
      _updateLastMessage(_currentStreamingMessage, true);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              if (index >= _messages.length ||
                  index >= _isUserMessages.length ||
                  index >= _isCompleteMessages.length) {
                return const SizedBox.shrink();
              }

              final message = _messages[index];
              final isUser = _isUserMessages[index];
              final isComplete = _isCompleteMessages[index];

              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: isUser ? 80.0 : 10.0,
                    right: isUser ? 10.0 : 80.0,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.primary : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black,
                        ),
                      ),
                      if (!isComplete) ...[
                        const SizedBox(height: 8),
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ],
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
