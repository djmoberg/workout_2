import 'package:flutter/material.dart';
import 'package:workout_2/exercise/ExercisePlay.dart';
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/stats/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';
import 'package:workout_2/workout/objects.dart';

class WorkoutPlay extends StatelessWidget {
  WorkoutPlay({Key key, this.workout}) : super(key: key);

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return MyWorkoutPlay(
      workout: workout,
    );
  }
}

class MyWorkoutPlay extends StatefulWidget {
  MyWorkoutPlay({Key key, this.workout}) : super(key: key);

  final Workout workout;

  @override
  _MyWorkoutPlayState createState() => _MyWorkoutPlayState();
}

class _MyWorkoutPlayState extends State<MyWorkoutPlay> {
  List<Exercise> _exercises;
  int _currentIndex = 0;
  int _startTime;
  int _endTime;
  bool _done = false;

  _pushExercisePlay() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExercisePlay(
                  exercise: _exercises[_currentIndex],
                )));
    if (_currentIndex == _exercises.length - 1) {
      setState(() {
        _done = true;
        _endTime = DateTime.now().millisecondsSinceEpoch;
      });
      Store().addWorkoutStat(ExerciseStat(
        name: widget.workout.name,
        startTime: _startTime,
        endTime: _endTime,
      ));
    } else {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    _exercises = Store().getExercisesInWorkout(widget.workout);

    return Scaffold(
      body: !_done
          ? ListView.builder(
              padding: EdgeInsets.only(top: 64.0, bottom: 70.0),
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                Exercise exercise = _exercises[index];

                if (index == _currentIndex)
                  return Card(
                    color: Colors.blue,
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Text(
                            "Up Next: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 50.0,
                            ),
                          ),
                          Text(
                            exercise.name,
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 60.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                else
                  return Card(
                    child: ListTile(
                      enabled: _currentIndex < index,
                      title: Column(
                        children: <Widget>[
                          Text(exercise.name),
                        ],
                      ),
                    ),
                  );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Done!",
                    style: Theme.of(context).textTheme.display3,
                  ),
                  Text(
                    "Total Time",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(
                    covertTime(_endTime - _startTime),
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(!_done
            ? _currentIndex == 0 ? Icons.play_circle_outline : Icons.skip_next
            : Icons.arrow_back),
        label:
            Text(!_done ? _currentIndex == 0 ? "Start" : "Continue" : "Back"),
        onPressed:
            !_done ? () => _pushExercisePlay() : () => Navigator.pop(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
