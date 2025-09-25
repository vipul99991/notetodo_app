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
  DateTimeRange? customRange;

  String selectedTag = 'All';
  Color selectedColor = Colors.transparent;

  final List<String> tags = ['All', 'Work', 'Personal', 'Shopping', 'Other'];
  final List<Color> colors = [
    Colors.transparent,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.red
  ];

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
        tag: 'Work',
        color: Colors.yellow,
      ),
      Note(
        id: '2',
        title: 'Shopping List',
        content: 'Milk, Eggs, Bread',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tag: 'Shopping',
        color: Colors.green,
      ),
      Note(
        id: '3',
        title: 'Work Tasks',
        content: 'Finish project report',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
        isFavorite: true,
        tag: 'Work',
        color: Colors.red,
      ),
    ];
    filteredNotes = allNotes;
  }

  void applyFilters() {
    List<Note> notes = allNotes;

    if (selectedDateFilter != 'all') {
      notes = note_service.NoteService.filterByDate(notes, selectedDateFilter,
          customRange: customRange);
    }
    if (showFavorites) notes = note_service.NoteService.filterFavorites(notes);
    if (searchQuery.isNotEmpty)
      notes = note_service.NoteService.filterBySearch(notes, searchQuery);
    if (selectedTag != 'All')
      notes = note_service.NoteService.filterByTag(notes, selectedTag);
    if (selectedColor != Colors.transparent)
      notes = note_service.NoteService.filterByColor(notes, selectedColor);

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
              end: DateTime.now()),
    );

    if (picked != null) {
      setState(() {
        customRange = picked;
        selectedDateFilter = 'custom';
      });
      applyFilters();
    }
  }

  Future<void> openNoteDialog({Note? note}) async {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    String selectedTagDialog = note?.tag ?? 'Work';
    Color selectedColorDialog = note?.color ?? Colors.yellow;
    bool isFavoriteDialog = note?.isFavorite ?? false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? "Add Note" : "Edit Note"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: "Content"),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedTagDialog,
                  items: tags
                      .where((t) => t != 'All')
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (v) => selectedTagDialog = v ?? 'Work',
                  decoration: const InputDecoration(labelText: "Tag"),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children:
                      colors.where((c) => c != Colors.transparent).map((c) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedColorDialog = c),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: selectedColorDialog == c
                              ? Border.all(width: 2, color: Colors.black)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Favorite: "),
                    Checkbox(
                      value: isFavoriteDialog,
                      onChanged: (v) =>
                          setState(() => isFavoriteDialog = v ?? false),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final newNote = Note(
                  id: note?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: note?.createdAt ?? DateTime.now(),
                  updatedAt: DateTime.now(),
                  isFavorite: isFavoriteDialog,
                  tag: selectedTagDialog,
                  color: selectedColorDialog,
                );

                setState(() {
                  if (note == null) {
                    allNotes.add(newNote);
                  } else {
                    final index = allNotes.indexWhere((n) => n.id == note.id);
                    allNotes[index] = newNote;
                  }
                });
                applyFilters();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void deleteNote(Note note) {
    setState(() {
      allNotes.removeWhere((n) => n.id == note.id);
      applyFilters();
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteDialog(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search bar
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

          // Tag Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (context, index) {
                final tag = tags[index];
                final selected = tag == selectedTag;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => selectedTag = tag);
                      applyFilters();
                    },
                  ),
                );
              },
            ),
          ),

          // Color Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                final selected = color == selectedColor;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedColor = color);
                      applyFilters();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color == Colors.transparent
                            ? Colors.grey[300]
                            : color,
                        shape: BoxShape.circle,
                        border: selected
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Notes List
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
                        color: note.color,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          title: Text(note.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(note.content,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (note.isFavorite)
                                const Icon(Icons.star, color: Colors.yellow),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => openNoteDialog(note: note),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteNote(note),
                              ),
                            ],
                          ),
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
