import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart' as note_service;

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> allNotes = [];
  List<Note> filteredNotes = [];

  String selectedDateFilter = 'all';
  String searchQuery = '';
  bool showFavorites = false;
  DateTimeRange? customRange; // Flutter DateTimeRange

  @override
  void initState() {
    super.initState();
    allNotes = [
      Note(
        id: '1',
        title: 'Flutter Notes',
        content: 'Learn state management',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now(),
        isFavorite: true,
      ),
      Note(
        id: '2',
        title: 'Shopping List',
        content: 'Milk, Eggs, Bread',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Note(
        id: '3',
        title: 'Work Tasks',
        content: 'Finish project report',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        isFavorite: true,
      ),
    ];
    filteredNotes = allNotes;
  }

  void applyFilters() {
    List<Note> notes = allNotes;

    // Date filter
    if (selectedDateFilter != 'all') {
      notes = note_service.NoteService.filterByDate(
        notes,
        selectedDateFilter,
        customRange: customRange,
      );
    }

    // Favorites filter
    if (showFavorites) {
      notes = note_service.NoteService.filterFavorites(notes);
    }

    // Search filter
    if (searchQuery.isNotEmpty) {
      notes = note_service.NoteService.filterBySearch(notes, searchQuery);
    }

    setState(() {
      filteredNotes = notes;
    });
  }

  Future<void> pickCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: customRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
    );

    if (picked != null) {
      setState(() {
        customRange = picked;
        selectedDateFilter = 'custom';
      });
      applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          IconButton(
            icon: Icon(showFavorites ? Icons.star : Icons.star_border),
            onPressed: () {
              setState(() => showFavorites = !showFavorites);
              applyFilters();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'custom') {
                await pickCustomDateRange();
              } else {
                setState(() {
                  selectedDateFilter = value;
                  customRange = null;
                });
                applyFilters();
              }
            },
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text("All")),
              const PopupMenuItem(value: 'today', child: Text("Today")),
              const PopupMenuItem(
                  value: 'last7days', child: Text("Last 7 Days")),
              const PopupMenuItem(
                  value: 'thismonth', child: Text("This Month")),
              const PopupMenuItem(value: 'custom', child: Text("Custom Range")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search notes...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
                applyFilters();
              },
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(
                    child:
                        Text("No notes found.", style: TextStyle(fontSize: 18)))
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(note.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(note.content,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: note.isFavorite
                              ? const Icon(Icons.star, color: Colors.yellow)
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
