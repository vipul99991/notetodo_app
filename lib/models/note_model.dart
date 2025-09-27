
import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final String tag;
  final Color color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    required this.tag,
    required this.color,
  });

  String? get date => null;
}
