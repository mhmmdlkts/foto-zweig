import 'dart:convert';

import 'package:foto_zweig/enums/editing_typ_enum.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:http/http.dart' as http;

import 'init_fotos.dart';

class KeywordService {
  Map locationsJson;
  Map rightOwnerJson;
  Map institutionJson;
  Map itemSubtypeJson;
  Map tagJson;
  Map peopleJson;

  static const String API_URL = "https://europe-west1-foto-zweig-312d2.cloudfunctions.net/";
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

  String encodedObject(obj) => Uri.encodeComponent(json.encode(obj.toJson()));
}