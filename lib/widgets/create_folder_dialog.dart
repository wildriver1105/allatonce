import 'package:flutter/material.dart';
import '../services/manual_service.dart';

class CreateFolderDialog extends StatefulWidget {
  final ManualFolder? folder;

  const CreateFolderDialog({super.key, this.folder});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  Color _selectedColor;
  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.deepOrange,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.folder?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.folder?.description ?? '');
    _selectedColor = widget.folder?.color ?? Colors.blue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.folder != null;

    return AlertDialog(
      title: Text(isEditing ? '폴더 편집' : '새 폴더 생성'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '폴더 이름',
              hintText: '폴더 이름을 입력하세요',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: '설명 (선택사항)',
              hintText: '폴더에 대한 설명을 입력하세요',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          const Text(
            '폴더 색상',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _colorOptions.map((color) {
              final isSelected = _selectedColor == color;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 3)
                        : Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _saveFolder,
          child: Text(isEditing ? '저장' : '생성'),
        ),
      ],
    );
  }

  Future<void> _saveFolder() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('폴더 이름을 입력해주세요')),
      );
      return;
    }

    if (widget.folder != null) {
      final success = await ManualService.updateFolder(
        widget.folder!.id,
        name,
        _selectedColor,
        _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('폴더가 성공적으로 업데이트되었습니다')),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('폴더 업데이트에 실패했습니다')),
        );
      }
    } else {
      final folder = await ManualService.createFolder(
        name,
        _selectedColor,
        _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (folder != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('폴더가 성공적으로 생성되었습니다')),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('폴더 생성에 실패했습니다')),
        );
      }
    }
  }
}

