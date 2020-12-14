class People {
  String key;
  String annotation;
  String firstName;
  String lastName;

  People({this.key, this.annotation, this.firstName, this.lastName});

  People.copy(People people) {
    key = people.key;
    annotation = people.annotation;
    firstName = people.firstName;
    lastName = people.lastName;
  }

  People.fromJson(json, key) {
    if (json == null) return;
    this.key = key;
    annotation = json["annotation"];
    firstName = json["firstName"];
    lastName = json["lastName"];
  }

  getName() => '$firstName $lastName';

  Map<String, dynamic> toJson() => {
        "key": key,
        "annotation": annotation,
        "firstName": firstName,
        "lastName": lastName,
      };
}
