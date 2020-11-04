class Date {
  DateTime startDate;
  DateTime endDate;

  Date.fromJson(json) {
    if (json == null)
      return;
    if (json["startDate"] != null)
      startDate = DateTime.parse(json["startDate"]);
    if (json["endDate"] != null)
      endDate = DateTime.parse(json["endDate"]);
  }

  String getReadableTime() {
    if (isStartAndEndSame())
      return getReadableStartDate();
    return '${getReadableStartDate()} bis ${getReadableEndDate()}';
  }

  bool isStartAndEndSame() {
    if (startDate == null || endDate == null)
      return true;
    return startDate.isAtSameMomentAs(endDate); 
  }

  String getReadableStartDate() {
    if (startDate == null)
      return "";
    return startDate.toString().split(" ")[0];
  }

  String getReadableEndDate() {
    if (endDate == null)
      return "";
    return endDate.toString().split(" ")[0];
  }
}