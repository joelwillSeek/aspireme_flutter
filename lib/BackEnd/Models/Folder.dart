class Folder {
  int? id;
  String name;

  Folder({required this.name, this.id});

  factory Folder.FromJsonToFolder(Map<String, dynamic> json) =>
      Folder(name: json["name"], id: json["id"]);

  Map<String, dynamic> FromFolderToJson() => {'id': this.id, "name": this.name};
}
