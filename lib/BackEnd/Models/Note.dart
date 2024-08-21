class Note {
  final String title, description, dateTime;
  final int? id;

  Note(
      {required this.title,
      required this.description,
      required this.dateTime,
      this.id});

  // factory Note.FromJsonToNote(Map<String, dynamic> json) => Note(
  //     title: json["title"],
  //     description: json["description"],
  //     dateTime: json["dateTime"],
  //     folderId: json["folderId"],

  // Map<String, dynamic> FromNoteToJson() => {
  //       "title": title,
  //       "description": description,
  //       "dateTime": dateTime,
  //       "folderId": folderId,
  //     };
}
