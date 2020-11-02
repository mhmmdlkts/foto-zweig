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
}