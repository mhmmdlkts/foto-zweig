import 'dart:convert';

import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';
import 'package:http/http.dart' as http;

const String API_URL = "https://europe-west1-foto-zweig-312d2.cloudfunctions.net/";

class InitFotos {

  static String getApiUrl(extension) => '$API_URL/$extension';

  static Future<List<SmallFotoItem>> getAllItems(String uid, KeywordService keywordService) async {
    List<SmallFotoItem> allItems = List();

    String url = getApiUrl("getAllFotos");
    if (uid != null)
      url += '?uid=$uid';
    final response = await http.get(url);
    final Map jsonData = json.decode(response.body);
    jsonData.forEach((key, element) {
      SmallFotoItem item = SmallFotoItem.fromJson(
        element,
        key,
        keywordService
      );
      allItems.add(item);
    });
    return allItems;
  }

  static Future<Map> getJson(String name) async => json.decode((await http.get(getApiUrl(name))).body);
}