import 'dart:convert';

import 'package:foto_zweig/models/log.dart';
import 'package:foto_zweig/models/log_list.dart';
import 'package:http/http.dart' as http;

import 'init_fotos.dart';

class LogsService {
  LogList annotationLogs = LogList();
  LogList creatorLogs = LogList();
  LogList descriptionLogs = LogList();
  LogList institutionLogs = LogList();
  LogList isPublicLogs = LogList();
  LogList itemSubtypeLogs = LogList();
  LogList locationLogs = LogList();
  LogList photographedPeopleLogs = LogList();
  LogList rightOwnerLogs = LogList();
  LogList shortDescriptionLogs = LogList();
  LogList tagsLogs = LogList();

  LogsService();

  Future<void> init(key) async {
    Map json = await getJson(key);
    annotationLogs = LogList.fromJson(json["annotation"]);
    creatorLogs = LogList.fromJson(json["creator"]);
    descriptionLogs = LogList.fromJson(json["description"]);
    institutionLogs = LogList.fromJson(json["institution"]);
    isPublicLogs = LogList.fromJson(json["isPublic"]);
    itemSubtypeLogs = LogList.fromJson(json["itemSubtype"]);
    locationLogs = LogList.fromJson(json["location"]);
    photographedPeopleLogs = LogList.fromJson(json["photographedPeople"]);
    rightOwnerLogs = LogList.fromJson(json["rightOwner"]);
    shortDescriptionLogs = LogList.fromJson(json["shortDescription"]);
    tagsLogs = LogList.fromJson(json["tags"]);
  }

  static Future<Map> getJson(String key) async => json.decode((await http.get('$API_URL/getLogs?key=$key')).body);
}