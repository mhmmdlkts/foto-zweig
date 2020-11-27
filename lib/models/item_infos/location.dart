class Location {
  String key;
  String name;
  String country;

  Location();

  Location.copy(Location location) {
    key = location.key;
    name = location.name;
    country = location.country;
  }

  Location.fromJson(json, key) {
    if (json == null)
      return;
    this.key = key;
    name = json["name"];
    country = json["country"];
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name,
    "country": country
  };
}