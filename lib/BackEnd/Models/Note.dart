class Note {
  String title, description, dateTime;
  int? id;
  final int parentId;
  //0 for false and 1 for true
  int _wrongAnswer;

  Note(
      {required this.title,
      required this.description,
      required this.dateTime,
      this.id,
      required this.parentId,
      int? wrongAnswerInner})
      : _wrongAnswer = wrongAnswerInner ?? 0;

  factory Note.FromJsonToNote(Map<String, dynamic> json) => Note(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dateTime: json["dateTime"],
        parentId: json["parentId"],
        wrongAnswerInner: json["wrongAnswer"],
      );

  Map<String, dynamic> FromNoteToJson({bool withId = true}) {
    if (withId) {
      return {
        "id": id,
        "title": title,
        "description": description,
        "dateTime": dateTime,
        "parentId": parentId,
        "wrongAnswer": _wrongAnswer
      };
    }

    return {
      "title": title,
      "description": description,
      "dateTime": dateTime,
      "parentId": parentId,
      "wrongAnswer": _wrongAnswer
    };
  }

  set isWrongAnswer(bool value) => value ? _wrongAnswer = 1 : _wrongAnswer = 0;

  bool get isWrongAnswer => _wrongAnswer == 0 ? false : true;
}
