import 'package:flutter/material.dart';
import 'package:workout_2/components/DismissibleContainer.dart';
import 'package:workout_2/exercise/ExerciseView.dart';

import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';

import 'package:workout_2/exercise/EditExercise.dart';

class ExerciseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyExerciseWidget();
  }
}

class MyExerciseWidget extends StatefulWidget {
  @override
  _MyExerciseWidgetState createState() => _MyExerciseWidgetState();
}

class _MyExerciseWidgetState extends State<MyExerciseWidget> {
  Exercise _deletedExercise;

  @override
  Widget build(BuildContext context) {
    List<Exercise> exercises = Store().exercises;

    return Scaffold(
      body: exercises == null || exercises.length == 0
          ? Center(child: Text("You have no exercises"))
          : ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                Exercise exercise = exercises[index];

                return Dismissible(
                  child: ListTile(
                    title: Text(exercise.name),
                    subtitle: Text(totalTimeString(exercise.objects)),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExerciseView(
                                  exercise: exercise,
                                ))),
                  ),
                  key: Key(exercise.id),
                  background: DismissibleContainer(),
                  onDismissed: (direction) {
                    setState(() {
                      _deletedExercise = exercise;
                    });
                    Store().deleteExercise(exercise.id);
                    setState(() {});
                  },
                );
              },
            ),
      bottomNavigationBar: _deletedExercise != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: () async {
                    await Store().addExercise(_deletedExercise);
                    setState(() {
                      _deletedExercise = null;
                    });
                  },
                  icon: Icon(Icons.undo),
                )
                // _resetButton(),
              ],
            )
          : SizedBox(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          List<ExerciseObject> objetcs = List();
          Exercise exercise = Exercise(name: "", objects: objetcs);
          Store().addExercise(exercise);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditExercise(
                        exercise: exercise,
                      )));
        },
        icon: Icon(Icons.add),
        label: Text("New Exercise"),
      ),
    );
  }
}
