import 'package:foto_zweig/enums/item_type_enum.dart';

class ItemSubtype {
  String key;
  String name;

  ItemSubtype.fromJson(name, key) {
    this.key = key;
    this.name = name;
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "name": name
  };
}