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
  List<Tag> tags = List();
  List<People> photographedPeople = List();
  Location location;
  RightOwner rightOwner;
  Institution institution;
  ItemTypeEnum itemType;
  ItemSubtype itemSubType;
  People creator;
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
        print(element);
        tags.add(Tag.fromJson(ks.tagJson[element], element));
      });
    }
    if (json["photographedPeople"] != null) {
      json["photographedPeople"].forEach((element) {
        photographedPeople.add(People.fromJson(ks.peopleJson[element], element));
      });
    }

    location = Location.fromJson(ks.locationsJson[json["location"]], json["location"]);
    rightOwner = RightOwner.fromJson(ks.rightOwnerJson[json["rightOwner"]], json["rightOwner"]);
    institution = Institution.fromJson(ks.institutionJson[json["institution"]], json["institution"]);
    itemType = intToItemTypeEnum(json["itemType"]);
    itemSubType = ItemSubtype.fromJson(ks.itemSubtypeJson[json["itemSubtype"]], json["itemSubtype"]);
    creator = People.fromJson(ks.peopleJson[json["creator"]], json["creator"]);
    isPublic = json["isPublic"] == 'true';
  }

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
  int compareTo(other) {
    final int diff = (date?.startDate?.millisecondsSinceEpoch ?? 0) -
        (other?.date?.startDate?.millisecondsSinceEpoch ?? 0);
    if (diff == 0) return other.location.country.compareTo(location.country);
    return diff;
  }

  String getReadablePersons() {
    String result = "";
    for (int i = 0; i < photographedPeople.length; i++) {
      result += photographedPeople[i].getName() +
          (photographedPeople.length - 1 != i ? ", " : "");
    }
    return result;
  }

  String getTags() {
    String result = "";
    for (int i = 0; i < tags.length; i++) {
      result += tags[i].name + (tags.length - 1 != i ? ", " : "");
    }
    return result;
  }

  bool contains(String val) {
    if (val == null || tags.length == 0) return true;
    if (tags == null) return false;
    for (int i = 0; i < tags.length; i++) {
      if (tags[i].name.toLowerCase().contains(val.toLowerCase())) return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    "shortDescription": shortDescription,
    "date": date?.toJson(),
    "description": description,
    "annotation": annotation,
    "filename": filename,
    "tags": tags.map((e) => e.key).toList(),
    "photographedPeople": photographedPeople?.map((e) => e?.key)?.toList(),
    "location": location?.key,
    "rightOwner": rightOwner?.key,
    "institution": institution?.key,
    "itemType": itemTypeEnumToInt(),
    "itemSubtype": itemSubType?.key,
    "creator": creator?.key,
    "isPublic": isPublic?.toString(),
  };
}
