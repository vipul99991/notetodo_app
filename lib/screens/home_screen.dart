import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note.dart';
import 'note_detail.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    var list = await dbHelper.getNotes();
    setState(() {
      _notes = list;
    });
  }

  Future<void> delete(int id) async {
    await dbHelper.deleteNote(id);
    fetchNotes();
  }

  Future<void> toggleDone(Note note) async {
    await dbHelper.markAsDone(note.id!, note.isDone == 1 ? 0 : 1);
    fetchNotes();
  }

  Color _mapColor(String colorName) {
    switch (colorName) {
      case "blue":
        return Colors.blue.shade100;
      case "green":
        return Colors.green.shade100;
      case "red":
        return Colors.red.shade100;
      case "purple":
        return Colors.purple.shade100;
      case "yellow":
        return Colors.yellow.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Note Todo App")),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return Card(
            color: _mapColor(note.color),
            child: ListTile(
              leading: Checkbox(
                value: note.isDone == 1,
                onChanged: (_) => toggleDone(note),
              ),
              title: Text(
                note.title,
                style: TextStyle(
                  decoration:
                      note.isDone == 1 ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text("${note.description}\n[${note.category}]"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => delete(note.id!),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NoteDetail(note: note)),
                );
                fetchNotes();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NoteDetail()),
          );
          fetchNotes();
        },
      ),
    );
  }
}
