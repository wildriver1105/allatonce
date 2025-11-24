import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/manual_service.dart';
import '../../models/manual_folder.dart';
import '../../widgets/create_folder_dialog.dart';
import '../../widgets/upload_manual_dialog.dart';
import '../../widgets/manual_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ManualFolder> _folders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFolders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadFolders() async {
    setState(() => _isLoading = true);
    final folders = await ManualService.getAllFolders();
    setState(() {
      _folders = folders;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('메뉴얼 관리'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(
              text: '폴더 관리',
              icon: Icon(Icons.folder),
            ),
            Tab(
              text: '메뉴얼 보기',
              icon: Icon(Icons.description),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildFolderManagementTab(),
                _buildManualViewTab(),
              ],
            ),
    );
  }

  Widget _buildFolderManagementTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '메뉴얼 폴더',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: _createFolder,
                icon: const Icon(Icons.create_new_folder),
                label: const Text('새 폴더'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _folders.isEmpty && !_isLoading
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _folders.length,
                  itemBuilder: (context, index) =>
                      _buildFolderItem(_folders[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildManualViewTab() {
    return _folders.isEmpty
        ? _buildEmptyManualState()
        : PageView.builder(
            itemCount: _folders.length,
            itemBuilder: (context, index) => ManualListWidget(
              folderId: _folders[index].id,
              folder: _folders[index],
            ),
          );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '폴더가 없습니다',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '메뉴얼을 쉽게 관리하기 위해\n폴더를 만들어보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createFolder,
            icon: const Icon(Icons.create_new_folder),
            label: const Text('첫 번째 폴더 만들기'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyManualState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '메뉴얼이 없습니다',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '폴더를 생성하고\n메뉴얼을 업로드해보세요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: _createFolder,
                icon: const Icon(Icons.create_new_folder),
                label: const Text('폴더 만들기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _uploadManual,
                icon: const Icon(Icons.upload_file),
                label: const Text('메뉴얼 업로드'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItem(ManualFolder folder) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: folder.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: folder.color.withOpacity(0.5)),
          ),
          child: Icon(
            Icons.folder,
            color: folder.color,
            size: 28,
          ),
        ),
        title: Text(
          folder.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: folder.description != null
            ? Text(folder.description!)
            : Text(
                'Created ${_formatDate(folder.createdAt)}',
                style: TextStyle(color: Colors.grey[600]!),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editFolder(folder),
              tooltip: '편집',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDeleteFolder(folder),
              tooltip: '삭제',
            ),
          ],
        ),
        onTap: () => _tabController.animateTo(1),
      ),
    );
  }

  Future<void> _createFolder() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateFolderDialog(),
    );

    if (result == true) {
      _loadFolders();
    }
  }

  Future<void> _editFolder(ManualFolder folder) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => CreateFolderDialog(folder: folder),
    );

    if (result == true) {
      _loadFolders();
    }
  }

  Future<void> _confirmDeleteFolder(ManualFolder folder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('폴더 삭제'),
        content:
            Text('${folder.name} 폴더를 삭제하시겠습니까?\n폴더 안의 모든 메뉴얼은 기본 폴더로 이동됩니다.'),
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
      final success = await ManualService.deleteFolder(folder.id);
      if (success) {
        _loadFolders();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${folder.name} 폴더가 삭제되었습니다')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('폴더 삭제에 실패했습니다')),
        );
      }
    }
  }

  Future<void> _uploadManual() async {
    if (_folders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 폴더를 생성해주세요')),
      );
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const UploadManualDialog(),
    );

    if (result == true) {
      _loadFolders();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '오늘';
    } else if (difference.inDays == 1) {
      return '어제';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}일 전';
    } else {
      return '${date.year}.${date.month}.${date.day}';
    }
  }
}
