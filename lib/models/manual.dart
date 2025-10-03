import 'package:flutter/material.dart';

class Manual {
  final String id;
  final String name;
  String filePath;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  String folderId;
  final String category;
  final double fileSize;

  Manual({
    required this.id,
    required this.name,
    required this.filePath,
    required this.createdAt,
    this.modifiedAt,
    required this.folderId,
    required this.category,
    required this.fileSize,
  });

  Manual copyWith({
    String? id,
    String? name,
    String? filePath,
    DateTime? createdAt,
    DateTime? modifiedAt,
    String? folderId,
    String? category,
    double? fileSize,
  }) {
    return Manual(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      folderId: folderId ?? this.folderId,
      category: category ?? this.category,
      fileSize: fileSize ?? this.fileSize,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
      'folderId': folderId,
      'category': category,
      'fileSize': fileSize,
    };
  }

  factory Manual.fromMap(Map<String, dynamic> map) {
    return Manual(
      id: map['id'],
      name: map['name'],
      filePath: map['filePath'],
      createdAt: DateTime.parse(map['createdAt']),
      modifiedAt:
          map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt']) : null,
      folderId: map['folderId'],
      category: map['category'],
      fileSize: map['fileSize'].toDouble(),
    );
  }

  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '${fileSize.toStringAsFixed(0)} bytes';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get fileExtension {
    return name.split('.').last.toLowerCase();
  }

  IconData get fileIcon {
    switch (fileExtension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  String toString() {
    return 'Manual(id: $id, name: $name, createdAt: $createdAt, folderId: $folderId, category: $category, fileSize: $fileSizeFormatted)';
  }
}

