import 'package:flutter/material.dart';

// --- Data Model ---
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  String tag;
  Color color;

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
}

// --- Main Screen Widget ---
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
  String dateFilter = 'all';

  // Multi-select
  Set<String> selectedNoteIds = {};
  bool get isMultiSelectMode => selectedNoteIds.isNotEmpty;

  final List<String> tags = ['All', 'Work', 'Personal', 'Shopping', 'Other'];
  final List<Color> colors = [
    Colors.transparent,
    Colors.blue.shade100,
    Colors.red.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotes();
  }

  void _initializeNotes() {
    // Sample data
    allNotes = [
      Note(id: '1', title: 'Work Meeting', content: 'Discuss Q3 roadmap.', createdAt: DateTime.now().subtract(const Duration(days: 1)), updatedAt: DateTime.now(), tag: 'Work', color: colors[1], isFavorite: true),
      Note(id: '2', title: 'Groceries', content: 'Milk, Bread, Eggs.', createdAt: DateTime.now().subtract(const Duration(days: 3)), updatedAt: DateTime.now(), tag: 'Shopping', color: colors[2]),
      Note(id: '3', title: 'Flutter Project', content: 'Fix bugs in notes screen.', createdAt: DateTime.now(), updatedAt: DateTime.now(), tag: 'Personal', color: colors[3]),
      Note(id: '4', title: 'Dentist Appointment', content: 'Scheduled for next week.', createdAt: DateTime.now().subtract(const Duration(days: 8)), updatedAt: DateTime.now(), tag: 'Personal', color: colors[4]),
    ];
    applyFilters();
  }

  void applyFilters() {
    List<Note> tempNotes = List.from(allNotes);

    // Search
    if (searchQuery.isNotEmpty) {
      tempNotes = tempNotes.where((note) => note.title.toLowerCase().contains(searchQuery.toLowerCase()) || note.content.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }

    // Tag
    if (selectedTag != 'All') {
      tempNotes = tempNotes.where((note) => note.tag == selectedTag).toList();
    }

    // Color
    if (selectedColor != Colors.transparent) {
      tempNotes = tempNotes.where((note) => note.color == selectedColor).toList();
    }

    // Favorites
    if (showFavorites) {
      tempNotes = tempNotes.where((note) => note.isFavorite).toList();
    }

    // Date
    final now = DateTime.now();
    if (dateFilter == 'today') {
      tempNotes = tempNotes.where((note) => note.createdAt.year == now.year && note.createdAt.month == now.month && note.createdAt.day == now.day).toList();
    } else if (dateFilter == 'last7days') {
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      tempNotes = tempNotes.where((note) => note.createdAt.isAfter(sevenDaysAgo)).toList();
    } else if (dateFilter == 'thismonth') {
      tempNotes = tempNotes.where((note) => note.createdAt.year == now.year && note.createdAt.month == now.month).toList();
    } else if (dateFilter == 'custom' && customRange != null) {
      tempNotes = tempNotes.where((note) => note.createdAt.isAfter(customRange!.start) && note.createdAt.isBefore(customRange!.end.add(const Duration(days: 1)))).toList();
    }

    setState(() {
      filteredNotes = tempNotes;
    });
  }

  void toggleSelectNote(String id) {
    setState(() {
      if (selectedNoteIds.contains(id)) {
        selectedNoteIds.remove(id);
      } else {
        selectedNoteIds.add(id);
      }
    });
  }

  void deleteSelectedNotes() {
    setState(() {
      allNotes.removeWhere((note) => selectedNoteIds.contains(note.id));
      selectedNoteIds.clear();
      applyFilters();
    });
  }

  void addOrEditNote({Note? note}) {
    final titleController = TextEditingController(text: note?.title);
    final contentController = TextEditingController(text: note?.content);
    String selectedTagDialog = note?.tag ?? 'Personal';
    Color selectedColorDialog = note?.color ?? colors[1];
    bool isFavoriteDialog = note?.isFavorite ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text(note == null ? "Add Note" : "Edit Note"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
                  const SizedBox(height: 10),
                  TextField(controller: contentController, decoration: const InputDecoration(labelText: "Content"), maxLines: 5),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedTagDialog,
                    onChanged: (v) => setStateDialog(() => selectedTagDialog = v!),
                    items: tags.where((t) => t != 'All').map((tag) => DropdownMenuItem(value: tag, child: Text(tag))).toList(),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: colors.where((c) => c != Colors.transparent).map((c) {
                      return GestureDetector(
                        onTap: () => setStateDialog(() => selectedColorDialog = c),
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
                        onChanged: (v) => setStateDialog(() => isFavoriteDialog = v!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final newNote = Note(
                    id: note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    content: contentController.text,
                    createdAt: note?.createdAt ?? DateTime.now(),
                    updatedAt: DateTime.now(),
                    tag: selectedTagDialog,
                    color: selectedColorDialog,
                    isFavorite: isFavoriteDialog,
                  );

                  setState(() {
                    if (note == null) {
                      allNotes.add(newNote);
                    } else {
                      final index = allNotes.indexWhere((n) => n.id == note.id);
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
        dateFilter = 'custom';
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
              setState(() {
                dateFilter = value;
                customRange = null;
              });

              if (value == 'custom') {
                await pickCustomDateRange();
              } else {
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
        onPressed: () => addOrEditNote(),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Search Notes",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  applyFilters();
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) {
                        return FilterChip(
                          label: Text(tag),
                          selected: selectedTag == tag,
                          onSelected: (selected) {
                            setState(() {
                              selectedTag = selected ? tag : 'All';
                            });
                            applyFilters();
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = selectedColor == color
                            ? Colors.transparent
                            : color;
                      });
                      applyFilters();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(width: 2, color: Colors.black)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final note = filteredNotes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    trailing: Icon(
                      note.isFavorite ? Icons.star : Icons.star_border,
                      color: note.isFavorite ? Colors.yellow : null,
                    ),
                    onTap: () {
                      if (isMultiSelectMode) {
                        toggleSelectNote(note.id);
                      } else {
                        addOrEditNote(note: note);
                      }
                    },
                    onLongPress: () => toggleSelectNote(note.id),
                    leading: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: note.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredNotes.length,
            ),
          ),
        ],
      ),
    );
  }
}
