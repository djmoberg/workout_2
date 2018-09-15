import 'package:flutter/material.dart';

import 'package:workout_2/workout/Workout.dart';
import 'package:workout_2/exercise/ExerciseWidget.dart';
import 'package:workout_2/stats/Stats.dart';
import 'package:workout_2/settings/Settings.dart';

// import 'package:workout/CompleteWorkout.dart';
// import 'package:workout/Workout.dart';
// import 'package:workout/Stats.dart';
// import 'package:workout/Settings.dart';

class Home extends StatelessWidget {
  Home({Key key, this.update}) : super(key: key);

  final VoidCallback update;

  @override
  Widget build(BuildContext context) {
    return MyHome(
      update: update,
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({Key key, this.update}) : super(key: key);

  final VoidCallback update;

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  _MyHomeState();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> _views = [
      Workout(),
      ExerciseWidget(),
      Stats(),
      Settings(update: widget.update),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Workout 2"),
      ),
      body: _views[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            title: Text(
              'Workout',
              style: TextStyle(color: Colors.red),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group_work,
              color: Colors.red,
            ),
            title: Text(
              'Exercise',
              style: TextStyle(color: Colors.red),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.insert_chart,
              color: Colors.red,
            ),
            title: Text(
              'Stats',
              style: TextStyle(color: Colors.red),
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.red),
            ),
            icon: Icon(
              Icons.settings,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
