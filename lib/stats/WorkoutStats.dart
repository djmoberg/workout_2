import 'package:flutter/material.dart';
import 'package:workout_2/stats/DetailedStats.dart';

import 'package:workout_2/stats/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';

class WorkoutStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ExerciseStat> workoutStats = Store().workoutStats;
    Map<String, dynamic> gStats = calculateExerciseStats(workoutStats);

    _navigate(String s) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedStats(
                stats: gStats[s],
              ),
        ),
      );
    }

    bool _equal(a, b) {
      return statTotalTimeString(gStats[a]) == statTotalTimeString(gStats[b]);
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Workout stats",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
        Card(
          child: ListTile(
            title: Text("Workouts this week:"),
            subtitle: Text(statTotalTimeString(gStats["week"])),
            trailing: Text(
              gStats["week"].length.toString(),
              style: Theme.of(context).textTheme.headline,
            ),
            onTap: () => _navigate("week"),
          ),
        ),
        !_equal("week", "month")
            ? Card(
                child: ListTile(
                  title: Text("Workouts this month:"),
                  subtitle: Text(statTotalTimeString(gStats["month"])),
                  trailing: Text(
                    gStats["month"].length.toString(),
                    style: Theme.of(context).textTheme.headline,
                  ),
                  onTap: () => _navigate("month"),
                ),
              )
            : SizedBox(),
        !_equal("month", "year")
            ? Card(
                child: ListTile(
                  title: Text("Workouts this year:"),
                  subtitle: Text(statTotalTimeString(gStats["year"])),
                  trailing: Text(
                    gStats["year"].length.toString(),
                    style: Theme.of(context).textTheme.headline,
                  ),
                  onTap: () => _navigate("year"),
                ),
              )
            : SizedBox(),
        !_equal("year", "allTime")
            ? Card(
                child: ListTile(
                  title: Text("Workouts all time:"),
                  subtitle: Text(statTotalTimeString(gStats["allTime"])),
                  trailing: Text(
                    gStats["allTime"].length.toString(),
                    style: Theme.of(context).textTheme.headline,
                  ),
                  onTap: () => _navigate("allTime"),
                ),
              )
            : SizedBox(),
        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Exercise stats",
            style: Theme.of(context).textTheme.headline,
          ),
        ),
      ],
    );
  }
}
