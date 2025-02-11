import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/auth_mode_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/foto_user.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/widgets/small_foto_item_widget.dart';

class ImageContentWidget extends StatelessWidget {
  final KeywordService keywordService;
  final List<SmallFotoItem> smallFotoItems;
  final ItemTypeEnum itemTypeEnum;
  final AuthModeEnum authModeEnum;
  final VoidCallback onPop;
  final FotoUser fotoUser;

  ImageContentWidget(this.fotoUser, this.smallFotoItems, this.itemTypeEnum, this.authModeEnum, this.keywordService, {Key key, this.onPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: smallFotoItems.map((item) => item.itemType == itemTypeEnum?SmallFotoItemWidget(fotoUser, item, authModeEnum, keywordService, onPop: onPop):null).toList().where((k) => k != null).toList(),
    );
  }
}