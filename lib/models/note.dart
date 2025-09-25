import 'package:flutter/material.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  bool isPinned;
  bool isArchived;
  String tag;
  Color color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.isPinned = false,
    this.isArchived = false,
    this.tag = 'Work',
    this.color = Colors.yellow,
  });
}
