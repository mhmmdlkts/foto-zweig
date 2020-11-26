class Location {
  String key;
  String name;
  String country;

  Location.fromJson(json, key) {
    if (json == null)
      return;
    key = key;
    name = json["name"];
    country = json["country"];
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "country": country
  };
}