class Note {
  final String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  bool isPinned;
  bool isDeleted;
  String? folderId;
  List<String> tags;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.isPinned = false,
    this.isDeleted = false,
    this.folderId,
    this.tags = const [],
  });
}
