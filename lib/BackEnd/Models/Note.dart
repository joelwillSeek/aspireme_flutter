class Note {
  final String title, description, dateTime;
  int? id;
  final int parentId;

  Note(
      {required this.title,
      required this.description,
      required this.dateTime,
      this.id,
      required this.parentId});

  factory Note.FromJsonToNote(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dateTime: json["dateTime"],
        parentId: json["parentId"],
      );

  Map<String, dynamic> FromNoteToJson() => {
        "id": id,
        "title": title,
        "description": description,
        "dateTime": dateTime,
        "parentId": parentId,
      };
}
