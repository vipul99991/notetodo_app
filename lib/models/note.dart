import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final String tag; // e.g., 'Work', 'Personal'
  final Color color; // e.g., Colors.yellow

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.tag = 'General',
    this.color = Colors.white,
  });
}
