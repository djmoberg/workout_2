import 'package:flutter/material.dart';

import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';
import 'package:workout_2/workout/EditWorkout.dart';
import 'package:workout_2/workout/WorkoutPlay.dart';
import 'package:workout_2/workout/objects.dart';

class WorkoutView extends StatelessWidget {
  WorkoutView({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return MyWorkoutView(
      index: index,
    );
  }
}

class MyWorkoutView extends StatefulWidget {
  MyWorkoutView({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _MyWorkoutViewState createState() => _MyWorkoutViewState();
}

class _MyWorkoutViewState extends State<MyWorkoutView> {
  Workout _workout;
  List<Exercise> _exercises;

  @override
  void initState() {
    super.initState();
    _workout = Store().workouts[widget.index];
  }

  _getTitle() {
    return Text(
        _workout.name + " (" + workoutTotalTimeString(_exercises) + ")");
  }

  _editNavigate() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditWorkout(
                  index: widget.index,
                )));
  }

  @override
  Widget build(BuildContext context) {
    _exercises = Store().getExercisesInWorkout(_workout);

    return Scaffold(
      appBar: AppBar(
        title: _getTitle(),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: () => _editNavigate()),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 70.0),
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          Exercise exercise = _exercises[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(exercise.name),
                  trailing: Text(totalTimeString(exercise.objects)),
                ),
                Divider()
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: workoutTotalTimeString(_exercises) == "Untimed"
            ? null
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkoutPlay(
                              workout: _workout,
                            )));
              },
      ),
    );
  }
}
