import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/screens/details_screen.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';

class AdminViewEdit extends StatefulWidget {
  final SmallFotoItem smallFotoItem;
  final VoidCallback onCancel;
  AdminViewEdit(this.onCancel, this.smallFotoItem, {Key key}) : super(key: key);

  @override
  _AdminViewEditState createState() => _AdminViewEditState();
}

class _AdminViewEditState extends State<AdminViewEdit> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RoundedButtonWidget(
            color: Colors.redAccent,
            text: "Abbrechen",
            onPressed: () {
              widget.onCancel.call();
            },
          ),
          Container(
            width: 10,
          ),
          RoundedButtonWidget(
            color: Colors.green,
            text: "Speichern",
            onPressed: () {},
          )
        ],
      ),
      SelectableText("Kurzbezeichnung:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
      SelectableText("Beschreibung:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: RoundedButtonWidget(
                onPressed: () {},
                text: "öffentlich sichtbar",
                color: Colors.white,
                secondColor: Colors.blue,
              ),
            ),
            Expanded(
              child: RoundedButtonWidget(
                  onPressed: () {}, text: "privat sichtbar"),
            )
          ],
        ),
      ),
      SelectableText("Zeit:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SelectableText("von"),
                    Flexible(
                      child: TextField(
                        readOnly: true,
                        onTap: _showDatePicker,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            hintText: 'Pick a date'),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SelectableText("bis"),
                    Flexible(
                      child: TextField(
                        readOnly: true,
                        onTap: _showDatePicker,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            hintText: 'Pick a date'),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
      SelectableText("Ort:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
      SelectableText("Stichworte:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Stichworte suchen und mit Eingabetaste hinzufügen...'),
      ),
      SelectableText("Abgebildete Personen:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Personen suchen und mit Eingabetaste hinzufügen...'),
      ),
      SelectableText("Rechteinhaber:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
      SelectableText("Institution:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
      SelectableText("Foto - Typ:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
      SelectableText("Fotograf:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Fotograf suchen...'),
      ),
      SelectableText("Vermerk:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
    ]);
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
  }
}
