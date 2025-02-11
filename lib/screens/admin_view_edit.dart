import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/dialogs/new_institution_dialog.dart';
import 'package:foto_zweig/dialogs/new_location_dialog.dart';
import 'package:foto_zweig/dialogs/new_people_dialog.dart';
import 'package:foto_zweig/dialogs/new_right_owner_dialog.dart';
import 'package:foto_zweig/dialogs/new_subtype_dialog.dart';
import 'package:foto_zweig/dialogs/new_tag_dialog.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/models/foto_user.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/item_subtype.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:foto_zweig/services/logs_service.dart';
import 'package:foto_zweig/services/upload_service.dart';
import 'package:foto_zweig/widgets/logs_box.dart';
import 'package:foto_zweig/widgets/rounded_button.dart';

class AdminViewEdit extends StatefulWidget {
  final KeywordService ks;
  final BuildContext context;
  final SmallFotoItem smallFotoItem;
  final VoidCallback onCancel;
  final FotoUser user;

  AdminViewEdit(
      this.user, this.context, this.onCancel, this.smallFotoItem, this.ks);

  @override
  _AdminViewEditState createState() => _AdminViewEditState();
}

class _AdminViewEditState extends State<AdminViewEdit> {
  final UploadService _uploadService = UploadService();
  final LogsService _logsService = LogsService();
  final List<Location> _locationList = List();
  final List<RightOwner> _rightOwnerList = List();
  final List<Institution> _institutionList = List();
  final List<ItemSubtype> _itemSubTypeList = List();
  final List<People> _peopleList = List();
  final List<Tag> _tagList = List();

  final GlobalKey<AutoCompleteTextFieldState<Location>> _locationKey =
      GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<Tag>> _tagsKey = GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<People>> _creatorKey = GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<People>> _photographedPeopleKey =
      GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<RightOwner>> _rightOwnerKey =
      GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<ItemSubtype>> _itemSubtypeKey =
      GlobalKey();
  final GlobalKey<AutoCompleteTextFieldState<Institution>> _institutionKey =
      GlobalKey();

  final FocusNode _locationFocusNode = FocusNode();
  final FocusNode _tagsFocusNode = FocusNode();
  final FocusNode _creatorFocusNode = FocusNode();
  final FocusNode _rightOwnerFocusNode = FocusNode();
  final FocusNode _itemSubtypeFocusNode = FocusNode();
  final FocusNode _institutionFocusNode = FocusNode();
  final FocusNode _photographedPeopleFocusNode = FocusNode();

  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _photographedPeopleController =
      TextEditingController();
  TextEditingController _shortDescriptionController;
  TextEditingController _descriptionController;
  TextEditingController _locationController;
  TextEditingController _creatorController;
  TextEditingController _startDateController;
  TextEditingController _endDateController;
  TextEditingController _rightOwnerController;
  TextEditingController _itemSubtypeController;
  TextEditingController _institutionController;
  TextEditingController _annotationController;

  SmallFotoItem smallFotoItemNew;

  bool isSaving = false;
  @override
  void initState() {
    super.initState();
    _initLists();
    smallFotoItemNew = SmallFotoItem.copy(widget.smallFotoItem);
    _logsService.init(smallFotoItemNew.key).then((value) => setState(() {}));
    _shortDescriptionController =
        TextEditingController(text: smallFotoItemNew?.shortDescription ?? "");
    _descriptionController =
        TextEditingController(text: smallFotoItemNew?.description ?? "");
    _annotationController =
        TextEditingController(text: smallFotoItemNew?.annotation ?? "");
    _locationController = TextEditingController(
        text: smallFotoItemNew?.getLocation(widget.ks)?.name ?? "");
    _institutionController = TextEditingController(
        text: smallFotoItemNew?.getInstitution(widget.ks)?.name ?? "");
    _creatorController = TextEditingController(
        text: (smallFotoItemNew?.getCreator(widget.ks)?.firstName ?? "") +
            ((smallFotoItemNew?.getCreator(widget.ks)?.firstName) != null
                ? " "
                : "") +
            (smallFotoItemNew?.getCreator(widget.ks)?.lastName ?? ""));
    _itemSubtypeController = TextEditingController(
        text: (smallFotoItemNew?.getItemSubType(widget.ks)?.name ?? ""));
    _rightOwnerController = TextEditingController(
        text: smallFotoItemNew?.getRightOwner(widget.ks)?.name ?? "");
    _startDateController = TextEditingController(
        text:
            smallFotoItemNew?.date?.startDate?.toString()?.split(" ")?.first ??
                "");
    _endDateController = TextEditingController(
        text: smallFotoItemNew?.date?.endDate?.toString()?.split(" ")?.first ??
            "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        height: 10,
      ),
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
              widget.smallFotoItem.replace(smallFotoItemNew);
              await _uploadService.editImage(smallFotoItemNew, widget.user);
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
        controller: _shortDescriptionController,
        onChanged: (val) {
          smallFotoItemNew.shortDescription = val;
        },
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Kurzbezeichnung eingeben...'),
      ),
      LogsBox(
        title: "Kurzbezeichnung",
        logs: _logsService.shortDescriptionLogs,
        valueTyp: ValueTyp.TEXT,
        callback: (val) => setState(() {
          smallFotoItemNew.shortDescription = val;
          _shortDescriptionController.text = val;
        }),
      ),
      SelectableText("Beschreibung:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        controller: _descriptionController,
        onChanged: (val) {
          smallFotoItemNew.description = val;
        },
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Beschreibung eingeben...'),
      ),
      LogsBox(
        title: "Beschreibung",
        logs: _logsService.descriptionLogs,
        valueTyp: ValueTyp.TEXT,
        callback: (val) => setState(() {
          smallFotoItemNew.description = val;
          _descriptionController.text = val;
        }),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: RoundedButtonWidget(
                onPressed: () {
                  setState(() {
                    smallFotoItemNew.isPublic = true;
                  });
                },
                text: "öffentlich sichtbar",
                color: smallFotoItemNew.isPublic ? Colors.white : Colors.grey,
                secondColor:
                    smallFotoItemNew.isPublic ? Colors.blue : Colors.white,
              ),
            ),
            Expanded(
              child: RoundedButtonWidget(
                onPressed: () {
                  setState(() {
                    smallFotoItemNew.isPublic = false;
                  });
                },
                text: "privat sichtbar",
                color: !smallFotoItemNew.isPublic ? Colors.white : Colors.grey,
                secondColor:
                    !smallFotoItemNew.isPublic ? Colors.blue : Colors.white,
              ),
            )
          ],
        ),
      ),
      LogsBox(
        title: "Ist Öffentlich",
        logs: _logsService.isPublicLogs,
        valueTyp: ValueTyp.TEXT,
        callback: (val) => setState(() {
          smallFotoItemNew.isPublic = val == "true";
        }),
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
                            hintText: 'Datum auswählen...'),
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
                            hintText: 'Datum auswählen...'),
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
          onFocusChanged: (val) {
            if (_locationController.text.isNotEmpty) {
              return;
            }
            setState(() {
              if (val) {
                _locationKey.currentState.filteredSuggestions =
                    _getLocationSuggestions();
              }
            });
          },
          focusNode: _locationFocusNode,
          controller: _locationController,
          itemSubmitted: (item) {
            _locationController.text = item.name;
            smallFotoItemNew.locationKey = item.key;
          },
          clearOnSubmit: false,
          submitOnSuggestionTap: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal)),
              hintText: 'Ort eingeben...'),
          suggestions: _getLocationSuggestions(),
          textSubmitted: (val) {
            _showLocationDialog(name: _locationController.text);
          },
          itemBuilder: (context, location) {
            if (location.key == "-1")
              return _getAddButton(onPressed: () {
                _showLocationDialog(name: _locationController.text);
              });
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                  title: Text(location?.name ?? ""),
                  trailing:
                      Text("Country: ${location?.country?.toUpperCase()}")),
            );
          },
          key: _locationKey,
          itemSorter: (a, b) {
            if (a.key == "-1") return (1 << 62);
            if (b.key == "-1") return -(1 << 62);
            return (a?.name ?? "").compareTo(b?.name ?? "");
          },
          itemFilter: (suggestion, input) {
            return _locationFocusNode.hasFocus &&
                (suggestion.name.toLowerCase().startsWith(
                        _locationController.text.toLowerCase().trim()) ||
                    (suggestion.key == "-1" &&
                        _locationList
                            .map((e) => e.name)
                            .where((element) =>
                                element == _locationController.text)
                            .toList()
                            .isEmpty));
          }),
      LogsBox(
        title: "Ort",
        logs: _logsService.locationLogs,
        valueTyp: ValueTyp.KEY,
        json: widget.ks.locationsJson,
        callback: (val) => setState(() {
          smallFotoItemNew.locationKey = val;
          _locationController.text =
              Location.fromJson(widget.ks.locationsJson[val], val).name;
        }),
      ),
      SelectableText("Stichworte:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      Container(
        padding: EdgeInsets.only(top: 10),
        child: Wrap(
          children: smallFotoItemNew
              .getTags(widget.ks)
              .map((e) => _createTagWidget(e))
              .toList(),
        ),
      ),
      AutoCompleteTextField<Tag>(
        onFocusChanged: (val) {
          if (_tagController.text.isNotEmpty) {
            return;
          }
          setState(() {
            if (val) {
              _tagsKey.currentState.filteredSuggestions = _getTagSuggestions();
            }
          });
        },
        focusNode: _tagsFocusNode,
        controller: _tagController,
        key: _tagsKey,
        itemSubmitted: (item) {
          setState(() {
            smallFotoItemNew.tagKeys.add(item.key);
            _tagsKey.currentState.updateSuggestions(_getTagSuggestions());
          });
        },
        clearOnSubmit: true,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Stichwort eingeben...'),
        suggestions: _getTagSuggestions(),
        textSubmitted: (val) {
          _showTagDialog(name: _tagController.text);
        },
        itemBuilder: (context, tag) {
          if (tag.key == "-1")
            return _getAddButton(onPressed: () {
              _showTagDialog(name: _tagController.text);
            });
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(tag?.name ?? ""),
            ),
          );
        },
        itemSorter: (a, b) {
          if (a.key == "-1") return (1 << 62);
          if (b.key == "-1") return -(1 << 62);
          return (a?.name ?? "").compareTo(b?.name ?? "");
        },
        itemFilter: (suggestion, input) =>
            _tagsFocusNode.hasFocus &&
            (suggestion.name.toLowerCase().startsWith(input.toLowerCase()) ||
                suggestion.key == "-1" &&
                    _tagList
                        .map((e) => e.name)
                        .where((element) => element == input)
                        .toList()
                        .isEmpty),
      ),
      LogsBox(
        title: "Stichworte",
        logs: _logsService.tagsLogs,
        valueTyp: ValueTyp.LIST,
        json: widget.ks.tagJson,
        callback: (val) => setState(() {
          smallFotoItemNew.tagKeys = List<String>.from(val);
        }),
      ),
      SelectableText("Abgebildete Personen:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      Container(
        padding: EdgeInsets.only(top: 10),
        child: Wrap(
          children: smallFotoItemNew.photographedPeople
              .map((e) => _createPeopleWidget(e))
              .toList(),
        ),
      ),
      AutoCompleteTextField<People>(
        onFocusChanged: (val) {
          if (_photographedPeopleController.text.isNotEmpty) {
            return;
          }
          setState(() {
            if (val) {
              _photographedPeopleKey.currentState.filteredSuggestions =
                  _getPeopleSuggestions();
            }
          });
        },
        controller: _photographedPeopleController,
        focusNode: _photographedPeopleFocusNode,
        key: _photographedPeopleKey,
        itemSubmitted: (item) {
          setState(() {
            smallFotoItemNew.photographedPeople.add(item);
            _photographedPeopleKey.currentState
                .updateSuggestions(_getPeopleSuggestions());
          });
        },
        clearOnSubmit: true,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Person eingeben...'),
        suggestions: _getPeopleSuggestions(),
        textSubmitted: (val) {
          _showPeopleDialog(false, name: _photographedPeopleController.text);
        },
        itemBuilder: (context, people) {
          if (people.key == "-1")
            return _getAddButton(onPressed: () {
              _showPeopleDialog(false,
                  name: _photographedPeopleController.text);
            });
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                  (people?.firstName ?? "") + " " + (people?.lastName ?? "")),
            ),
          );
        },
        itemSorter: (a, b) {
          if (a.key == "-1") return (1 << 62);
          if (b.key == "-1") return -(1 << 62);
          return (a?.firstName ?? "").compareTo(b?.firstName ?? "");
        },
        itemFilter: (suggestion, input) =>
            _photographedPeopleFocusNode.hasFocus &&
            ((suggestion.firstName + " " + suggestion.lastName)
                    .toLowerCase()
                    .contains(input.toLowerCase()) ||
                (suggestion.key == "-1" &&
                    _peopleList
                        .map((e) => (e.firstName + " " + e.lastName))
                        .where((element) => element == input)
                        .toList()
                        .isEmpty)),
      ),
      LogsBox(
        title: "Abgebildete Personen",
        logs: _logsService.photographedPeopleLogs,
        valueTyp: ValueTyp.LIST,
        json: widget.ks.peopleJson,
        callback: (val) => setState(() {
          List<People> list = List();
          val.forEach(
              (e) => list.add(People.fromJson(widget.ks.peopleJson[e], e)));
          smallFotoItemNew.photographedPeople = list;
        }),
      ),
      SelectableText("Rechteinhaber:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<RightOwner>(
        onFocusChanged: (val) {
          if (_rightOwnerController.text.isNotEmpty) {
            return;
          }
          setState(() {
            if (val) {
              _rightOwnerKey.currentState.filteredSuggestions =
                  _getRightOwnerSuggestions();
            }
          });
        },
        focusNode: _rightOwnerFocusNode,
        controller: _rightOwnerController,
        itemSubmitted: (item) {
          _rightOwnerController.text = item.name;
          smallFotoItemNew.rightOwnerKey = item.key;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Rechteinhaber eingeben...'),
        suggestions: _getRightOwnerSuggestions(),
        textSubmitted: (val) {
          _showRightOwnerDialog(name: _rightOwnerController.text);
        },
        itemBuilder: (context, rightOwner) {
          if (rightOwner.key == "-1")
            return _getAddButton(onPressed: () {
              _showRightOwnerDialog(name: _rightOwnerController.text);
            });
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(rightOwner?.name ?? ""),
            ),
          );
        },
        key: _rightOwnerKey,
        itemSorter: (a, b) {
          if (a.key == "-1") return (1 << 62);
          if (b.key == "-1") return -(1 << 62);
          return (a?.name ?? "").compareTo(b?.name ?? "");
        },
        itemFilter: (suggestion, input) =>
            _rightOwnerFocusNode.hasFocus &&
            (suggestion.name.toLowerCase().startsWith(input.toLowerCase()) ||
                (suggestion.key == "-1" &&
                    _rightOwnerList
                        .map((e) => (e.name + " " + e.name))
                        .where((element) => element == input)
                        .toList()
                        .isEmpty)),
      ),
      LogsBox(
        title: "Rechteinhaber",
        logs: _logsService.rightOwnerLogs,
        valueTyp: ValueTyp.KEY,
        json: widget.ks.rightOwnerJson,
        callback: (val) => setState(() {
          smallFotoItemNew.rightOwnerKey = val;
          _rightOwnerController.text =
              RightOwner.fromJson(widget.ks.rightOwnerJson[val], val).name;
        }),
      ),
      SelectableText("Institution:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<Institution>(
        onFocusChanged: (val) {
          if (_institutionController.text.isNotEmpty) {
            return;
          }
          setState(() {
            if (val) {
              _institutionKey.currentState.filteredSuggestions =
                  _getInstitutionSuggestions();
            }
          });
        },
        focusNode: _institutionFocusNode,
        controller: _institutionController,
        itemSubmitted: (item) {
          _institutionController.text = item.name;
          smallFotoItemNew.institutionKey = item.key;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Institution eingeben...'),
        suggestions: _getInstitutionSuggestions(),
        textSubmitted: (val) {
          _showInstitutionDialog(name: _institutionController.text);
        },
        itemBuilder: (context, institution) {
          if (institution.key == "-1")
            return _getAddButton(onPressed: () {
              _showInstitutionDialog(name: _institutionController.text);
            });
          return Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(institution?.name ?? ""),
              ));
        },
        key: _institutionKey,
        itemSorter: (a, b) {
          if (a.key == "-1") return (1 << 62);
          if (b.key == "-1") return -(1 << 62);
          return (a?.name ?? "").compareTo(b?.name ?? "");
        },
        itemFilter: (suggestion, input) =>
            _institutionFocusNode.hasFocus &&
            (suggestion.name.toLowerCase().startsWith(input.toLowerCase()) ||
                (suggestion.key == "-1" &&
                    _institutionList
                        .map((e) => (e.name + " " + e.name))
                        .where((element) => element == input)
                        .toList()
                        .isEmpty)),
      ),
      LogsBox(
        title: "Institution",
        logs: _logsService.institutionLogs,
        valueTyp: ValueTyp.KEY,
        json: widget.ks.institutionJson,
        callback: (val) => setState(() {
          smallFotoItemNew.institutionKey = val;
          _institutionController.text =
              Institution.fromJson(widget.ks.institutionJson[val], val).name;
        }),
      ),
      SelectableText("Foto - Typ:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<ItemSubtype>(
        onFocusChanged: (val) {
          if (_itemSubtypeController.text.isNotEmpty) {
            return;
          }
          setState(() {
            if (val) {
              _itemSubtypeKey.currentState.filteredSuggestions =
                  _getItemSubTypeSuggestions();
            }
          });
        },
        focusNode: _itemSubtypeFocusNode,
        controller: _itemSubtypeController,
        itemSubmitted: (item) {
          _itemSubtypeController.text = item.name;
          smallFotoItemNew.itemSubTypeKey = item.key;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Foto-Typ eingeben...'),
        suggestions: _getItemSubTypeSuggestions(),
        textSubmitted: (val) {
          _showSubtypeDialog(name: _itemSubtypeController.text);
        },
        itemBuilder: (context, subtype) {
          if (subtype.key == "-1")
            return _getAddButton(onPressed: () {
              _showSubtypeDialog(name: _itemSubtypeController.text);
            });
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(subtype?.name ?? ""),
            ),
          );
        },
        key: _itemSubtypeKey,
        itemSorter: (a, b) {
          if (a.key == "-1") return (1 << 62);
          if (b.key == "-1") return -(1 << 62);
          return (a?.name ?? "").compareTo(b?.name ?? "");
        },
        itemFilter: (suggestion, input) =>
            _itemSubtypeFocusNode.hasFocus &&
            (suggestion.name.toLowerCase().startsWith(input.toLowerCase()) ||
                (suggestion.key == "-1" &&
                    _itemSubTypeList
                        .map((e) => (e.name + " " + e.name))
                        .where((element) => element == input)
                        .toList()
                        .isEmpty)),
      ),
      LogsBox(
        title: "Foto - Typ",
        logs: _logsService.itemSubtypeLogs,
        valueTyp: ValueTyp.KEY,
        json: widget.ks.itemSubtypeJson,
        callback: (val) => setState(() {
          smallFotoItemNew.itemSubTypeKey = val;
          _itemSubtypeController.text =
              ItemSubtype.fromJson(widget.ks.itemSubtypeJson[val], val).name;
        }),
      ),
      SelectableText("Fotograf:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      AutoCompleteTextField<People>(
        onFocusChanged: (val) {
          if (_creatorController.text.isNotEmpty) {
            return;
          }
          setState(() {
            if (val) {
              _creatorKey.currentState.filteredSuggestions =
                  _getPeopleSuggestions();
            }
          });
        },
        controller: _creatorController,
        focusNode: _creatorFocusNode,
        itemSubmitted: (item) {
          _creatorController.text =
              (item.firstName ?? "") + " " + (item.lastName ?? "");
          smallFotoItemNew.creatorKey = item.key;
        },
        clearOnSubmit: false,
        submitOnSuggestionTap: true,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
            hintText: 'Fotograf eingeben...'),
        suggestions: _getPeopleSuggestions(),
        textSubmitted: (val) {
          _showPeopleDialog(true, name: _creatorController.text);
        },
        itemBuilder: (context, creator) {
          if (creator.key == "-1")
            return _getAddButton(onPressed: () {
              _showPeopleDialog(true, name: _creatorController.text);
            });
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                  (creator?.firstName ?? "") + " " + (creator?.lastName ?? "")),
            ),
          );
        },
        key: _creatorKey,
        itemSorter: (a, b) {
          if (a.key == "-1") return (1 << 62);
          if (b.key == "-1") return -(1 << 62);
          return (a?.firstName ?? "").compareTo(b?.firstName ?? "");
        },
        itemFilter: (suggestion, input) =>
            _creatorFocusNode.hasFocus &&
            ((suggestion.firstName + " " + suggestion.lastName)
                    .toLowerCase()
                    .contains(input) ||
                (suggestion.key == "-1" &&
                    _peopleList
                        .map((e) => (e.firstName + " " + e.lastName))
                        .where((element) => element == input)
                        .toList()
                        .isEmpty)),
      ),
      LogsBox(
        title: "Fotograf",
        logs: _logsService.creatorLogs,
        valueTyp: ValueTyp.KEY,
        json: widget.ks.peopleJson,
        callback: (val) => setState(() {
          smallFotoItemNew.creatorKey = val;
          _creatorController.text =
              People.fromJson(widget.ks.peopleJson[val], val).firstName;
        }),
      ),
      SelectableText("Vermerk:",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: ButtonColors.appBarColor,
              fontSize: 17)),
      TextField(
        onChanged: (val) {
          smallFotoItemNew.annotation = val;
        },
        controller: _annotationController,
        minLines: 3,
        maxLines: 10,
        decoration: InputDecoration(
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal)),
            hintText: 'Vermerk eingeben...'),
      ),
      LogsBox(
        title: "Vermerk",
        logs: _logsService.annotationLogs,
        valueTyp: ValueTyp.TEXT,
        callback: (val) => setState(() {
          smallFotoItemNew.annotation = val;
          _annotationController.text = val;
        }),
      ),
      Container(
        height: 10,
      )
    ]);
  }

  void _showDatePicker(bool isStart) async {
    DateTime val = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1000),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (isStart) {
      smallFotoItemNew.date.startDate = val;
      _startDateController.text =
          smallFotoItemNew?.date?.startDate?.toString()?.split(" ")?.first ??
              "";
    } else {
      smallFotoItemNew.date.endDate = val;
      _endDateController.text =
          smallFotoItemNew?.date?.endDate?.toString()?.split(" ")?.first ?? "";
    }
  }

  Widget _createTagWidget(Tag e) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.blue,
        ),
        margin: EdgeInsets.only(right: 10, bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              e?.name ?? "",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Container(
              width: 8,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    smallFotoItemNew.tagKeys.remove(e.key);
                    _tagsKey.currentState
                        .updateSuggestions(_getTagSuggestions());
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
        margin: EdgeInsets.only(right: 10, bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              e?.firstName ?? "",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Container(
              width: 5,
            ),
            Text(
              e?.lastName ?? "",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              width: 8,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    smallFotoItemNew.photographedPeople.remove(e);
                    _photographedPeopleKey.currentState
                        .updateSuggestions(_getPeopleSuggestions());
                  });
                },
              ),
            )
          ],
        ),
      );

  _deleteLocation({Location location}) async {
    widget.ks.editLocation(EditingTypEnum.DELETE, location);
    setState(() {
      _initLocationList();
      _updateLocationSuggestions();
    });
  }

  _showLocationDialog({String name}) async {
    Location result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return LocationDialog(name: name, ks: widget.ks);
        });

    if (result == null) {
      return;
    }
    setState(() {
      _initLocationList();
      smallFotoItemNew.locationKey = result.key;
      _updateLocationSuggestions();
    });
  }

  _updateLocationSuggestions() {
    _locationKey.currentState.updateSuggestions(_getLocationSuggestions());
    _locationFocusNode.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _deleteTag({Tag tag}) async {
    widget.ks.editTag(EditingTypEnum.DELETE, tag);
    setState(() {
      _initTagList();
    });
  }

  _showTagDialog({String name}) async {
    Tag result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return TagDialog(name: name, ks: widget.ks);
        });

    if (result == null) {
      return;
    }
    setState(() {
      _initTagList();
      smallFotoItemNew.tagKeys.add(result.key);
      _updateTagSuggestions();
    });
  }

  _updateTagSuggestions() {
    _tagsKey.currentState.updateSuggestions(_getTagSuggestions());
    _tagController.text = "";
    _tagsFocusNode.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _deletePeople({People people}) async {
    widget.ks.editPeople(EditingTypEnum.DELETE, people);
    setState(() {
      _initPeopleList();
    });
  }

  _showPeopleDialog(bool forCreator, {String name}) async {
    People result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return PeopleDialog(name: name, ks: widget.ks);
        });

    if (result == null) {
      return;
    }
    setState(() {
      _initPeopleList();
      if (forCreator)
        smallFotoItemNew.creatorKey = result.key;
      else
        smallFotoItemNew.photographedPeople.add(result);
      _updatePeopleSuggestions(forCreator: forCreator);
    });
  }

  _updatePeopleSuggestions({bool forCreator}) {
    _creatorKey.currentState.updateSuggestions(_getPeopleSuggestions());
    _photographedPeopleKey.currentState
        .updateSuggestions(_getPeopleSuggestions());
    if (forCreator ?? true) {
      _creatorFocusNode.unfocus();
    }
    if (!(forCreator ?? false)) {
      _photographedPeopleFocusNode.unfocus();
      _photographedPeopleController.text = "";
    }
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _deleteInstitution({Institution institution}) async {
    widget.ks.editInstitution(EditingTypEnum.DELETE, institution);
    setState(() {
      _initInstitutionList();
    });
  }

  _showInstitutionDialog({String name}) async {
    Institution result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return InstitutionDialog(name: name, ks: widget.ks);
        });

    if (result == null) {
      return;
    }
    setState(() {
      _initInstitutionList();
      smallFotoItemNew.institutionKey = result.key;
      _updateInstitutionSuggestions();
    });
  }

  _updateInstitutionSuggestions() {
    _institutionKey.currentState
        .updateSuggestions(_getInstitutionSuggestions());
    _institutionFocusNode.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _deleteRightOwner({RightOwner rightOwner}) async {
    widget.ks.editRightOwner(EditingTypEnum.DELETE, rightOwner);
    setState(() {
      _initRightOwnerList();
    });
  }

  _showRightOwnerDialog({String name}) async {
    RightOwner result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return RightOwnerDialog(name: name, ks: widget.ks);
        });

    if (result == null) {
      return;
    }
    setState(() {
      _initRightOwnerList();
      smallFotoItemNew.rightOwnerKey = result.key;
      _updateRightOwnerSuggestions();
    });
  }

  _updateRightOwnerSuggestions() {
    _rightOwnerKey.currentState.updateSuggestions(_getRightOwnerSuggestions());
    _rightOwnerFocusNode.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _deleteSubtype({ItemSubtype itemSubtype}) async {
    widget.ks.editItemSubType(EditingTypEnum.DELETE, itemSubtype);
    setState(() {
      _initItemSubTypeList();
    });
  }

  _showSubtypeDialog({String name}) async {
    ItemSubtype result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SubtypeDialog(name: name, ks: widget.ks);
        });

    if (result == null) {
      return;
    }
    setState(() {
      _initItemSubTypeList();
      smallFotoItemNew.itemSubTypeKey = result.key;
      _updateSubtypesSuggestions();
    });
  }

  _updateSubtypesSuggestions() {
    _itemSubtypeKey.currentState
        .updateSuggestions(_getItemSubTypeSuggestions());
    _itemSubtypeFocusNode.unfocus();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  List<Tag> _getTagSuggestions() {
    List<Tag> list = List();
    list.addAll(_tagList.where((element) {
      for (int i = 0; i < smallFotoItemNew.tagKeys.length; i++)
        if (smallFotoItemNew.tagKeys[i] == element.key) return false;
      return true;
    }).toList());
    list.add(Tag(key: "-1", name: "-1"));
    return list;
  }

  List<People> _getPeopleSuggestions() {
    List<People> list = List();
    list.addAll(_peopleList.where((element) {
      for (int i = 0; i < smallFotoItemNew.photographedPeople.length; i++)
        if (smallFotoItemNew.photographedPeople[i].key == element.key)
          return false;
      return true;
    }).toList());
    list.add(People(key: "-1", firstName: "-1", lastName: "-1"));
    return list;
  }

  List<Location> _getLocationSuggestions() {
    List<Location> list = List();
    list.addAll(_locationList);
    list.add(Location(key: "-1", name: "-1", country: "-1"));
    return list;
  }

  List<ItemSubtype> _getItemSubTypeSuggestions() {
    List<ItemSubtype> list = List();
    list.addAll(_itemSubTypeList);
    list.add(ItemSubtype(key: "-1", name: "-1"));
    return list;
  }

  List<Institution> _getInstitutionSuggestions() {
    List<Institution> list = List();
    list.addAll(_institutionList);
    list.add(Institution(key: "-1", name: "-1", contactInformation: "-1"));
    return list;
  }

  List<RightOwner> _getRightOwnerSuggestions() {
    List<RightOwner> list = List();
    list.addAll(_rightOwnerList);
    list.add(RightOwner(key: "-1", name: "-1", contactInformation: "-1"));
    return list;
  }

  void _initLists() => setState(() {
        _initInstitutionList();
        _initItemSubTypeList();
        _initLocationList();
        _initRightOwnerList();
        _initPeopleList();
        _initTagList();
      });

  void _initLocationList() {
    _locationList.clear();
    widget.ks.locationsJson?.forEach(
        (key, value) => _locationList.add(Location.fromJson(value, key)));
  }

  void _initRightOwnerList() {
    _rightOwnerList.clear();
    widget.ks.rightOwnerJson?.forEach(
        (key, value) => _rightOwnerList.add(RightOwner.fromJson(value, key)));
  }

  void _initInstitutionList() {
    _institutionList.clear();
    widget.ks.institutionJson?.forEach(
        (key, value) => _institutionList.add(Institution.fromJson(value, key)));
  }

  void _initItemSubTypeList() {
    _itemSubTypeList.clear();
    widget.ks.itemSubtypeJson?.forEach(
        (key, value) => _itemSubTypeList.add(ItemSubtype.fromJson(value, key)));
  }

  void _initPeopleList() {
    _peopleList.clear();
    widget.ks.peopleJson
        ?.forEach((key, value) => _peopleList.add(People.fromJson(value, key)));
  }

  void _initTagList() {
    _tagList.clear();
    widget.ks.tagJson
        ?.forEach((key, value) => _tagList.add(Tag.fromJson(value, key)));
  }

  Widget _getAddButton({VoidCallback onPressed}) {
    return RaisedButton(
      child: Text("Neu Hinzufügen"),
      textColor: Colors.white,
      color: Colors.green,
      onPressed: onPressed,
    );
  }
}
