import 'dart:convert';

import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/item_subtype.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:http/http.dart' as http;

import 'init_fotos.dart';

class KeywordService {
  Map locationsJson;
  Map rightOwnerJson;
  Map institutionJson;
  Map itemSubtypeJson;
  Map tagJson;
  Map peopleJson;

  static String getApiUrl(extension) => '$API_URL/$extension';
  static String getRemoveUrl(keyword, key) => '$API_URL/removeKeyword?keyword=$keyword&key=$key';

  initKeywords() => Future.wait([
    _initOnly((map) => institutionJson = map, "getAllInstitutions"),
    _initOnly((map) => rightOwnerJson = map, "getAllRightOwners"),
    _initOnly((map) => itemSubtypeJson = map, "getAllSubtypes"),
    _initOnly((map) => locationsJson = map, "getAllLocations"),
    _initOnly((map) => peopleJson = map, "getAllPeoples"),
    _initOnly((map) => tagJson = map, "getAllTags")
  ]);
  
  Future<void> _initOnly(Function(Map val) response, String method) async => response.call(await InitFotos.getJson(method));

  Future<void> editLocation(EditingTypEnum editingTyp, Location location) async {
    if (editingTyp == EditingTypEnum.DELETE) {
      http.get(getRemoveUrl("locations",location.key));
      locationsJson.remove(location.key);
      return;
    }
    String url = getApiUrl("updateLocation") + '?location=${encodedObject(location)}';
    final result = json.decode((await http.get(url)).body);
    location.key = result["key"];
    locationsJson[location.key] = location.toJson();
  }

  Future<void> editTag(EditingTypEnum editingTyp, Tag tag) async {
    if (editingTyp == EditingTypEnum.DELETE) {
      http.get(getRemoveUrl("tags",tag.key));
      tagJson.remove(tag.key);
      return;
    }
    String url = getApiUrl("updateTag") + '?tag=${encodedObject(tag)}';
    final result = json.decode((await http.get(url)).body);
    tag.key = result["key"];
    tagJson[tag.key] = tag.toJson();
  }

  Future<void> editItemSubType(EditingTypEnum editingTyp, ItemSubtype itemSubtype) async {
    if (editingTyp == EditingTypEnum.DELETE) {
      http.get(getRemoveUrl("itemSubtypes",itemSubtype.key));
      itemSubtypeJson.remove(itemSubtype.key);
      return;
    }
    String url = getApiUrl("updateSubtypes") + '?itemSubtype=${encodedObject(itemSubtype)}';
    final result = json.decode((await http.get(url)).body);
    itemSubtype.key = result["key"];
    itemSubtypeJson[itemSubtype.key] = itemSubtype.toJson();
  }

  Future<void> editInstitution(EditingTypEnum editingTyp, Institution institution) async {
    if (editingTyp == EditingTypEnum.DELETE) {
      http.get(getRemoveUrl("institutions",institution.key));
      institutionJson.remove(institution.key);
      return;
    }
    String url = getApiUrl("updateInstitution") + '?institution=${encodedObject(institution)}';
    final result = json.decode((await http.get(url)).body);
    institution.key = result["key"];
    institutionJson[institution.key] = institution.toJson();
  }

  Future<void> editPeople(EditingTypEnum editingTyp, People people) async {
    if (editingTyp == EditingTypEnum.DELETE) {
      http.get(getRemoveUrl("peoples",people.key));
      peopleJson.remove(people.key);
      return;
    }
    String url = getApiUrl("updatePeople") + '?people=${encodedObject(people)}';
    final result = json.decode((await http.get(url)).body);
    people.key = result["key"];
    peopleJson[people.key] = people.toJson();
  }

  Future<void> editRightOwner(EditingTypEnum editingTyp, RightOwner rightOwner) async {
    if (editingTyp == EditingTypEnum.DELETE) {
      http.get(getRemoveUrl("rightOwners",rightOwner.key));
      rightOwnerJson.remove(rightOwner.key);
      return;
    }
    String url = getApiUrl("updateRightOwner") + '?rightOwner=${encodedObject(rightOwner)}';
    final result = json.decode((await http.get(url)).body);
    rightOwner.key = result["key"];
    rightOwnerJson[rightOwner.key] = rightOwner.toJson();
  }

  String encodedObject(obj) => Uri.encodeComponent(json.encode(obj.toJson()));
}