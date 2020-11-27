class Tag {
  String key;
  String name;

  Tag.fromJson(name, key) {
    this.key = key;
    this.name = name;
  }

  Map<String, dynamic> toJson() => {
    "name": name
  };
}