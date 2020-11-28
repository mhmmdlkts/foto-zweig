import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class LocationDialog extends StatefulWidget {
  final Location location;
  final KeywordService ks;
  final String name;

  LocationDialog({this.location, this.name, this.ks});

  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {

  Location location;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    location = widget.location==null?Location(name: widget.name):widget.location;
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
            child: Text("Location", style: TextStyle(fontSize: 36),),
          ),
          Container(height: 10, width: 0,),
          Text("Name"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: location.name),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                location.name = val;
              },
            ),
          ),
          Container(height: 10, width: 0,),
          Text("Code"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: location.country),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                location.country = val;
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
                if (location != null) {
                  location = Location.copy(location);
                  await widget.ks.editLocation(EditingTypEnum.UPDATE, location);
                } else {
                  await widget.ks.editLocation(EditingTypEnum.CREATE, location);
                }
                Navigator.pop(context, location);
              }, text: "Save", color: Colors.green,
                isActive: _isActive,)
            ],
          )
        ],
      ),
    );
  }
}