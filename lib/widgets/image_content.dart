import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/widgets/small_foto_item_widget.dart';

class ImageContentWidget extends StatelessWidget {
  final List<SmallFotoItem> smallFotoItems;
  final ItemTypeEnum itemTypeEnum;
  ImageContentWidget(this.smallFotoItems, this.itemTypeEnum, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: smallFotoItems.map((item) => SmallFotoItemWidget(item, only: itemTypeEnum)).toList(),
    );
  }
}