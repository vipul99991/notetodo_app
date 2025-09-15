import 'package:flutter/material.dart';
import 'screens/splash_screeen.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note Todo App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreeen(),
    );
  }
}
