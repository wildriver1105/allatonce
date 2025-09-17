import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/chat.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.sailing, size: 24),
            SizedBox(width: 8),
            Text('Yacht Model X'),
          ],
        ),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const ChatWidget(),
    );
  }
}
