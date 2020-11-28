class RightOwner {
  String key;
  String name;
  String contactInformation;

  RightOwner({this.key, this.name, this.contactInformation});

  RightOwner.copy(RightOwner rightOwner) {
    this.key = rightOwner.key;
    this.name = rightOwner.name;
    this.contactInformation = rightOwner.contactInformation;
  }

  RightOwner.fromJson(json, key) {
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