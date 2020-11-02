import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/main_foto.dart';

class SmallFotoItemWidget extends StatelessWidget {
  final SmallFotoItem smallFotoItem;
  final ItemTypeEnum only;
  SmallFotoItemWidget(this.smallFotoItem, {Key key, this.only}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(smallFotoItem.itemType.getEnum().toString() + " == " + only.toString());
    return Visibility(
      visible: smallFotoItem.itemType.getEnum() == only,
      child: Container(
        margin: EdgeInsets.only(left: 16, bottom: 16),
        child: Table(
          defaultColumnWidth: IntrinsicColumnWidth(),
          children: [
            TableRow(children: [
              _getImg()
            ]),
            TableRow(children: [
              _getImgTitle()
            ]),
          ],
        ),
      )
    );
  }

  Widget _getImg() => GestureDetector(
    onTap: (){
      print(smallFotoItem.shortDescription);
    },
    child: Container(
      child: Image.network(
        smallFotoItem.thumbnailPath,
        height: 272, // 17em
      ),
    ),
  );

  Widget _getImgTitle() => Container(
    width: 0, // Maybe there is a better solution for the text overflowing
    child: Text(
      smallFotoItem.shortDescription,
      style: TextStyle(
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis
    ),
  );
}