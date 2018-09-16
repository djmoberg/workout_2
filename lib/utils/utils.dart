import 'package:workout_2/stats/objects.dart';

String covertTime(int time) {
  Duration d = Duration(milliseconds: time);
  double s = (time / 1000) % 60;
  // double m = (time / (1000 * 60)) % 60;
  if (d.inMilliseconds == 0)
    return "Untimed";
  else
    return "${d.inMinutes} min, ${s.toStringAsFixed(0)} sec";
}

int totalTime(List<dynamic> list) {
  int total = 0;
  list.forEach((value) {
    total = total + value.time;
  });
  return total;
}

int statTotalTime(List<dynamic> list) {
  int total = 0;
  list.forEach((value) {
    total = total + (value.endTime - value.startTime);
  });
  return total;
}

String totalTimeString(List<dynamic> list) {
  return covertTime(totalTime(list));
}

String statTotalTimeString(List<dynamic> list) {
  return covertTime(statTotalTime(list));
}

String workoutTotalTimeString(List<dynamic> list) {
  int total = 0;
  list.forEach((value) {
    total = total + totalTime(value.objects);
  });
  return covertTime(total);
}

String formatTime(int time) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(time);
  // String h = (dt.hour - 1) < 10 ? "0${(dt.hour - 1)}" : "${(dt.hour - 1)}";
  String m = dt.minute < 10 ? "0${dt.minute}" : "${dt.minute}";
  String s = dt.second < 10 ? "0${dt.second}" : "${dt.second}";

  return "$m:$s";
}

Map<String, dynamic> calculateExerciseStats(List<ExerciseStat> stats) {
  List<ExerciseStat> week = List();
  List<ExerciseStat> month = List();
  List<ExerciseStat> year = List();
  List<ExerciseStat> allTime = List();

  DateTime now = DateTime.now();

  stats.forEach((stat) {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(stat.startTime);
    if (stat.startTime < now.millisecondsSinceEpoch &&
        stat.startTime + Duration(days: 7).inMilliseconds >
            now.millisecondsSinceEpoch) {
      week.add(stat);
    }
    if (dt.month == now.month && dt.year == now.year) {
      month.add(stat);
    }
    if (dt.year == now.year) {
      year.add(stat);
    }
    allTime.add(stat);
  });

  Map<String, dynamic> map = Map();
  map["week"] = week;
  map["month"] = month;
  map["year"] = year;
  map["allTime"] = allTime;
  return map;
}

String getStatDuration(ExerciseStat stat) {
  return covertTime(stat.endTime - stat.startTime);
}

String getStatDate(ExerciseStat stat) {
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(stat.startTime);

  String year = dt.year.toString();
  String month = dt.month < 10 ? "0${dt.month}" : "${dt.month}";
  String day = dt.day < 10 ? "0${dt.day}" : "${dt.day}";

  String hour = dt.hour < 10 ? "0${dt.hour}" : "${dt.hour}";
  String minute = dt.minute < 10 ? "0${dt.minute}" : "${dt.minute}";

  return "$day.$month.$year - $hour:$minute";
}
