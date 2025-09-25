import '../models/note.dart';
import 'package:flutter/material.dart';

class NoteService {
  static List<Note> filterByDate(List<Note> notes, String filterType,
      {DateTimeRange? customRange}) {
    final now = DateTime.now();
    switch (filterType) {
      case 'today':
        return notes
            .where((n) =>
                n.createdAt.day == now.day &&
                n.createdAt.month == now.month &&
                n.createdAt.year == now.year)
            .toList();
      case 'last7days':
        final weekAgo = now.subtract(const Duration(days: 7));
        return notes.where((n) => n.createdAt.isAfter(weekAgo)).toList();
      case 'thismonth':
        return notes
            .where((n) =>
                n.createdAt.month == now.month && n.createdAt.year == now.year)
            .toList();
      case 'custom':
        if (customRange != null) {
          return notes
              .where((n) =>
                  n.createdAt.isAfter(
                      customRange.start.subtract(const Duration(seconds: 1))) &&
                  n.createdAt
                      .isBefore(customRange.end.add(const Duration(days: 1))))
              .toList();
        }
        return notes;
      default:
        return notes;
    }
  }

  static List<Note> filterBySearch(List<Note> notes, String query) {
    return notes
        .where((n) =>
            n.title.toLowerCase().contains(query.toLowerCase()) ||
            n.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<Note> filterFavorites(List<Note> notes) {
    return notes.where((n) => n.isFavorite).toList();
  }

  // New: Filter by tag
  static List<Note> filterByTag(List<Note> notes, String tag) {
    if (tag == 'All') return notes;
    return notes.where((n) => n.tag == tag).toList();
  }

  // New: Filter by color
  static List<Note> filterByColor(List<Note> notes, Color color) {
    if (color == Colors.transparent) return notes; // All colors
    return notes.where((n) => n.color == color).toList();
  }
}
