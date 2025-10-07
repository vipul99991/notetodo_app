import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class RecycleBinScreen extends StatefulWidget {
  final NoteService noteService;
  const RecycleBinScreen({super.key, required this.noteService});

  @override
  State<RecycleBinScreen> createState() => _RecycleBinScreenState();
}

class NoteService {
  get deletedNotes => null;

  get service => null;

  get folders => null;
  
  void restore(id) {}
  
  void permanentlyDelete(id) {}

  void addFolder(String text) {}
}

class _RecycleBinScreenState extends State<RecycleBinScreen> {
  @override
  Widget build(BuildContext context) {
    final deletedNotes = widget.noteService.deletedNotes;

    return Scaffold(
      appBar: AppBar(title: const Text('Recycle Bin')),
      body: deletedNotes.isEmpty
          ? const Center(child: Text('Trash is empty'))
          : ListView.builder(
              itemCount: deletedNotes.length,
              itemBuilder: (context, index) {
                final note = deletedNotes[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.restore),
                          onPressed: () {
                            setState(() => widget.noteService.restore(note.id));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.red),
                          onPressed: () {
                            setState(() =>
                                widget.noteService.permanentlyDelete(note.id));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
