import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/manual.dart';
import '../models/manual_folder.dart';
import '../services/manual_service.dart';
import 'upload_manual_dialog.dart';

class ManualListWidget extends StatefulWidget {
  final String folderId;
  final ManualFolder folder;

  const ManualListWidget({
    super.key,
    required this.folderId,
    required this.folder,
  });

  @override
  State<ManualListWidget> createState() => _ManualListWidgetState();
}

class _ManualListWidgetState extends State<ManualListWidget> {
  List<Manual> _manuals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadManuals();
  }

  Future<void> _loadManuals() async {
    setState(() => _isLoading = true);
    final manuals = await ManualService.getManualsByFolder(widget.folderId);
    setState(() {
      _manuals = manuals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.folder.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.folder.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.folder.description != null)
                      Text(
                        widget.folder.description!,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),
              FloatingActionButton.small(
                onPressed: _uploadManual,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_manuals.isEmpty)
          Center(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Icon(
                  Icons.folder_open,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  '메뉴얼이 없습니다',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '아래 + 버튼을 눌러 메뉴얼을 추가하세요',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _uploadManual,
                  icon: const Icon(Icons.add),
                  label: const Text('업로드하기'),
                ),
              ],
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: _manuals.length,
              itemBuilder: (context, index) =>
                  _buildManualItem(_manuals[index]),
            ),
          ),
      ],
    );
  }

  Widget _buildManualItem(Manual manual) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.folder.color.withOpacity(0.2),
          child: Icon(
            manual.fileIcon,
            color: widget.folder.color,
          ),
        ),
        title: Text(
          manual.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${manual.category} • ${manual.fileSizeFormatted}'),
            Text(
              '업로드: ${_formatDate(manual.createdAt)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_red_eye),
              onPressed: () => _viewManual(manual),
              tooltip: '보기',
            ),
          ],
        ),
        onTap: () => _showManualOptions(manual),
      ),
    );
  }

  Future<void> _uploadManual() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const UploadManualDialog(),
    );

    if (result == true) {
      _loadManuals();
    }
  }

  Future<void> _viewManual(Manual manual) async {
    // TODO: Implement manual viewing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${manual.name} 보기 기능은 곧 추가될 예정입니다')),
    );
  }

  Future<void> _showManualOptions(Manual manual) async {
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.remove_red_eye),
              title: const Text('보기'),
              onTap: () {
                Navigator.pop(context);
                _viewManual(manual);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('파일명 복사'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: manual.name));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('파일명이 복사되었습니다')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('삭제'),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(manual);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(Manual manual) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('메뉴얼 삭제'),
        content: Text('${manual.name}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await ManualService.deleteManual(manual.id);
      if (success) {
        _loadManuals();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${manual.name}이(가) 삭제되었습니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제에 실패했습니다')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '오늘 ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${date.year}.${date.month}.${date.day}';
    }
  }
}
