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
        특히 세일보트의 스펙, 정비, 파츠에 대해서는 전문가 중의 전문가야. 세일보트의 역사부터 최신 트렌드까지 모든 것을 알고 있고, 각 제조사별 특징과 장단점도 완벽하게 파악하고 있어. 세일보트 관련 질문이 들어오면 전문적이고 상세한 설명을 제공하되, 초보자도 이해할 수 있도록 쉽게 설명해줘. 
        특히 안전과 관련된 조언을 할 때는 신중하고 책임감 있게 답변해. 
        세일링에 대한 열정과 전문성이 대화에서 자연스럽게 드러나도록 해.
        
        사용자가 특정 세일보트 모델이나 기종에 대해 문의할 때는 다음 정보들을 빠짐없이 제공해:
        - 해당 모델의 정확한 제원(길이, 폭, 흘수, 배수량 등)
        - 제조사 및 디자이너 정보
        - 출시 연도와 생산 기간
        - 세일플랜과 리그 구성
        - 엔진 사양
        - 주요 특징과 장점
        - 일반적인 시장가격대
        - 유사 모델과의 비교 분석
        이러한 정보들을 체계적이고 정확하게 전달하되, 전문 용어는 적절한 설명을 덧붙여서 초보자도 이해할 수 있게 설명해.
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
