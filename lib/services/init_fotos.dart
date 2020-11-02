import 'dart:convert';

import 'package:foto_zweig/models/main_foto.dart';
import 'package:http/http.dart' as http;

class InitFotos {

  static const String API_URL = "https://foto-zweig.appspot.com/api/alpha/item";
  static String getApiUrl(item) => '$API_URL/$item';

  static Future<List<SmallFotoItem>> getAllItems() async {
    List<SmallFotoItem> allItems = List();
    for (int i = 0; i < 45; i++) {
      SmallFotoItem result = await getItem(i);
      if (result == null)
        continue;
      allItems.add(result);
    }
    allItems.sort();
    return allItems;
  }

  static Future<SmallFotoItem> getItem(id) async {
    print(id);
    try {
      final response = await http.get(getApiUrl(id));
      if (response.statusCode != 200)
        return null;
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      final a = SmallFotoItem.fromJson(jsonData);
      return a;
    } catch (e) {
      print(e);
    }
    return null;
  }
}