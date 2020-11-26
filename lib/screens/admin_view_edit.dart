import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/item_type.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/screens/details_screen.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';

class AdminViewEdit extends StatefulWidget {
  final SmallFotoItem smallFotoItem;
  final VoidCallback onCancel;
  final Map locationsJson;
  final Map rightOwnerJson;
  final Map institutionJson;
  final Map itemSubTypeJson;
  final Map peopleJson;

  AdminViewEdit(this.onCancel, this.smallFotoItem, {this.locationsJson, this.rightOwnerJson, this.institutionJson, this.itemSubTypeJson, this.peopleJson, Key key}) : super(key: key);

  @override
  _AdminViewEditState createState() => _AdminViewEditState();
}

class _AdminViewEditState extends State<AdminViewEdit> {
  List<Location> _locationList = List();
  List<RightOwner> _rightOwnerList = List();
  List<Institution> _institutionList = List();
  List<ItemType> _itemSubTypeList = List();
  List<People> _peopleList = List();

  TextEditingController _locationController;
  GlobalKey<AutoCompleteTextFieldState<Location>> _locationKey = new GlobalKey();
  @override
  void initState() {
    super.initState();
    widget.locationsJson?.forEach((key, value) => _locationList.add(Location.fromJson(value, key)));
    widget.rightOwnerJson?.forEach((key, value) => _rightOwnerList.add(RightOwner.fromJson(value, key)));
    widget.institutionJson?.forEach((key, value) => _institutionList.add(Institution.fromJson(value, key)));
    widget.itemSubTypeJson?.forEach((key, value) => _itemSubTypeList.add(ItemType.fromJson(value, key)));
    widget.peopleJson?.forEach((key, value) => _peopleList.add(People.fromJson(value, key)));

    _locationController = TextEditingController(text: widget.smallFotoItem.location.name);
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
      AutoCompleteTextField<Location>(
        controller: _locationController,
        itemSubmitted: (item) {
          _locationController.text = item.name;
          return item.name;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _locationList,
        itemBuilder: (context, location) => new Padding(
          padding: EdgeInsets.all(8.0),
          child: new ListTile(
              title: new Text(location.name),
              trailing: new Text("Country: ${location?.country?.toUpperCase()}")
          ),
        ),
        key: _locationKey,
        itemSorter: (a, b) => (a?.name??"").compareTo(b?.name??""),
        itemFilter: (suggestion, input) => suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
      ),
      SelectableText("Stichworte:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ButtonColors.appBarColor,
          fontSize: 17
        )
      ),
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
