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
    if (startDate.compareTo(endDate) == 0)
      return startDate.toString();
    return '${startDate.toString()} bis ${endDate.toString()}';
  }
}