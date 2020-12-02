import 'package:flutter/material.dart';
import 'package:foto_zweig/decoration/button_colors.dart';
import 'package:foto_zweig/dialogs/new_institution_dialog.dart';
import 'package:foto_zweig/dialogs/new_location_dialog.dart';
import 'package:foto_zweig/dialogs/new_people_dialog.dart';
import 'package:foto_zweig/dialogs/new_right_owner_dialog.dart';
import 'package:foto_zweig/dialogs/new_subtype_dialog.dart';
import 'package:foto_zweig/dialogs/new_tag_dialog.dart';
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
          _getLocations(),
          _title("Tags", () => _showTagDialog(),),
          _getTags(),
          _title("Peoples", () => _showPeopleDialog(),),
          _getPeoples(),
          _title("Institution", () => _showInstitutionDialog(),),
          _getInstitution(),
          _title("Right Owners", () => _showRightOwnerDialog(),),
          _getRightOwners(),
          _title("Item Subtypes", () => _showSubtypesDialog(),),
          _getSubtypes()
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
          new Spacer(),
          _settingButtons(
            onEdit: () => _showLocationDialog(location: e),
            onDelete: () => _deleteLocation(location: e)
          )
        ],
      ),
    )).toList(),
  );

  Widget _getTags() => Column(
    children: _tagList.map((e) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(e.name),
          new Spacer(),
          _settingButtons(
            onEdit: () => _showTagDialog(tag: e),
            onDelete: () => _deleteTag(tag: e)
          )
        ],
      ),
    )).toList(),
  );

  Widget _getPeoples() => Column(
    children: _peopleList.map((e) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(e.firstName + " " + e.lastName),
          new Spacer(),
          _settingButtons(
            onEdit: () => _showPeopleDialog(people: e),
            onDelete: () => _deletePeople(people: e)
          )
        ],
      ),
    )).toList(),
  );

  Widget _getInstitution() => Column(
    children: _institutionList.map((e) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(e.name),
          new Spacer(),
          _settingButtons(
            onEdit: () => _showInstitutionDialog(institution: e),
            onDelete: () => _deleteInstitution(institution: e)
          )
        ],
      ),
    )).toList(),
  );

  Widget _getRightOwners() => Column(
    children: _rightOwnerList.map((e) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(e.name),
          new Spacer(),
          _settingButtons(
            onEdit: () => _showRightOwnerDialog(rightOwner: e),
            onDelete: () => _deleteRightOwner(rightOwner: e)
          )
        ],
      ),
    )).toList(),
  );

  Widget _getSubtypes() => Column(
    children: _itemSubTypeList.map((e) => Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(e.name),
          new Spacer(),
          _settingButtons(
            onEdit: () => _showSubtypesDialog(itemSubtype: e),
            onDelete: () => _deleteSubtype(itemSubtype: e)
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
    setState(() {
      _initLocationList();
    });
  }

  _showLocationDialog({Location location}) async {
    Location result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return LocationDialog(location: location, ks: widget.ks);
    });

    if (result == null) {
      return;
    }
    setState(() {
      _initLocationList();
    });
  }

  _deleteTag({Tag tag}) async {
    widget.ks.editTag(EditingTypEnum.DELETE, tag);
    setState(() {
      _initTagList();
    });
  }

  _showTagDialog({Tag tag}) async {
    Tag result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return TagDialog(tag: tag, ks: widget.ks);
    });

    if (result == null) {
      return;
    }
    setState(() {
      _initTagList();
    });
  }

  _deletePeople({People people}) async {
    widget.ks.editPeople(EditingTypEnum.DELETE, people);
    setState(() {
      _initPeopleList();
    });
  }

  _showPeopleDialog({People people}) async {
    People result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PeopleDialog(people: people, ks: widget.ks);
    });

    if (result == null) {
      return;
    }
    setState(() {
      _initPeopleList();
    });
  }

  _deleteInstitution({Institution institution}) async {
    widget.ks.editInstitution(EditingTypEnum.DELETE, institution);
    setState(() {
      _initInstitutionList();
    });
  }

  _showInstitutionDialog({Institution institution}) async {
    Institution result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return InstitutionDialog(institution: institution, ks: widget.ks);
    });

    if (result == null) {
      return;
    }
    setState(() {
      _initInstitutionList();
    });
  }

  _deleteRightOwner({RightOwner rightOwner}) async {
    widget.ks.editRightOwner(EditingTypEnum.DELETE, rightOwner);
    setState(() {
      _initRightOwnerList();
    });
  }

  _showRightOwnerDialog({RightOwner rightOwner}) async {
    RightOwner result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return RightOwnerDialog(rightOwner: rightOwner, ks: widget.ks);
    });

    if (result == null) {
      return;
    }
    setState(() {
      _initRightOwnerList();
    });
  }

  _deleteSubtype({ItemSubtype itemSubtype}) async {
    widget.ks.editItemSubType(EditingTypEnum.DELETE, itemSubtype);
    setState(() {
      _initItemSubTypeList();
    });
  }

  _showSubtypesDialog({ItemSubtype itemSubtype}) async {
    ItemSubtype result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SubtypeDialog(itemSubtype: itemSubtype, ks: widget.ks);
    });

    if (result == null) {
      return;
    }
    setState(() {
      _initItemSubTypeList();
    });
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
    widget.ks.locationsJson?.forEach((key, value) => _locationList.add(Location.fromJson(value, key)));
  }

  void _initRightOwnerList() {
    _rightOwnerList.clear();
    widget.ks.rightOwnerJson?.forEach((key, value) => _rightOwnerList.add(RightOwner.fromJson(value, key)));
  }

  void _initInstitutionList() {
    _institutionList.clear();
    widget.ks.institutionJson?.forEach((key, value) => _institutionList.add(Institution.fromJson(value, key)));
  }

  void _initItemSubTypeList() {
    _itemSubTypeList.clear();
    widget.ks.itemSubtypeJson?.forEach((key, value) => _itemSubTypeList.add(ItemSubtype.fromJson(value, key)));
  }

  void _initPeopleList() {
    _peopleList.clear();
    widget.ks.peopleJson?.forEach((key, value) => _peopleList.add(People.fromJson(value, key)));
  }

  void _initTagList() {
    _tagList.clear();
    widget.ks.tagJson?.forEach((key, value) => _tagList.add(Tag.fromJson(value, key)));
  }
}