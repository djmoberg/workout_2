import 'package:flutter/material.dart';

import 'package:workout_2/stats/objects.dart';
import 'package:workout_2/utils/utils.dart';

class DetailedStats extends StatelessWidget {
  DetailedStats({Key key, this.stats}) : super(key: key);

  final List<ExerciseStat> stats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: stats.length,
        itemBuilder: (context, index) {
          ExerciseStat stat = stats[index];

          return Column(
            children: <Widget>[
              ListTile(
                title: Text(stat.name),
                subtitle: Text(getStatDate(stat)),
                trailing: Text(getStatDuration(stat)),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }
}
