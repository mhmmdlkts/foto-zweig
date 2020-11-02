import 'package:foto_zweig/models/item_infos/date.dart';
import 'package:foto_zweig/models/item_infos/institution.dart';
import 'package:foto_zweig/models/item_infos/item_type.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/item_infos/people.dart';
import 'package:foto_zweig/models/item_infos/right_owner.dart';

class SmallFotoItem implements Comparable {

  int id;
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


  SmallFotoItem(this.shortDescription, this.thumbnailPath);

  SmallFotoItem.fromJson(json) {
    id = json["id"];
    shortDescription = json["shortDescription"];
    //date = Date.fromJson(["date"]);
    description = json["description"];
    annotation = json["annotation"];
    filename = json["filename"];
    thumbnailPath = json["thumbnailPath"];
    path = json["path"];
    if (json["tags"] != null) {
      for (int i = 0; i < json["tags"].length; i++)
        tags.add(json["tags"][i]);
    }
    if (json["photographedPeople"] != null) {
      for (int i = 0; i < json["photographedPeople"].length; i++)
        photographedPeople.add(People.fromJson(json["photographedPeople"][i]));
    }
    location = Location.fromJson(json["location"]);
    rightOwner = RightOwner.fromJson(json["rightOwner"]);
    institution = Institution.fromJson(json["institution"]);
    itemType = ItemType.fromJson(json["itemType"]);
    itemSubType = ItemType.fromJson(json["itemSubType"]);
    creator = People.fromJson(json["creator"]);
    isPublic = json["isPublic"] == 'true';
  }

  @override
  int compareTo(other) =>(date?.endDate?.millisecondsSinceEpoch??0) - (other?.date?.endDate?.millisecondsSinceEpoch ?? 0);
}