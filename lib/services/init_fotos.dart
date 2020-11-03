import 'dart:convert';

import 'package:foto_zweig/models/main_foto.dart';
import 'package:http/http.dart' as http;

class InitFotos {

  static const String API_URL = "https://foto-zweig.appspot.com/api/alpha/item";
  static String getApiUrl(item) => '$API_URL/$item';

  static Future<List<SmallFotoItem>> getAllItems() async {
    List<SmallFotoItem> allItems = List();
    
    List<Future> futures = <Future>[];

    Future addItem (int i) async {
      SmallFotoItem result = await getItem(i);
      if (result != null)
        allItems.add(result);
    }

    for (int i = 0; i < 45; i++) {
      futures.add(addItem(i));
    }
    await Future.wait(futures);
    allItems.sort();
    return allItems;
  }

  static Future<SmallFotoItem> getItem(id) async {
    try {
      final response = await http.get(getApiUrl(id));
      print(id);
      if (response.statusCode != 200)
        return null;
      final jsonData = json.decode(utf8.decode(response.bodyBytes));
      return SmallFotoItem.fromJson(jsonData);
    } catch (e) {
      print(e);
    }
    return null;
  }
}