import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/manual.dart';
import '../models/manual_folder.dart';

class ManualService {
  static const String _manualsKey = 'manuals';
  static const String _foldersKey = 'manual_folders';

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Manual Folder Management
  static Future<List<ManualFolder>> getAllFolders() async {
    final prefs = await ManualService.prefs;
    final String? foldersJson = prefs.getString(_foldersKey);

    if (foldersJson == null) {
      return await _initializeDefaultFolders();
    }

    final List<dynamic> foldersList = json.decode(foldersJson);
    return foldersList.map((json) => ManualFolder.fromMap(json)).toList();
  }

  static Future<ManualFolder?> createFolder(
      String name, Color color, String? description) async {
    try {
      final folders = await getAllFolders();

      final newFolder = ManualFolder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        createdAt: DateTime.now(),
        color: color,
        description: description,
      );

      folders.add(newFolder);
      await _saveFolders(folders);
      return newFolder;
    } catch (e) {
      print('Error creating folder: $e');
      return null;
    }
  }

  static Future<bool> updateFolder(
      String id, String name, Color color, String? description) async {
    try {
      final folders = await getAllFolders();
      final index = folders.indexWhere((folder) => folder.id == id);

      if (index != -1) {
        folders[index] = folders[index].copyWith(
          name: name,
          color: color,
          description: description,
          modifiedAt: DateTime.now(),
        );

        await _saveFolders(folders);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating folder: $e');
      return false;
    }
  }

  static Future<bool> deleteFolder(String id) async {
    try {
      final folders = await getAllFolders();
      final manuals = await getAllManuals();

      // Move manuals in this folder to default folder (id: '0')
      for (int i = 0; i < manuals.length; i++) {
        if (manuals[i].folderId == id) {
          manuals[i] = manuals[i].copyWith(folderId: '0');
        }
      }

      folders.removeWhere((folder) => folder.id == id);

      await _saveFolders(folders);
      await _saveManuals(manuals);
      return true;
    } catch (e) {
      print('Error deleting folder: $e');
      return false;
    }
  }

  // Manual Management
  static Future<List<Manual>> getAllManuals() async {
    final prefs = await ManualService.prefs;
    final String? manualsJson = prefs.getString(_manualsKey);

    if (manualsJson == null) {
      return [];
    }

    final List<dynamic> manualsList = json.decode(manualsJson);
    return manualsList.map((json) => Manual.fromMap(json)).toList();
  }

  static Future<List<Manual>> getManualsByFolder(String folderId) async {
    final manuals = await getAllManuals();
    return manuals.where((manual) => manual.folderId == folderId).toList();
  }

  static Future<FilePickerResult?> pickFile() async {
    try {
      return await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt',
          'jpg',
          'jpeg',
          'png',
          'gif'
        ],
      );
    } catch (e) {
      print('Error picking file: $e');
      return null;
    }
  }

  static Future<Manual?> uploadManual(
      FilePickerResult fileResult, String folderId) async {
    try {
      final file = File(fileResult.files.single.path!);
      final fileName = fileResult.files.single.name;

      // Ensure app documents directory exists
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFileName = '${timestamp}_$fileName';
      final newFilePath = '${directory.path}/manuals/$newFileName';

      // Create manuals directory if it doesn't exist
      final manualsDir = Directory('${directory.path}/manuals');
      if (!await manualsDir.exists()) {
        await manualsDir.create(recursive: true);
      }

      // Copy file to the new directory
      await file.copy(newFilePath);

      final manual = Manual(
        id: timestamp.toString(),
        name: fileName,
        filePath: newFilePath,
        createdAt: DateTime.now(),
        folderId: folderId,
        category: _getCategoryFromExtension(fileName.split('.').last),
        fileSize: (await file.length()).toDouble(),
      );

      final manuals = await getAllManuals();
      manuals.add(manual);
      await _saveManuals(manuals);

      return manual;
    } catch (e) {
      print('Error uploading manual: $e');
      return null;
    }
  }

  static Future<bool> deleteManual(String id) async {
    try {
      final manuals = await getAllManuals();
      final index = manuals.indexWhere((manual) => manual.id == id);

      if (index != -1) {
        final manual = manuals[index];
        final file = File(manual.filePath);

        // Remove file from storage
        if (await file.exists()) {
          await file.delete();
        }

        // Remove from list
        manuals.removeAt(index);
        await _saveManuals(manuals);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting manual: $e');
      return false;
    }
  }

  static Future<bool> moveManualToFolder(
      String manualId, String folderId) async {
    try {
      final manuals = await getAllManuals();
      final index = manuals.indexWhere((manual) => manual.id == manualId);

      if (index != -1) {
        manuals[index] = manuals[index].copyWith(
          folderId: folderId,
          modifiedAt: DateTime.now(),
        );

        await _saveManuals(manuals);
        return true;
      }
      return false;
    } catch (e) {
      print('Error moving manual: $e');
      return false;
    }
  }

  static String _getCategoryFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'PDF 문서';
      case 'doc':
      case 'docx':
        return '문서';
      case 'txt':
        return '텍스트';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return '이미지';
      default:
        return '기타';
    }
  }

  // Helper methods
  static Future<void> _saveFolders(List<ManualFolder> folders) async {
    final prefs = await ManualService.prefs;
    final foldersJson =
        json.encode(folders.map((folder) => folder.toMap()).toList());
    await prefs.setString(_foldersKey, foldersJson);
  }

  static Future<void> _saveManuals(List<Manual> manuals) async {
    final prefs = await ManualService.prefs;
    final manualsJson =
        json.encode(manuals.map((manual) => manual.toMap()).toList());
    await prefs.setString(_manualsKey, manualsJson);
  }

  static Future<List<ManualFolder>> _initializeDefaultFolders() async {
    final defaultFolders = [
      ManualFolder(
        id: '0',
        name: '기본',
        createdAt: DateTime.now(),
        color: Colors.blue,
        description: '기본 폴더',
      ),
      ManualFolder(
        id: '1',
        name: '배송 메뉴얼',
        createdAt: DateTime.now(),
        color: Colors.green,
        description: '배송 관련 메뉴얼',
      ),
      ManualFolder(
        id: '2',
        name: '제품 메뉴얼',
        createdAt: DateTime.now(),
        color: Colors.orange,
        description: '제품 관련 메뉴얼',
      ),
    ];

    await _saveFolders(defaultFolders);

    return defaultFolders;
  }
}
