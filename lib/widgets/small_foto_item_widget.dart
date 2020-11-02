import 'package:flutter/material.dart';
import 'package:foto_zweig/models/main_foto.dart';

class SmallFotoItemWidget extends StatelessWidget {
  final SmallFotoItem smallFotoItem;
  SmallFotoItemWidget(this.smallFotoItem, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  Widget _getImg() => GestureDetector(
    onTap: (){
      print(smallFotoItem.title);
    },
    child: Container(
      child: Image.network(
        smallFotoItem.imgUrl,
        height: 272, // 17em
      ),
    ),
  );

  Widget _getImgTitle() => Container(
    width: 0, // Maybe there is a better solution for the text overflowing
    child: Text(
      smallFotoItem.title,
      style: TextStyle(
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis
    ),
  );
}