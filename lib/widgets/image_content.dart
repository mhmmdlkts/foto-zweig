import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/auth_mode_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/widgets/small_foto_item_widget.dart';

class ImageContentWidget extends StatelessWidget {
  final List<SmallFotoItem> smallFotoItems;
  final ItemTypeEnum itemTypeEnum;
  final AuthModeEnum authModeEnum;
  final Map locationsJson;
  final Map rightOwnerJson;
  final Map institutionJson;
  final Map itemSubTypeJson;
  final Map tagJson;
  final Map peopleJson;
  final VoidCallback onPop;

  ImageContentWidget(this.smallFotoItems, this.itemTypeEnum, this.authModeEnum, {Key key, this.onPop, this.locationsJson, this.rightOwnerJson, this.institutionJson, this.tagJson, this.itemSubTypeJson, this.peopleJson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: smallFotoItems.map((item) => item.itemType == itemTypeEnum?SmallFotoItemWidget(item, authModeEnum, onPop: onPop, locationsJson: locationsJson, rightOwnerJson: rightOwnerJson, tagJson: tagJson, itemSubTypeJson: itemSubTypeJson, peopleJson: peopleJson, institutionJson: institutionJson):null).toList().where((k) => k != null).toList(),
    );
  }
}