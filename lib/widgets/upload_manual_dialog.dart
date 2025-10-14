import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/manual_service.dart';
import '../models/manual_folder.dart';

class UploadManualDialog extends StatefulWidget {
  const UploadManualDialog({super.key});

  @override
  State<UploadManualDialog> createState() => _UploadManualDialogState();
}

class _UploadManualDialogState extends State<UploadManualDialog> {
  FilePickerResult? _selectedFile;
  String? _selectedFolderId;
  List<ManualFolder> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final folders = await ManualService.getAllFolders();
    setState(() {
      _folders = folders;
      _selectedFolderId = folders.isNotEmpty ? folders.first.id : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('메뉴얼 업로드'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '파일 선택',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _pickFile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_selectedFile == null
                    ? Icons.upload_file
                    : Icons.file_copy),
                const SizedBox(width: 8),
                Text(
                  _selectedFile?.files.single.name ?? '파일 선택',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (_selectedFile != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '파일: ${_selectedFile!.files.single.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '크기: ${_getFileSize(_selectedFile!.files.single.size)}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '타입: ${_selectedFile!.files.single.extension?.toUpperCase() ?? 'Unknown'}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            '저장할 폴더',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          if (_folders.isNotEmpty)
            DropdownButtonFormField<String>(
              value: _selectedFolderId,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _folders.map((folder) {
                return DropdownMenuItem<String>(
                  value: folder.id,
                  child: Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: folder.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(folder.name)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedFolderId = value),
            )
          else
            const Text(
              '폴더가 없습니다. 먼저 폴더를 생성해주세요.',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _selectedFile != null && _selectedFolderId != null
              ? _uploadFile
              : null,
          child: const Text('업로드'),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    final result = await ManualService.pickFile();
    if (result != null) {
      setState(() => _selectedFile = result);
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null || _selectedFolderId == null) return;

    try {
      Navigator.of(context).pop();

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final manual =
          await ManualService.uploadManual(_selectedFile!, _selectedFolderId!);

      // Hide loading indicator
      Navigator.of(context).pop();

      if (manual != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${manual.name} 업로드가 완료되었습니다')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('파일 업로드에 실패했습니다')),
          );
        }
      }
    } catch (e) {
      Navigator.of(context).pop(); // Hide loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  String _getFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes bytes';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}
