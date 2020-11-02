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
}