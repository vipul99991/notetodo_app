import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/note.dart';

class NoteDetail extends StatefulWidget {
  final Note? note;
  NoteDetail({this.note});

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  final dbHelper = DatabaseHelper();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late String _selectedCategory;
  late String _selectedColor;

  final List<String> categories = ["General", "Work", "Personal", "Other"];
  final List<String> colors = ["yellow", "blue", "green", "red", "purple"];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _descController =
        TextEditingController(text: widget.note?.description ?? "");
    _selectedCategory = widget.note?.category ?? "General";
    _selectedColor = widget.note?.color ?? "yellow";
  }

  Color _mapColor(String colorName) {
    switch (colorName) {
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      case "red":
        return Colors.red;
      case "purple":
        return Colors.purple;
      case "yellow":
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  Future<void> _saveNote() async {
    Note newNote = Note(
      id: widget.note?.id,
      title: _titleController.text,
      description: _descController.text,
      isDone: widget.note?.isDone ?? 0,
      category: _selectedCategory,
      color: _selectedColor,
    );

    if (newNote.id == null) {
      await dbHelper.insertNote(newNote);
    } else {
      await dbHelper.updateNote(newNote);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Note Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                setState(() => _selectedCategory = val!);
              },
              decoration: const InputDecoration(labelText: "Category"),
            ),
            DropdownButtonFormField<String>(
              value: _selectedColor,
              items: colors
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: _mapColor(c), radius: 10),
                            const SizedBox(width: 8),
                            Text(c.toUpperCase()),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() => _selectedColor = val!);
              },
              decoration: const InputDecoration(labelText: "Note Color"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}
