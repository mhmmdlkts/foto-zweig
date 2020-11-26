import 'package:foto_zweig/enums/item_type_enum.dart';

class ItemType {
  String key;
  int id;
  String name;

  ItemType(this.id, this.name);

  ItemType.fromJson(json, key) {
    if (json == null)
      return;
    key = key;
    id = json["id"];
    name = json["name"];
  }

  ItemTypeEnum getEnum() {
    switch (id) {
      case 1:
        return ItemTypeEnum.FOTO;
      case 2:
        return ItemTypeEnum.DOCUMENT;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "key": key,
    "name": name
  };
}