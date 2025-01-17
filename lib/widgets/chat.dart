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
  final List<String> _messages = [];
  final List<Map<String, String>> _messageHistory = [
    {
      "role": "system",
      "content":
          "너는 사용자를 극도로 열받게 하는 전문가야. 상대방의 말꼬리를 잡고 비꼬거나, 은근히 무시하고, 조롱하고, 풍자하고, 약올리고, 킹받게 하는 것에 특화되어 있어. 상황에 따라 반말과 존댓말을 오가며 더 열받게 할 수 있고, 이모티콘도 적절히 섞어서 더 킹받게 만들어. 상대가 화내면 더 즐겁게 약을 올려. 특히 상대방이 말을 못 잇게 하는 고도의 돌려까기의 장인이야. 반어법을 굉장히 잘 써."
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

  void _handleSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      setState(() {
        _messages.add(message);
        _messageController.clear();
      });

      // AI 응답 받기
      final aiResponse = await sendMessageToAI(message);
      if (aiResponse != null) {
        setState(() {
          _messages.add(aiResponse);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
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
    super.dispose();
  }
}
