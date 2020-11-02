class Institution {
  int id;
  String name;
  String contactInformation;

  Institution.fromJson(json) {
    if (json == null)
      return;
    id = json["id"];
    name = json["name"];
    contactInformation = json["contactInformation"];
  }
}