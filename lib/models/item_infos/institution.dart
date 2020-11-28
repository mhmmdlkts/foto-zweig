class Institution {
  String key;
  String name;
  String contactInformation;

  Institution({this.key, this.name, this.contactInformation});

  Institution.copy(Institution institution) {
    key = institution.key;
    name = institution.name;
    contactInformation = institution.contactInformation;
  }

  Institution.fromJson(json, key) {
    if (json == null)
      return;
    this.key = key;
    name = json["name"];
    contactInformation = json["contactInformation"];
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "contactInformation": contactInformation
  };
}