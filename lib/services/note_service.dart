// ✅ All imports must be at the top
import '../models/note.dart';

// Now your declarations
class NoteDateRange {
  DateTime start;
  DateTime end;

  NoteDateRange(this.start, this.end);
}

class NoteService {
  final List<Note> _notes = [];

  List<Note> get allNotes => _notes;
  List<Note> get activeNotes => _notes.where((n) => !n.isDeleted).toList();

  get folders => null;

  void add(Note note) => _notes.add(note);

  void update(Note note) {
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) _notes[index] = note;
  }

  List<Note> filterNotes({
    String? query,
    String? folderId,
    String? tag,
    bool favoritesOnly = false,
    NoteDateRange? dateRange,
  }) {
    return activeNotes.where((note) {
      final matchesQuery = query == null || query.isEmpty
          ? true
          : note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase());

      final matchesFolder = folderId == null || note.folderId == folderId;
      final matchesTag = tag == null || note.tags.contains(tag);
      final matchesFavorite = !favoritesOnly || note.isFavorite;
      final matchesDate = dateRange == null ||
          (note.createdAt.isAfter(dateRange.start) &&
              note.createdAt.isBefore(dateRange.end));

      return matchesQuery &&
          matchesFolder &&
          matchesTag &&
          matchesFavorite &&
          matchesDate;
    }).toList();
  }

  void addFolder(String text) {}
}
