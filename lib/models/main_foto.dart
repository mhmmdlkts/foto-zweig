import 'dart:convert';

import 'package:foto_zweig/models/item_infos/date.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/item_type.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';

class SmallFotoItem implements Comparable {
  String key;
  String shortDescription;
  Date date;
  String description;
  String annotation;
  String filename;
  String thumbnailPath;
  String path;
  List<String> tags = List();
  List<People> photographedPeople = List();
  Location location;
  RightOwner rightOwner;
  Institution institution;
  ItemType itemType;
  ItemType itemSubType;
  People creator;
  bool isPublic;

  SmallFotoItem({this.shortDescription, this.itemType});

  SmallFotoItem.fromJson(json, {locationsJson, rightOwnerJson, institutionJson, itemSubTypeJson, peopleJson}) {
    if (json == null) json = Map();
    if (locationsJson == null) locationsJson = Map();
    if (rightOwnerJson == null) rightOwnerJson = Map();
    if (institutionJson == null) institutionJson = Map();
    if (itemSubTypeJson == null) itemSubTypeJson = Map();
    if (peopleJson == null) peopleJson = Map();
    key = json["id"];
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
      for (int i = 0; i < json["tags"].length; i++) tags.add(json["tags"][i]);
    }
    if (json["photographedPeople"] != null) {
      json["photographedPeople"].values.forEach((element) {
        photographedPeople.add(People.fromJson(peopleJson[element], element));
      });
    }

    location = Location.fromJson(locationsJson[json["location"]], json["location"]);
    rightOwner = RightOwner.fromJson(rightOwnerJson[json["rightOwner"]], json["rightOwner"]);
    institution = Institution.fromJson(institutionJson[json["institution"]], json["institution"]);
    itemType = ItemType.fromJson(json["itemType"], "key");
    itemSubType = ItemType.fromJson(itemSubTypeJson[json["itemSubType"]], json["itemSubType"]);
    creator = People.fromJson(peopleJson[json["creator"]], json["creator"]);
    isPublic = json["isPublic"] == 'true';
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
      result += tags[i].toString() + (tags.length - 1 != i ? ", " : "");
    }
    return result;
  }

  bool contains(String val) {
    if (val == null || tags.length == 0) return true;
    if (tags == null) return false;
    for (int i = 0; i < tags.length; i++) {
      if (tags[i].toLowerCase().contains(val.toLowerCase())) return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    "id": key,
    "shortDescription": shortDescription,
    "date": date?.toJson(),
    "description": description,
    "annotation": annotation,
    "filename": filename,
    "thumbnailPath": thumbnailPath,
    "path": path,
    "tags": tags,
    "photographedPeople": photographedPeople.map((e) => e?.toJson())?.toList(),
    "location": location?.toJson(),
    "rightOwner": rightOwner?.toJson(),
    "institution": institution?.toJson(),
    "itemType": itemType?.toJson(),
    "itemSubType": itemSubType?.toJson(),
    "creator": creator?.toJson(),
    "isPublic": isPublic?.toString(),
  };
}
