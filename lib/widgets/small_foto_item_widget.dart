import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/auth_mode_enum.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/screens/details_screen.dart';
import 'package:foto_zweig/services/mobile_checker_service.dart';

class SmallFotoItemWidget extends StatelessWidget {
  final SmallFotoItem smallFotoItem;
  final AuthModeEnum authModeEnum;
  final Map locationsJson;
  final Map rightOwnerJson;
  final Map institutionJson;
  final Map itemSubTypeJson;
  final Map peopleJson;
  SmallFotoItemWidget(this.smallFotoItem, this.authModeEnum,
      {
        this.locationsJson,
        this.rightOwnerJson,
        this.institutionJson,
        this.itemSubTypeJson,
        this.peopleJson,
        Key key
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            DetailsScreen(smallFotoItem, authModeEnum,
              locationsJson: locationsJson,
              rightOwnerJson: rightOwnerJson,
              institutionJson: institutionJson,
              itemSubTypeJson: itemSubTypeJson,
              peopleJson: peopleJson
            )));
      },
      child: Container(
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
      ),
    );
  }

  Widget _getImg(BuildContext c) => Container(
    child: Image.network(
      smallFotoItem.thumbnailPath,
      height: _getImgHeight(c), // 17em
      fit: BoxFit.fitHeight,
    ),
  );

  double _getImgHeight(BuildContext c) {
    if (!MbCheck.isMobile(c))
      return 272;
    return 120;
  }

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