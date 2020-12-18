import 'package:foto_zweig/enums/sorting_typs_enum.dart';
import 'package:foto_zweig/models/item_infos/date.dart';
import 'package:foto_zweig/models/item_infos/location.dart';
import 'package:foto_zweig/models/main_foto.dart';
import 'package:foto_zweig/services/keyword_service.dart';

class SortingService {
  List<SmallFotoItem> list;
  SortingTypsEnum sortingTyp = SortingTypsEnum.DATE;
  bool isDesc = true;

  List<SmallFotoItem> sortList(KeywordService ks,
      {SortingTypsEnum sortingTyp,
      String searchText,
      String placeFiler,
      String von,
      String bis,
      Location locationFilter,
      DateTime vonFilter,
      DateTime bisFilter}) {
    if (searchText == "") searchText = null;
    if (sortingTyp != null) this.sortingTyp = sortingTyp;

    switch (this.sortingTyp) {
      case SortingTypsEnum.DATE:
        list.sort((a, b) =>
            ((a?.date?.startDate?.millisecondsSinceEpoch ?? 0) -
                (b?.date?.startDate?.millisecondsSinceEpoch ?? 0)) *
            (this.isDesc ? 1 : -1));
        break;
      case SortingTypsEnum.ORT:
        if (isDesc) {
          list.sort((a, b) =>
              a
                  ?.getLocation(ks)
                  ?.country
                  ?.compareTo(b?.getLocation(ks)?.country ?? "") ??
              0 * (this.isDesc ? 1 : -1));
        } else {
          list.sort((a, b) =>
              b
                  ?.getLocation(ks)
                  ?.country
                  ?.compareTo(a?.getLocation(ks)?.country ?? "") ??
              0 * (this.isDesc ? 1 : -1));
        }
        break;
      case SortingTypsEnum.DESCRIPTION:
        if (isDesc) {
          list.sort((a, b) =>
              a?.shortDescription?.compareTo(b?.shortDescription ?? "") ??
              0 * (this.isDesc ? 1 : -1));
        } else {
          list.sort((a, b) =>
              b?.shortDescription?.compareTo(a?.shortDescription ?? "") ??
              0 * (this.isDesc ? 1 : -1));
        }
        break;
    }
    List<SmallFotoItem> _tmpList = list.where((element) => element.contains(searchText)).toList();
    if (locationFilter != null)
      _tmpList = list.where((element) => locationFilter.key == element.locationKey).toList();
    if (vonFilter != null) {
      _tmpList = list.where((element) => vonFilter.isBefore(element?.date?.startDate??vonFilter.add(Duration(days: 364)))).toList();
    }
    if (bisFilter != null)
      _tmpList = list.where((element) => bisFilter.isAfter(element?.date?.endDate??bisFilter.subtract(Duration(days: 364)))).toList();
    return _tmpList;
  }

  String getTyp() {
    switch (sortingTyp) {
      case SortingTypsEnum.ORT:
        return "Ort";
      case SortingTypsEnum.DATE:
        return "Datum";
      case SortingTypsEnum.DESCRIPTION:
        return "Kurzbezeichnung";
    }
    return "Datum";
  }
}
