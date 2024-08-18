class Note {
  final String title, description, dateTime;
  final int? id;
  int? parentFolderID = 0;

  //0 means not in folder
  final int? folderId;

  Note(
      {required this.title,
      required this.description,
      this.parentFolderID,
      required this.dateTime,
      this.id,
      required this.folderId});

  factory Note.FromJsonToNote(Map<String, dynamic> json) => Note(
      title: json["title"],
      description: json["description"],
      dateTime: json["dateTime"],
      folderId: json["folderId"],
      parentFolderID: json["parentFolderID"]);

  Map<String, dynamic> FromNoteToJson() => {
        "title": title,
        "description": description,
        "dateTime": dateTime,
        "folderId": folderId,
        "parentFolderID": parentFolderID
      };
}
