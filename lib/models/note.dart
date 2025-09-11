class Note {
  int? id;
  String title;
  String description;
  int isDone;
  String category;
  String color;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.isDone = 0,
    this.category = "General",
    this.color = "yellow",
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "title": title,
      "description": description,
      "isDone": isDone,
      "category": category,
      "color": color,
    };
    if (id != null) map["id"] = id;
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      isDone: map["isDone"],
      category: map["category"],
      color: map["color"],
    );
  }
}
