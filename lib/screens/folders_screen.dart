import 'package:flutter/material.dart';
import 'package:notetodo_app/screens/recycle_bin_screen.dart' hide NoteService;
import '../services/note_service.dart';
import 'notes_screen.dart';

class FoldersScreen extends StatefulWidget {
  final NoteService noteService;
  const FoldersScreen({super.key, required this.noteService});

  @override
  State<FoldersScreen> createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {
  final TextEditingController _controller = TextEditingController();

  void _createFolder() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Folder name')),
        actions: [
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                setState(() {
                  widget.noteService.addFolder(_controller.text);
                });
                _controller.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final folders = widget.noteService.folders;

    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, i) {
          final folder = folders[i];
          return ListTile(
            title: Text(folder.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => NotesScreen(
                        noteService: widget.noteService, folderId: folder.id)),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createFolder,
        child: const Icon(Icons.create_new_folder),
      ),
    );
  }
}
