import 'package:flutter/material.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';
import 'package:image_picker_web_redux/image_picker_web_redux.dart';

class PeopleDialog extends StatefulWidget {
  final People people;
  final KeywordService ks;
  final String name;

  PeopleDialog({this.people, this.name, this.ks});

  @override
  _PeopleDialogState createState() => _PeopleDialogState();
}

class _PeopleDialogState extends State<PeopleDialog> {
  TextEditingController _dateOfBirthController;
  People people;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    people =
        widget.people == null ? People(firstName: widget.name) : widget.people;
    _dateOfBirthController = TextEditingController(
        text: people.dateOfBirth?.toString()?.split(" ")?.first ?? "");
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
            child: Text(
              "Personen",
              style: TextStyle(fontSize: 36),
            ),
          ),
          Container(
            height: 10,
            width: 0,
          ),
          Text("Vorname"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: people.firstName),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                people.firstName = val;
              },
            ),
          ),
          Container(
            height: 10,
            width: 0,
          ),
          Text("Nachname"),
          Container(
            width: 400,
            child: TextField(
              controller: TextEditingController(text: people.lastName),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
              onChanged: (val) {
                people.lastName = val;
              },
            ),
          ),
          Container(
            height: 10,
            width: 0,
          ),
          Text("Anmerkungen"),
          Container(
            width: 400,
            child: TextField(
              readOnly: true,
              onTap: _showDatePicker,
              controller: _dateOfBirthController,
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.teal)),
              ),
            ),
          ),
          Container(
            height: 10,
            width: 0,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedButtonWidget(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                text: "Schließen",
                color: Colors.red,
              ),
              Container(
                width: 10,
              ),
              RoundedButtonWidget(
                onPressed: () async {
                  setState(() {
                    _isActive = false;
                  });
                  if (people != null) {
                    people = People.copy(people);
                    await widget.ks.editPeople(EditingTypEnum.UPDATE, people);
                  } else {
                    await widget.ks.editPeople(EditingTypEnum.CREATE, people);
                  }
                  Navigator.pop(context, people);
                },
                text: "Speichern",
                color: Colors.green,
                isActive: _isActive,
              )
            ],
          )
        ],
      ),
    );
  }

  void _showDatePicker() async {
    DateTime val = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1000),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    people.dateOfBirth = val;
    _dateOfBirthController.text = val?.toString()?.split(" ")?.first ?? "";
  }
}
