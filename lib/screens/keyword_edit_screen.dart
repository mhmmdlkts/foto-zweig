import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/dialogs/new_location_dialog.dart';
import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/item_subtype.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/services/keyword_service.dart';

class KeywordEditScreen extends StatefulWidget {
  final KeywordService ks;

  KeywordEditScreen({this.ks});

  @override
  _KeywordEditScreenState createState() => _KeywordEditScreenState();
}

class _KeywordEditScreenState extends State<KeywordEditScreen> {

  final List<Location> _locationList = List();
  final List<RightOwner> _rightOwnerList = List();
  final List<Institution> _institutionList = List();
  final List<ItemSubtype> _itemSubTypeList = List();
  final List<People> _peopleList = List();
  final List<Tag> _tagList = List();

  @override
  void initState() {
    super.initState();
    _initLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keywords Editing"),
        backgroundColor: ButtonColors.appBarColor,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          _title("Locations", () => _showLocationDialog(),),
          _getLocations()
        ],
      )
    );
  }

  Widget _title(String title, VoidCallback onAddPressed) => Container(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.black54,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        IconButton(icon: Icon(Icons.add, color: Colors.white,), onPressed: () => onAddPressed.call(),),
      ],
    ),
  );

  Widget _getLocations() => Column(
    children: _locationList.map((e) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(e.name),
          _settingButtons(
            onEdit: () => _showLocationDialog(location: e),
            onDelete: () => _deleteLocation(location: e)
          )
        ],
      ),
    )).toList(),
  );

  Widget _settingButtons({VoidCallback onDelete, VoidCallback onEdit}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: Icon(Icons.edit), onPressed: () => onEdit.call(),),
        IconButton(icon: Icon(Icons.delete, color: Colors.redAccent,), onPressed: () => onDelete.call(),),
      ],
    );
  }

  _deleteLocation({Location location}) async {
    widget.ks.editLocation(EditingTypEnum.DELETE, location);
    _initLists();
  }
  
  _showLocationDialog({Location location}) async {
    Location result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocationDialog(location: location,);
    });

    if (result == null) {
      return;
    } else if (location != null) {
      location = Location.copy(location);
      await widget.ks.editLocation(EditingTypEnum.UPDATE, result);
      _initLists();
    } else {
      await widget.ks.editLocation(EditingTypEnum.CREATE, result);
      _initLists();
    }
  }

  void _initLists() => setState(() {
    _locationList.clear();
    _rightOwnerList.clear();
    _institutionList.clear();
    _itemSubTypeList.clear();
    _peopleList.clear();
    _tagList.clear();
    widget.ks.locationsJson?.forEach((key, value) => _locationList.add(Location.fromJson(value, key)));
    widget.ks.rightOwnerJson?.forEach((key, value) => _rightOwnerList.add(RightOwner.fromJson(value, key)));
    widget.ks.institutionJson?.forEach((key, value) => _institutionList.add(Institution.fromJson(value, key)));
    widget.ks.itemSubtypeJson?.forEach((key, value) => _itemSubTypeList.add(ItemSubtype.fromJson(value, key)));
    widget.ks.peopleJson?.forEach((key, value) => _peopleList.add(People.fromJson(value, key)));
    widget.ks.tagJson?.forEach((key, value) => _tagList.add(Tag.fromJson(value, key)));
  });
}