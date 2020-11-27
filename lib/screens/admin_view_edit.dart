import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/item_subtype.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';

class AdminViewEdit extends StatefulWidget {
  final KeywordService ks;
  final BuildContext context;
  final SmallFotoItem smallFotoItem;
  final VoidCallback onCancel;

  AdminViewEdit(this.context, this.onCancel, this.smallFotoItem, this.ks);

  @override
  _AdminViewEditState createState() => _AdminViewEditState();
}

class _AdminViewEditState extends State<AdminViewEdit> {
  final UploadService _uploadService = UploadService();
  final List<Location> _locationList = List();
  final List<RightOwner> _rightOwnerList = List();
  final List<Institution> _institutionList = List();
  final List<ItemSubtype> _itemSubTypeList = List();
  final List<People> _peopleList = List();
  final List<Tag> _tagList = List();

  final GlobalKey<AutoCompleteTextFieldState<Location>> _locationKey = new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<Tag>> _tagsKey = new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<People>> _creatorKey = new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<People>> _photographedPeopleKey = new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<RightOwner>> _rightOwnerKey = new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<ItemSubtype>> _itemSubtypeKey = new GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<Institution>> _institutionKey = new GlobalKey();

  TextEditingController _locationController;
  TextEditingController _creatorController;
  TextEditingController _startDateController;
  TextEditingController _endDateController;
  TextEditingController _rightOwnerController;
  TextEditingController _itemSubtypeController;
  TextEditingController _institutionController;
  TextEditingController _annotationController;

  bool isSaving = false;
  @override
  void initState() {
    super.initState();
    widget.ks.locationsJson?.forEach((key, value) => _locationList.add(Location.fromJson(value, key)));
    widget.ks.rightOwnerJson?.forEach((key, value) => _rightOwnerList.add(RightOwner.fromJson(value, key)));
    widget.ks.institutionJson?.forEach((key, value) => _institutionList.add(Institution.fromJson(value, key)));
    widget.ks.itemSubtypeJson?.forEach((key, value) => _itemSubTypeList.add(ItemSubtype.fromJson(value, key)));
    widget.ks.peopleJson?.forEach((key, value) => _peopleList.add(People.fromJson(value, key)));
    widget.ks.tagJson?.forEach((key, value) => _tagList.add(Tag.fromJson(value, key)));

    _annotationController = TextEditingController(text: widget.smallFotoItem?.annotation??"");
    _locationController = TextEditingController(text: widget.smallFotoItem?.location?.name??"");
    _institutionController = TextEditingController(text: widget.smallFotoItem?.institution?.name??"");
    _creatorController = TextEditingController(text: (widget.smallFotoItem?.creator?.firstName??"") + ((widget.smallFotoItem?.creator?.firstName)!=null?" ":"") + (widget.smallFotoItem?.creator?.lastName??""));
    _itemSubtypeController = TextEditingController(text: (widget.smallFotoItem?.itemSubType?.name??""));
    _rightOwnerController = TextEditingController(text: widget.smallFotoItem?.rightOwner?.name??"");
    _startDateController = TextEditingController(text: widget.smallFotoItem?.date?.startDate?.toString()?.split(" ")?.first??"");
    _endDateController = TextEditingController(text: widget.smallFotoItem?.date?.endDate?.toString()?.split(" ")?.first??"");

  GlobalKey<AutoCompleteTextFieldState<Location>> _locationKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(height: 10,),
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
            isActive: !isSaving,
            onPressed: () async {
              setState(() {
                isSaving = true;
              });
              await _uploadService.editImage(widget.smallFotoItem);
              Navigator.pop(context, true);
            },
          )
        ],
      ),
      SelectableText("Kurzbezeichnung:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        controller: TextEditingController(text: widget.smallFotoItem?.shortDescription??""),
        onChanged: (val) {
          widget.smallFotoItem.shortDescription = val;
        },
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
        controller: TextEditingController(text: widget.smallFotoItem?.description??""),
        onChanged: (val) {
          widget.smallFotoItem.description = val;
        },
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
                onPressed: () {
                  setState(() {
                    widget.smallFotoItem.isPublic = true;
                  });
                },
                text: "öffentlich sichtbar",
                color: widget.smallFotoItem.isPublic?Colors.white:Colors.grey,
                secondColor: widget.smallFotoItem.isPublic?Colors.blue:Colors.white,
              ),
            ),
            Expanded(
              child: RoundedButtonWidget(
                onPressed: () {
                  setState(() {
                    widget.smallFotoItem.isPublic = false;
                  });
                },
                text: "privat sichtbar",
                color: !widget.smallFotoItem.isPublic?Colors.white:Colors.grey,
                secondColor: !widget.smallFotoItem.isPublic?Colors.blue:Colors.white,
              ),
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
                        controller: _startDateController,
                        onTap: () => _showDatePicker(true),
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
                        controller: _endDateController,
                        onTap: () => _showDatePicker(false),
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
          widget.smallFotoItem.location = item;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _locationList,
        itemBuilder: (context, location) => new Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(location.name),
              trailing: Text("Country: ${location?.country?.toUpperCase()}")
          ),
        ),
        key: _locationKey,
        itemSorter: (a, b) => (a?.name ?? "").compareTo(b?.name ?? ""),
        itemFilter: (suggestion, input) =>
            suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
      ),
      Container(
        padding: EdgeInsets.only(top: 10),
        child: Wrap(
          children: widget.smallFotoItem.tags.map((e) => _createTagWidget(e)).toList(),
        ),
      ),
      SelectableText("Stichworte:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ButtonColors.appBarColor,
          fontSize: 17
        )
      ),
      AutoCompleteTextField<Tag>(
        key: _tagsKey,
        itemSubmitted: (item) {
          setState(() {
            widget.smallFotoItem.tags.add(item);
            _tagsKey.currentState.updateSuggestions(_getTagSuggestions());
          });
        },
        clearOnSubmit: true,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _getTagSuggestions(),
        itemBuilder: (context, tag) => Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(tag.name),
          ),
        ),
        itemSorter: (a, b) => (a?.name??"").compareTo(b?.name??""),
        itemFilter: (suggestion, input) => suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
      ),
      Container(
        padding: EdgeInsets.only(top: 10),
        child: Wrap(
          children: widget.smallFotoItem.photographedPeople.map((e) => _createPeopleWidget(e)).toList(),
        ),
      ),
      SelectableText("Abgebildete Personen:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<People>(
        key: _photographedPeopleKey,
        itemSubmitted: (item) {
          setState(() {
            widget.smallFotoItem.photographedPeople.add(item);
            _photographedPeopleKey.currentState.updateSuggestions(_getPhotographedPeopleSuggestions());
          });
        },
        clearOnSubmit: true,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _getPhotographedPeopleSuggestions(),
        itemBuilder: (context, people) => Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(people.firstName + " " + people.lastName),
          ),
        ),
        itemSorter: (a, b) => (a?.firstName??"").compareTo(b?.firstName??""),
        itemFilter: (suggestion, input) => (suggestion.firstName + suggestion.lastName).toLowerCase().contains(input.toLowerCase()),
      ),
      SelectableText("Rechteinhaber:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<RightOwner>(
        controller: _rightOwnerController,
        itemSubmitted: (item) {
          _rightOwnerController.text = item.name;
          widget.smallFotoItem.rightOwner = item;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _rightOwnerList,
        itemBuilder: (context, rightOwner) => new Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(rightOwner.name),
              trailing: Text(rightOwner.contactInformation)
          ),
        ),
        key: _rightOwnerKey,
        itemSorter: (a, b) => (a?.name??"").compareTo(b?.name??""),
        itemFilter: (suggestion, input) => suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
      ),
      SelectableText("Institution:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<Institution>(
        controller: _institutionController,
        itemSubmitted: (item) {
          _institutionController.text = item.name;
          widget.smallFotoItem.institution = item;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _institutionList,
        itemBuilder: (context, rightOwner) => new Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(rightOwner.name),
              trailing: Text(rightOwner.contactInformation)
          ),
        ),
        key: _institutionKey,
        itemSorter: (a, b) => (a?.name??"").compareTo(b?.name??""),
        itemFilter: (suggestion, input) => suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
      ),
      SelectableText("Foto - Typ:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<ItemSubtype>(
        controller: _itemSubtypeController,
        itemSubmitted: (item) {
          _itemSubtypeController.text = item.name;
          widget.smallFotoItem.itemSubType = item;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _itemSubTypeList,
        itemBuilder: (context, subtype) => new Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(subtype.name),
          ),
        ),
        key: _itemSubtypeKey,
        itemSorter: (a, b) => (a?.name??"").compareTo(b?.name??""),
        itemFilter: (suggestion, input) => suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
      ),
      SelectableText("Fotograf:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<People>(
        controller: _creatorController,
        itemSubmitted: (item) {
          _creatorController.text = (item.firstName??"") + " " + (item.lastName??"");
          widget.smallFotoItem.creator = item;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
        suggestions: _peopleList,
        itemBuilder: (context, creator) => new Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
              title: Text(creator.firstName + " " + creator.lastName),
          ),
        ),
        key: _creatorKey,
        itemSorter: (a, b) => (a?.firstName??"").compareTo(b?.firstName??""),
        itemFilter: (suggestion, input) => (suggestion.firstName??"" + suggestion.lastName??"").toLowerCase().contains(input.toLowerCase()),
      ),
      SelectableText("Vermerk:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        onChanged: (val) {
          widget.smallFotoItem.annotation = val;
        },
        controller: _annotationController,
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Enter a search term'),
      ),
      Container(height: 10,)
    ]);
  }

  void _showDatePicker(bool isStart) async {
    DateTime val = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year-1000),
      lastDate: DateTime(DateTime.now().year+1),
    );
    if (isStart) {
      widget.smallFotoItem.date.startDate = val;
      _startDateController.text = widget.smallFotoItem?.date?.startDate?.toString()?.split(" ")?.first??"";
    } else {
      widget.smallFotoItem.date.endDate = val;
      _endDateController.text = widget.smallFotoItem?.date?.startDate?.toString()?.split(" ")?.first??"";
    }
  }

  Widget _createTagWidget(Tag e) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: Colors.blue,
    ),
    margin: EdgeInsets.only(right: 10,bottom: 10),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(e.name, style: TextStyle(color: Colors.white, fontSize: 18),),
        Container(width: 8,),
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: Icon(Icons.close, color: Colors.white,),
            onTap: () {
              setState(() {
                widget.smallFotoItem.tags.remove(e);
                _tagsKey.currentState.updateSuggestions(_getTagSuggestions());
              });
            },
          ),
        )
      ],
    ),
  );

  Widget _createPeopleWidget(People e) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: Colors.blue,
    ),
    margin: EdgeInsets.only(right: 10,bottom: 10),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(e.firstName, style: TextStyle(color: Colors.white, fontSize: 18),),
        Container(width: 5,),
        Text(e.lastName, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        Container(width: 8,),
        Material(
          color: Colors.transparent,
          child: InkWell(
            child: Icon(Icons.close, color: Colors.white,),
            onTap: () {
              setState(() {
                widget.smallFotoItem.photographedPeople.remove(e);
                _photographedPeopleKey.currentState.updateSuggestions(_getPhotographedPeopleSuggestions());
              });
            },
          ),
        )
      ],
    ),
  );

  List<Tag> _getTagSuggestions() => _tagList.where((element) {
    for(int i = 0; i < widget.smallFotoItem.tags.length; i++)
      if (widget.smallFotoItem.tags[i].key == element.key)
        return false;
    return true;
  }).toList();

  List<People> _getPhotographedPeopleSuggestions() => _peopleList.where((element) {
    for(int i = 0; i < widget.smallFotoItem.photographedPeople.length; i++)
      if (widget.smallFotoItem.photographedPeople[i].key == element.key)
        return false;
    return true;
  }).toList();
}
