class RightOwner {
  int id;
  String name;
  String contachInformation;

  RightOwner.fromJson(json) {
    if (json == null)
      return;
    id = json["id"];
    name = json["name"];
    contachInformation = json["contachInformation"];
  }
}