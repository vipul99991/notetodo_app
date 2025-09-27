
import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteService {
  static List<Note> filterByDate(List<Note> notes, String filter,
      {DateTimeRange? customRange}) {
    final now = DateTime.now();
    switch (filter) {
      case 'today':
        return notes
            .where((note) =>
                note.createdAt.year == now.year &&
                note.createdAt.month == now.month &&
                note.createdAt.day == now.day)
            .toList();
      case 'last7days':
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        return notes
            .where((note) => note.createdAt.isAfter(sevenDaysAgo))
            .toList();
      case 'thismonth':
        return notes
            .where((note) =>
                note.createdAt.year == now.year &&
                note.createdAt.month == now.month)
            .toList();
      case 'custom':
        if (customRange != null) {
          return notes
              .where((note) =>
                  note.createdAt.isAfter(customRange.start) &&
                  note.createdAt.isBefore(customRange.end))
              .toList();
        }
        return notes;
      default:
        return notes;
    }
  }

  static List<Note> filterFavorites(List<Note> notes) {
    return notes.where((note) => note.isFavorite).toList();
  }

  static List<Note> filterBySearch(List<Note> notes, String query) {
    return notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static List<Note> filterByTag(List<Note> notes, String tag) {
    return notes.where((note) => note.tag == tag).toList();
  }

  static List<Note> filterByColor(List<Note> notes, Color color) {
    return notes.where((note) => note.color == color).toList();
  }
}
