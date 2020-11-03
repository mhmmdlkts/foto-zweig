import 'package:flutter/material.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/screens/details_screen.dart';

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
            _getImg(context)
          ]),
          TableRow(children: [
            _getImgTitle()
          ]),
        ],
      ),
    );
  }

  Widget _getImg(BuildContext c) => GestureDetector(
    onTap: (){
      Navigator.push(c, MaterialPageRoute(builder: (context) => DetailsScreen(smallFotoItem)));
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