import 'package:foto_zweig/models/log.dart';

class LogList {
  List<Log> logs = List();

  LogList();

  LogList.fromJson (jsonObj) {
    if (jsonObj == null)
      return;
    jsonObj.forEach((e) => logs.add(Log.fromJson(e)));
    logs.sort();
  }
}