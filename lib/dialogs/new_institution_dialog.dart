import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class InstitutionDialog extends StatefulWidget {
  final Institution institution;
  final KeywordService ks;
  final String name;

  InstitutionDialog({this.institution, this.name, this.ks});

  @override
  _InstitutionDialogState createState() => _InstitutionDialogState();
}

class _InstitutionDialogState extends State<InstitutionDialog> {

  Institution institution;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    institution = widget.institution==null?Institution(name: widget.name):widget.institution;
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
            child: Text("Institution", style: TextStyle(fontSize: 36),),
          ),
          Container(height: 10, width: 0,),
          Text("Name"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: institution.name),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                institution.name = val;
              },
            ),
          ),
          Container(height: 10, width: 0,),
          Text("Contact Information"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: institution.contactInformation),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                institution.contactInformation = val;
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
                if (institution != null) {
                  institution = Institution.copy(institution);
                  await widget.ks.editInstitution(EditingTypEnum.UPDATE, institution);
                } else {
                  await widget.ks.editInstitution(EditingTypEnum.CREATE, institution);
                }
                Navigator.pop(context, institution);
              }, text: "Save", color: Colors.green,
              isActive: _isActive,)
            ],
          )
        ],
      ),
    );
  }
}