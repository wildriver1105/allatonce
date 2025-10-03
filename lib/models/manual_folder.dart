import 'package:flutter/material.dart';

class ManualFolder {
  final String id;
  String name;
  final DateTime createdAt;
  DateTime? modifiedAt;
  final Color color;
  String? description;

  ManualFolder({
    required this.id,
    required this.name,
    required this.createdAt,
    this.modifiedAt,
    required this.color,
    this.description,
  });

  ManualFolder copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? modifiedAt,
    Color? color,
    String? description,
  }) {
    return ManualFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      color: color ?? this.color,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
      'color': color.value,
      'description': description,
    };
  }

  factory ManualFolder.fromMap(Map<String, dynamic> map) {
    return ManualFolder(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']),
      modifiedAt:
          map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt']) : null,
      color: Color(map['color']),
      description: map['description'],
    );
  }

  @override
  String toString() {
    return 'ManualFolder(id: $id, name: $name, createdAt: $createdAt, color: $color, description: $description)';
  }
}

