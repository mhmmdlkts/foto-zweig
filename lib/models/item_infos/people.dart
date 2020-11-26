class People {
  String key;
  DateTime dateOfBirth;
  String firstName;
  String lastName;

  People.fromJson(json, key) {
    if (json == null)
      return;
    key = key;
    if (json["dateOfBirth"] != null)
      dateOfBirth = DateTime.parse(json["dateOfBirth"]);
    firstName = json["firstName"];
    lastName = json["lastName"];
  }

  getName() => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
    "key": key,
    "dateOfBirth": dateOfBirth?.toString()?.split(" ")[0]??null,
    "firstName": firstName,
    "lastName": lastName,
  };
}