import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../widgets/chat/chat.dart';

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
      case 'j24':
        return 'J/24';
      case 'laser':
        return 'Laser';
      case 'swan50':
        return 'Swan 50';
      case 'x35':
        return 'X-35';
      case 'melges32':
        return 'Melges 32';
      case 'tp52':
        return 'TP52';
      case 'first36':
        return 'Beneteau First 36';
      case 'sunfast3300':
        return 'Jeanneau Sun Fast 3300';
      case 'dehler38':
        return 'Dehler 38';
      case 'xp44':
        return 'X-Yachts XP 44';
      case 'hanse458':
        return 'Hanse 458';
      case 'oceanis46':
        return 'Beneteau Oceanis 46';
      case 'swan48':
        return 'Nautor Swan 48';
      case 'gc42':
        return 'Grand Soleil GC 42';
      case 'rs21':
        return 'RS21';
      case 'j70':
        return 'J/70';
      case 'solaris44':
        return 'Solaris 44';
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
