import 'package:foto_zweig/enums/sorting_typs_enum.dart';
import 'package:foto_zweig/models/main_foto.dart';

class SortingService {
  List<SmallFotoItem> list;
  SortingTypsEnum sortingTyp = SortingTypsEnum.DATE;
  bool isDesc = true;
  

  List<SmallFotoItem> sortFilterList(
    {
      SortingTypsEnum sortingTyp,
      bool isDesc = true,
      String searchText,
      String placeFiler,
      String von,
      String bis
    }) {
      if (sortingTyp != null)
        this.sortingTyp = sortingTyp;
      if (isDesc != null)
        this.isDesc = isDesc;

      switch (this.sortingTyp) {
        case SortingTypsEnum.DATE:
            list.sort((a, b) => ((a?.date?.startDate?.millisecondsSinceEpoch??0) - (b?.date?.startDate?.millisecondsSinceEpoch ?? 0)) * (this.isDesc?1:-1));
          break;
        case SortingTypsEnum.ORT:
            list.sort((a, b) => a?.location?.country?.compareTo(b?.location?.country ?? "")??0 * (this.isDesc?1:-1));
          break;
        case SortingTypsEnum.DESCRIPTION:
            list.sort((a, b) => a?.shortDescription?.compareTo(b?.shortDescription??"")??0 * (this.isDesc?1:-1));
          break;
      }
      return list.where((element) => element.contains(searchText)).toList();
      return list.where((element) => element.location.country.toLowerCase().trim().contains(placeFiler.toLowerCase().trim()))
        .toList();
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