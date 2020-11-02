import 'package:foto_zweig/enums/item_type_enum.dart';

class ItemType {
  int id;
  String name;

  ItemType.fromJson(json) {
    if (json == null)
      return;
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
}