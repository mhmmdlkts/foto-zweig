import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/item_infos/item_subtype.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class SubtypeDialog extends StatefulWidget {
  final ItemSubtype itemSubtype;
  final KeywordService ks;
  final String name;

  SubtypeDialog({this.itemSubtype, this.name, this.ks});

  @override
  _SubtypeDialogState createState() => _SubtypeDialogState();
}

class _SubtypeDialogState extends State<SubtypeDialog> {

  ItemSubtype itemSubtype;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    itemSubtype = widget.itemSubtype==null?_submitSubtype():widget.itemSubtype;
  }

  ItemSubtype _submitSubtype() {
    itemSubtype = ItemSubtype(name: widget.name);
    _submit();
    return itemSubtype;
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
            child: Text("Item Subtype", style: TextStyle(fontSize: 36),),
          ),
          Container(height: 10, width: 0,),
          Text("Name"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: itemSubtype.name),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                itemSubtype.name = val;
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
              RoundedButtonWidget(onPressed: _submit, text: "Save", color: Colors.green,
                isActive: _isActive,)
            ],
          )
        ],
      ),
    );
  }

  void _submit() async {
    setState(() { _isActive = false; });
    if (itemSubtype != null) {
      itemSubtype = ItemSubtype.copy(itemSubtype);
      await widget.ks.editItemSubType(EditingTypEnum.UPDATE, itemSubtype);
    } else {
      await widget.ks.editItemSubType(EditingTypEnum.CREATE, itemSubtype);
    }
    Navigator.pop(context, itemSubtype);
  }
}