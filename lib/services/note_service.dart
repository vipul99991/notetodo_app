import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteService {
  static List<Note> filterByDate(List<Note> notes, String filter,
      {DateTimeRange? customRange}) {
    final now = DateTime.now();
    switch (filter) {
      case 'today':
        return notes
            .where((n) =>
                n.createdAt.day == now.day &&
                n.createdAt.month == now.month &&
                n.createdAt.year == now.year)
            .toList();
      case 'last7days':
        return notes
            .where((n) =>
                n.createdAt.isAfter(now.subtract(const Duration(days: 7))))
            .toList();
      case 'thismonth':
        return notes
            .where((n) =>
                n.createdAt.month == now.month && n.createdAt.year == now.year)
            .toList();
      case 'custom':
        if (customRange != null)
          return notes
              .where((n) =>
                  n.createdAt.isAfter(
                      customRange.start.subtract(const Duration(seconds: 1))) &&
                  n.createdAt.isBefore(
                      customRange.end.add(const Duration(seconds: 1))))
              .toList();
        return notes;
      default:
        return notes;
    }
  }

  static List<Note> filterFavorites(List<Note> notes) =>
      notes.where((n) => n.isFavorite).toList();
  static List<Note> filterBySearch(List<Note> notes, String query) => notes
      .where((n) =>
          n.title.toLowerCase().contains(query.toLowerCase()) ||
          n.content.toLowerCase().contains(query.toLowerCase()))
      .toList();
  static List<Note> filterByTag(List<Note> notes, String tag) =>
      notes.where((n) => n.tag == tag).toList();
  static List<Note> filterByColor(List<Note> notes, Color color) =>
      notes.where((n) => n.color == color).toList();
}

class Color {
}
