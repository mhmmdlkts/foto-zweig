import 'package:foto_zweig/enums/item_type_enum.dart';

class ItemSubtype {
  String key;
  String name;

  ItemSubtype({this.key, this.name});

  ItemSubtype.copy(ItemSubtype itemSubtype) {
    key = itemSubtype.key;
    name = itemSubtype.name;
  }

  ItemSubtype.fromJson(json, key) {
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