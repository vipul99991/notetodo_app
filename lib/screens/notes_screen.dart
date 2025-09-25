import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart' as note_service;
import '../widgets/note_card.dart';
import '../widgets/filter_bar.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> allNotes = [];
  List<Note> filteredNotes = [];

  String searchQuery = '';
  String selectedTag = 'All';
  Color selectedColor = Colors.transparent;
  bool showFavorites = false;
  DateTimeRange? customRange;

  // Multi-select
  Set<String> selectedNoteIds = {};
  bool isMultiSelectMode = false;

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
    _initializeNotes();
  }

  void _initializeNotes() {
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
    filteredNotes = List.from(allNotes);
  }

  void applyFilters() {
    List<Note> notes = allNotes;

    if (customRange != null) {
      notes = note_service.NoteService.filterByDate(notes, 'custom',
          customRange: customRange);
    }
    if (showFavorites) notes = note_service.NoteService.filterFavorites(notes);
    if (searchQuery.isNotEmpty)
      notes = note_service.NoteService.filterBySearch(notes, searchQuery);
    if (selectedTag != 'All')
      notes = note_service.NoteService.filterByTag(notes, selectedTag);
    if (selectedColor != Colors.transparent)
      notes = note_service.NoteService.filterByColor(notes, selectedColor as note_service.Color);

    setState(() {
      filteredNotes = notes;
    });
  }

  void toggleSelectNote(String id) {
    setState(() {
      if (selectedNoteIds.contains(id)) {
        selectedNoteIds.remove(id);
      } else {
        selectedNoteIds.add(id);
      }
      isMultiSelectMode = selectedNoteIds.isNotEmpty;
    });
  }

  void deleteSelectedNotes() {
    setState(() {
      allNotes.removeWhere((note) => selectedNoteIds.contains(note.id));
      selectedNoteIds.clear();
      isMultiSelectMode = false;
      applyFilters();
    });
  }

  void addOrEditNote({Note? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    String selectedTagDialog = note?.tag ?? 'Work';
    Color selectedColorDialog = note?.color ?? Colors.yellow;
    bool isFavoriteDialog = note?.isFavorite ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(note == null ? "Add Note" : "Edit Note",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Title")),
                  TextField(
                      controller: contentController,
                      decoration: const InputDecoration(labelText: "Content")),
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
                              setState(() => isFavoriteDialog = v ?? false)),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                          final index =
                              allNotes.indexWhere((n) => n.id == note.id);
                          allNotes[index] = newNote;
                        }
                        applyFilters();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
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
          if (isMultiSelectMode)
            IconButton(
                icon: const Icon(Icons.delete), onPressed: deleteSelectedNotes),
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
                  customRange = null;
                });
              }
              applyFilters();
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
        onPressed: () => addOrEditNote(),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FilterBar(
              searchQuery: searchQuery,
              onSearchChanged: (v) {
                searchQuery = v;
                applyFilters();
              },
              tags: tags,
              selectedTag: selectedTag,
              onTagSelected: (tag) {
                selectedTag = tag;
                applyFilters();
              },
              colors: colors,
              selectedColor: selectedColor,
              onColorSelected: (color) {
                selectedColor = color;
                applyFilters();
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final note = filteredNotes[index];
                return NoteCard(
                  note: note,
                  isSelected: selectedNoteIds.contains(note.id),
                  onTap: () {
                    if (isMultiSelectMode) {
                      toggleSelectNote(note.id);
                    } else {
                      addOrEditNote(note: note);
                    }
                  },
                  onLongPress: () => toggleSelectNote(note.id),
                  onEdit: () => addOrEditNote(note: note),
                  onDelete: () => deleteNote(note),
                );
              },
              childCount: filteredNotes.length,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget? NoteCard({required Note note, required bool isSelected, required Null Function() onTap, required void Function() onLongPress, required void Function() onEdit, required void Function() onDelete}) {}
}
