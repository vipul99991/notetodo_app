import 'package:flutter/material.dart';
import 'screens/notes_screen.dart';
import 'services/note_service.dart'; // <-- import NoteService

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NotesScreen(
        noteService: NoteService(), // <-- make sure NoteService class exists
        folderId: null,
      ),
    );
  }
}
