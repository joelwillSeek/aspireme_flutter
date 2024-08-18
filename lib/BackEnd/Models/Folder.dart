class Folder {
  int? id;
  String? name;
  //0 means it has no parent folder
  int? parentFolderID = 0;

  Folder({required String name, int? id, int? parentFolderID});

  factory Folder.FromJsonToFolder(Map<String, dynamic> json) => Folder(
      name: json["name"],
      id: json["id"],
      parentFolderID: json["parentFolderID"]);

  Map<String, dynamic> FromFolderToJson() =>
      {'id': this.id, "name": this.name, "parentFolderID": this.parentFolderID};
}
