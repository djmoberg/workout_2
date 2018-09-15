import 'package:flutter/material.dart';
import 'package:workout_2/stats/DetailedStats.dart';

import 'package:workout_2/stats/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<ExerciseStat> exerciseStats = Store().exerciseStats;
    Map<String, dynamic> gStats = calculateExerciseStats(exerciseStats);

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

    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text("Exercises this week:"),
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
                  title: Text("Exercises this month:"),
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
                  title: Text("Exercises this year:"),
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
                  title: Text("Exercises all time:"),
                  subtitle: Text(statTotalTimeString(gStats["allTime"])),
                  trailing: Text(
                    gStats["allTime"].length.toString(),
                    style: Theme.of(context).textTheme.headline,
                  ),
                  onTap: () => _navigate("allTime"),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
