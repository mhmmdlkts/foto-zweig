class Log implements Comparable{
  DateTime time;
  String user;
  var val;

  Log.fromJson(json) {
    time = DateTime.parse(json["time"]).toLocal();
    user = json["user"];
    val = json["val"];
  }

  @override
  int compareTo(other) => other?.time?.compareTo(time??0)??0;
}