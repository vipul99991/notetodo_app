import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "notes.db");

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        isDone INTEGER,
        category TEXT DEFAULT 'General',
        color TEXT DEFAULT 'yellow'
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          "ALTER TABLE notes ADD COLUMN category TEXT DEFAULT 'General'");
      await db
          .execute("ALTER TABLE notes ADD COLUMN color TEXT DEFAULT 'yellow'");
    }
  }

  Future<int> insertNote(Note note) async {
    final client = await db;
    return await client.insert("notes", note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final client = await db;
    final result = await client.query("notes", orderBy: "id DESC");
    return result.map((e) => Note.fromMap(e)).toList();
  }

  Future<int> updateNote(Note note) async {
    final client = await db;
    return await client
        .update("notes", note.toMap(), where: "id = ?", whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    final client = await db;
    return await client.delete("notes", where: "id = ?", whereArgs: [id]);
  }

  Future<int> markAsDone(int id, int isDone) async {
    final client = await db;
    return await client.update(
      "notes",
      {"isDone": isDone},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
