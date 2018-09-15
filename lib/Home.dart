import 'package:flutter/material.dart';

import 'package:workout_2/workout/WorkoutWidget.dart';
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
  List<Widget> _views = [
    WorkoutWidget(),
    ExerciseWidget(),
    Stats(),
  ];

  int _index = 1;

  _onTap(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Settings(update: widget.update),
      ),
      appBar: AppBar(title: Text("Workout 2")),
      body: _views[_index],
      bottomNavigationBar: BottomNavigationBar(
        // type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Workout'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            title: Text('Exercise'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            title: Text('Stats'),
          ),
        ],
      ),
    );
  }
}
