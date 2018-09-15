class ExerciseStat {
  final String name;
  final int startTime;
  int endTime;

  ExerciseStat({this.name, this.startTime, this.endTime});

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["startTime"] = startTime;
    map["endTime"] = endTime;
    return map;
  }

  factory ExerciseStat.fromJson(Map<String, dynamic> json) {
    return ExerciseStat(
        name: json["name"],
        startTime: json["startTime"],
        endTime: json["endTime"]);
  }
}
