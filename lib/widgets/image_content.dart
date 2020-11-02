import 'package:flutter/material.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/widgets/small_foto_item_widget.dart';

class ImageContentWidget extends StatelessWidget {
  final List<SmallFotoItem> smallFotoItems;
  ImageContentWidget(this.smallFotoItems, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: smallFotoItems.map((item) => SmallFotoItemWidget(item)).toList(),
          );
  }
}