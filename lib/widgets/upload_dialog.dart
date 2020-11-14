import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';

class UploadDialog extends StatefulWidget {
  @override
  _UploadDialogState createState() => _UploadDialogState();
}

class _UploadDialogState extends State<UploadDialog> {
  ItemTypeEnum _itemType = ItemTypeEnum.FOTO;

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
            ),
          ),
          Container(height: 10, width: 0,),
          Text("Datei:"),
          Row(
            mainAxisSize:  MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                color: Colors.blueGrey,
                text: "Choose file",
                onPressed: () {

                },
              ),
              Container(width: 10,),
              Text ("No file chosen")
            ],
          ),
          Container(height: 20, width: 0,),
          Row(
            mainAxisSize:  MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                color: Colors.blue,
                text: "Hochlade",
                onPressed: () {

                },
              ),
              Container(width: 10,),
              RoundedButtonWidget(
                text: "Schließen",
                onPressed: () {
                  Navigator.pop(context);
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