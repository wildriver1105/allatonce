import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../constants/colors.dart';
import '../constants/prompts.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

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

  List<Map<String, String>> _messageHistory = [];

  @override
  void initState() {
    super.initState();
    _initializeMessageHistory();
  }

  @override
  void didUpdateWidget(ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modelName != widget.modelName) {
      _initializeMessageHistory();
    }
  }

  void _initializeMessageHistory() {
    _messageHistory = [
      {
        "role": "system",
        "content": ModelPrompts.getPromptEnglish(widget.modelName),
      },
    ];
  }

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
                      if (isUser)
                        Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      else
                        GptMarkdown(
                          message,
                          style: const TextStyle(
                            color: Colors.black,
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
