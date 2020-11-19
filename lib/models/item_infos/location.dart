class Location {
  int id;
  String name;
  String country;

  Location.fromJson(json) {
    if (json == null)
      return;
    id = json["id"];
    name = json["name"];
    country = json["country"];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country": country
  };
}