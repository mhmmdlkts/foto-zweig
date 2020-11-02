class People {
  int id;
  DateTime dateOfBirth;
  String firstName;
  String lastName;

  People.fromJson(json) {
    if (json == null)
      return;
    id = json["id"];
    if (json["dateOfBirth"] != null)
      dateOfBirth = DateTime.parse(json["dateOfBirth"]);
    firstName = json["firstName"];
    lastName = json["lastName"];
  }
}