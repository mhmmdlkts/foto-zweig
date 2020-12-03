import 'dart:convert';

import 'package:foto_zweig/enums/item_type_enum.dart';
import 'package:foto_zweig/models/item_infos/date.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';
import 'package:foto_zweig/models/item_infos/tag.dart';
import 'package:foto_zweig/services/keyword_service.dart';

import 'item_infos/item_subtype.dart';

class SmallFotoItem implements Comparable {
  String key;
  String shortDescription;
  Date date;
  String description;
  String annotation;
  String filename;
  String thumbnailPath;
  String path;
  List<String> tagKeys = List();
  List<People> photographedPeople = List();
  String locationKey;
  String rightOwnerKey;
  String institutionKey;
  ItemTypeEnum itemType;
  String itemSubTypeKey;
  String creatorKey;
  bool isPublic;

  SmallFotoItem({this.shortDescription, this.itemType});

  SmallFotoItem.fromJson(json, key, KeywordService ks) {
    if (json == null) json = Map();
    this.key = key;
    shortDescription = json["shortDescription"];
    date = Date.fromJson(json["date"]);
    description = json["description"];
    annotation = json["annotation"];
    filename = json["filename"];
    thumbnailPath = json["urls"]["thumbnail"];
    path = json["urls"]["original"];
    if (path == null)
      path = json["urls"]["watermark"];
    if (json["tags"] != null) {
      json["tags"].forEach((element) {
        tagKeys.add(element);
      });
    }
    if (json["photographedPeople"] != null) {
      json["photographedPeople"].forEach((element) {
        photographedPeople.add(People.fromJson(ks.peopleJson[element], element));
      });
    }

    locationKey = json["location"];
    rightOwnerKey = json["rightOwner"];
    institutionKey = json["institution"];
    itemSubTypeKey = json["itemSubtype"];
    creatorKey = json["creator"];
    itemType = intToItemTypeEnum(json["itemType"]);
    isPublic = json["isPublic"] == 'true';
  }

  List<Tag> getTags(KeywordService ks) => tagKeys.map((e) => Tag.fromJson(ks.tagJson[e], e)).toList();
  Location getLocation(KeywordService ks) => Location.fromJson(ks.locationsJson[locationKey], locationKey);
  RightOwner getRightOwner(KeywordService ks) => RightOwner.fromJson(ks.rightOwnerJson[rightOwnerKey], rightOwnerKey);
  Institution getInstitution(KeywordService ks) => Institution.fromJson(ks.institutionJson[institutionKey], institutionKey);
  ItemSubtype getItemSubType(KeywordService ks) => ItemSubtype.fromJson(ks.itemSubtypeJson[itemSubTypeKey], itemSubTypeKey);
  People getCreator(KeywordService ks) => People.fromJson(ks.peopleJson[creatorKey], creatorKey);

  static ItemTypeEnum intToItemTypeEnum(int id) {
    switch (id) {
      case 0:
        return ItemTypeEnum.FOTO;
      case 1:
        return ItemTypeEnum.DOCUMENT;
    }
    return null;
  }

  int itemTypeEnumToInt() {
    switch (itemType) {
      case ItemTypeEnum.FOTO:
        return 0;
      case ItemTypeEnum.DOCUMENT:
        return 1;
    }
    return null;
  }

  @override
  int compareTo(other) => (date?.startDate?.millisecondsSinceEpoch ?? 0) -
        (other?.date?.startDate?.millisecondsSinceEpoch ?? 0);

  String getReadablePersons() {
    String result = "";
    for (int i = 0; i < photographedPeople.length; i++) {
      result += photographedPeople[i].getName() +
          (photographedPeople.length - 1 != i ? ", " : "");
    }
    return result;
  }

  String getTagsReadable(KeywordService ks) {
    List<Tag> tags = getTags(ks);
    String result = "";
    for (int i = 0; i < tags.length; i++) {
      result += tags[i].name + (tags.length - 1 != i ? ", " : "");
    }
    return result;
  }

  bool contains(String tagKey) {
    if (tagKey == null || tagKeys.length == 0) return true;
    if (tagKeys == null) return false;
    for (int i = 0; i < tagKeys.length; i++) {
      if (tagKeys[i] == tagKey) return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    "shortDescription": shortDescription,
    "date": date?.toJson(),
    "description": description,
    "annotation": annotation,
    "filename": filename,
    "tags": tagKeys,
    "photographedPeople": photographedPeople?.map((e) => e?.key)?.toList(),
    "location": locationKey,
    "rightOwner": rightOwnerKey,
    "institution": institutionKey,
    "itemType": itemTypeEnumToInt(),
    "itemSubtype": itemSubTypeKey,
    "creator": creatorKey,
    "isPublic": isPublic?.toString(),
  };
}
