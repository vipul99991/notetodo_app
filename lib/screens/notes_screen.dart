import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart' as service; // <-- service.NoteService
import '../widgets/filter_panel.dart';
import '../widgets/animated_fab.dart';

class NotesScreen extends StatefulWidget {
  final service.NoteService noteService;
  final String? folderId;

  const NotesScreen({super.key, required this.noteService, this.folderId});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String query = '';
  bool favoritesOnly = false;
  String? folderId;
  String? tag;
  DateTimeRange? flutterDateRange; // Flutter UI DateTimeRange

  @override
  void initState() {
    super.initState();
    folderId = widget.folderId;
  }

  // Convert Flutter UI DateTimeRange -> service.NoteDateRange
  service.NoteDateRange? toServiceDateRange(DateTimeRange? flutterRange) {
    if (flutterRange == null) return null;
    return service.NoteDateRange(flutterRange.start, flutterRange.end);
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = widget.noteService.filterNotes(
      query: query,
      folderId: folderId,
      tag: tag,
      favoritesOnly: favoritesOnly,
      dateRange: toServiceDateRange(flutterDateRange),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search notes...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          FilterPanel(
            favoritesOnly: favoritesOnly,
            dateRange: flutterDateRange,
            onFilterChanged: ({
              String? folderId,
              String? tag,
              bool? favoritesOnly,
              DateTimeRange? dateRange,
            }) {
              setState(() {
                if (favoritesOnly != null) this.favoritesOnly = favoritesOnly;
                if (folderId != null) this.folderId = folderId;
                if (tag != null) this.tag = tag;
                if (dateRange != null) this.flutterDateRange = dateRange;
              });
            },
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(child: Text("No notes found"))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, i) {
                      final note = filteredNotes[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.content,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: note.isFavorite
                              ? const Icon(Icons.star, color: Colors.amber)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: AnimatedFAB(
        onAddText: () {
          final newNote = Note(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'New Note',
            content: 'Type here...',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          setState(() => widget.noteService.add(newNote));
        },
        onAddVoice: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice Note clicked!')));
        },
        onAddChecklist: () {
          final newNote = Note(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'New Checklist',
            content: '- [ ] Item 1\n- [ ] Item 2',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          setState(() => widget.noteService.add(newNote));
        },
      ),
    );
  }
}
