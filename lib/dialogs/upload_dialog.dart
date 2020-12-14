import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/foto_user.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class UploadDialog extends StatefulWidget {
  final FotoUser user;

  UploadDialog(this.user);

  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  ItemTypeEnum _itemType = ItemTypeEnum.FOTO;
  String _shortDescription = "";
  MediaInfo _mediaInfo;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize:  MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hochladen", style: TextStyle(fontSize: 36),),
          Container(
            width: 400,
            child: Divider(),
          ),
          Text("Typ:"),
          _imageTypDropDown(),
          Text("Kurzbezeichnung:"),
          Container(
            width: 400,
            child: TextField(
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
                ),
              onChanged: (val) {
                _shortDescription = val;
              },
            ),
          ),
          Container(height: 10, width: 0,),
          Text("Datei:"),
          Row(
            mainAxisSize:  MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                color: Colors.blueGrey,
                text: "Datei auswählen",
                onPressed: () {
                  ImagePickerWeb.getImageInfo.then((value) {
                    setState((){
                      _mediaInfo = value;
                    });
                  });
                },
              ),
              Container(width: 10,),
              Text (_mediaInfo==null?"Keine Datei ausgewählt":_mediaInfo.fileName)
            ],
          ),
          Container(height: 20, width: 0,),
          Row(
            mainAxisSize:  MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                isActive: !_isUploading,
                color: Colors.blue,
                text: "Hochladen",
                onPressed: () async {
                  setState(() {
                    _isUploading = true;
                  });
                  SmallFotoItem smallFotoItem = SmallFotoItem(shortDescription: _shortDescription, itemType: _itemType);
                  await UploadService().uploadImage(smallFotoItem, _mediaInfo, widget.user);
                  Navigator.pop(context, true);
                },
              ),
              Container(width: 10,),
              RoundedButtonWidget(
                text: "Schließen",
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          )
        ],
      ),
      padding: EdgeInsets.all(10),
    );
  }

  Widget _imageTypDropDown() {
    return DropdownButton<ItemTypeEnum>(
      value: _itemType,
      underline: Container(),
      onChanged: (ItemTypeEnum newValue) {
        setState(() {
          _itemType = newValue;
        });
      }, items: ItemTypeEnum.values
          .map<DropdownMenuItem<ItemTypeEnum>>((ItemTypeEnum value) {
        return DropdownMenuItem<ItemTypeEnum>(
          value: value,
          child: Text(value.toString().split(".")[1]),
        );
      }).toList(),
    );
  }
}