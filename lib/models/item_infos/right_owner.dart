class RightOwner {
  String key;
  String name;
  String contactInformation;

  RightOwner.fromJson(json, key) {
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