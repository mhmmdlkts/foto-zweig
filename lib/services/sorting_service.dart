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
      return list;
      return list.where((element) => element.location.country.toLowerCase().trim().contains(placeFiler.toLowerCase().trim()))
        .toList();
    }

    String getTyp() {
      switch (sortingTyp) {
        case SortingTypsEnum.ORT:
        return "ORT";
        case SortingTypsEnum.DATE:
          return "DATE";
        case SortingTypsEnum.DESCRIPTION:
          return "DESCRIPTION";
      }
      return "DATE";
    }


}