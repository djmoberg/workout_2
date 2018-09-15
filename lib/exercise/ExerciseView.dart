import 'package:flutter/material.dart';
import 'package:workout_2/exercise/EditExercise.dart';
import 'package:workout_2/exercise/ExercisePlay.dart';

import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/utils.dart';

class ExerciseView extends StatelessWidget {
  ExerciseView({Key key, this.exercise}) : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return MyExerciseView(
      exercise: exercise,
    );
  }
}

class MyExerciseView extends StatefulWidget {
  MyExerciseView({Key key, this.exercise}) : super(key: key);

  final Exercise exercise;

  @override
  _MyExerciseViewState createState() => _MyExerciseViewState();
}

class _MyExerciseViewState extends State<MyExerciseView> {
  Exercise _exercise;

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise;
  }

  _getTitle() {
    return Text(_exercise.name +
        " (" +
        totalTimeString(List.from(_exercise.objects)) +
        ")");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _getTitle(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditExercise(
                          exercise: _exercise,
                        ))),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _exercise.objects.length,
        itemBuilder: (context, index) {
          ExerciseObject object = _exercise.objects[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(object.name),
                  trailing: Text(covertTime(object.time)),
                ),
                Divider()
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExercisePlay(
                        exercise: _exercise,
                      )));
        },
      ),
    );
  }
}
