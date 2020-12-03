import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';

class TagDialog extends StatefulWidget {
  final Tag tag;
  final KeywordService ks;
  final String name;

  TagDialog({this.tag, this.name, this.ks});

  @override
  _TagDialogState createState() => _TagDialogState();
}

class _TagDialogState extends State<TagDialog> {

  Tag tag;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    tag = widget.tag==null?_submitTag():widget.tag;
  }

  Tag _submitTag() {
    tag = Tag(name: widget.name);
    _submit();
    return tag;
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
            child: Text("Tag", style: TextStyle(fontSize: 36),),
          ),
          Container(height: 10, width: 0,),
          Text("Name"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: tag.name),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                tag.name = val;
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
    if (tag != null) {
      tag = Tag.copy(tag);
      await widget.ks.editTag(EditingTypEnum.UPDATE, tag);
    } else {
      await widget.ks.editTag(EditingTypEnum.CREATE, tag);
    }
    Navigator.pop(context, tag);
  }
}