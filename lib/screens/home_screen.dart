import 'package:flutter/material.dart';
import 'package:notetodo_app/screens/recycle_bin_screen.dart' hide NoteService;
import 'package:notetodo_app/services/note_service.dart';
import 'notes_screen.dart'; // only import this

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text("Home Page Content")),
    NotesScreen(noteService: NoteService(), folderId: null,),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
        ],
      ),
    );
  }
}
