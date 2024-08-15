class Note {
  final String title, discription, dateTime;
  final int? id;

  const Note(
      {required this.title,
      required this.discription,
      required this.dateTime,
      this.id});

  factory Note.fromJsonToQuestionsWithNotes(Map<String, dynamic> json) => Note(
      title: json["title"],
      discription: json["discription"],
      dateTime: json["dateTime"]);

  Map<String, dynamic> FromQuestionWithNotesToJson() =>
      {"title": this.title, "discription": discription, "dateTime": dateTime};
}
