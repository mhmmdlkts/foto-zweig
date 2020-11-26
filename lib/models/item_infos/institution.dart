class Institution {
  String key;
  String name;
  String contactInformation;

  Institution.fromJson(json, key) {
    if (json == null)
      return;
    key = key;
    name = json["name"];
    contactInformation = json["contactInformation"];
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "contactInformation": contactInformation
  };
}