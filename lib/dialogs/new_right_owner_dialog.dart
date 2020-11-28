import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class RightOwnerDialog extends StatefulWidget {
  final RightOwner rightOwner;
  final KeywordService ks;
  final String name;

  RightOwnerDialog({this.rightOwner, this.name, this.ks});

  @override
  _RightOwnerDialogState createState() => _RightOwnerDialogState();
}

class _RightOwnerDialogState extends State<RightOwnerDialog> {

  RightOwner rightOwner;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    rightOwner = widget.rightOwner==null?RightOwner(name: widget.name):widget.rightOwner;
  }

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
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 400,
            child: Text("Right Owner", style: TextStyle(fontSize: 36),),
          ),
          Container(height: 10, width: 0,),
          Text("Name"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: rightOwner.name),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                rightOwner.name = val;
              },
            ),
          ),
          Container(height: 10, width: 0,),
          Text("Contact Information"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: rightOwner.contactInformation),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                rightOwner.contactInformation = val;
              },
            ),
          ),
          Container(height: 10, width: 0,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedButtonWidget(onPressed: () {
                Navigator.pop(context, null);
              }, text: "Schließen", color: Colors.red,),
              Container(width: 10,),
              RoundedButtonWidget(onPressed: () async {
                setState(() { _isActive = false; });
                if (rightOwner != null) {
                  rightOwner = RightOwner.copy(rightOwner);
                  await widget.ks.editRightOwner(EditingTypEnum.UPDATE, rightOwner);
                } else {
                  await widget.ks.editRightOwner(EditingTypEnum.CREATE, rightOwner);
                }
                Navigator.pop(context, rightOwner);
              }, text: "Save", color: Colors.green,
                isActive: _isActive,)
            ],
          )
        ],
      ),
    );
  }
}