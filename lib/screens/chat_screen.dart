import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/chat.dart';
import 'home_screen.dart';

class ChatScreen extends StatelessWidget {
  final String modelName;

  const ChatScreen({
    super.key,
    this.modelName = '',
  });

  String _getDisplayName(String modelId) {
    switch (modelId) {
      case 'fareast28':
        return 'FarEast28';
      case 'farr40':
        return 'Farr40';
      case 'benetau473':
        return 'Benetaur473';
      default:
        return modelId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.sailing, size: 24),
            const SizedBox(width: 8),
            Text(_getDisplayName(modelName)),
          ],
        ),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ChatWidget(modelName: modelName),
    );
  }
}
