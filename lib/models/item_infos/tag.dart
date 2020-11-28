class Tag {
  String key;
  String name;

  Tag({this.key, this.name});

  Tag.copy(Tag tag) {
    key = tag.key;
    name = tag.name;
  }

  Tag.fromJson(json, key) {
    if (json == null)
      return;
    this.key = key;
    this.name = json["name"];
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name
  };
}