import 'package:flutter/material.dart';
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';

class AddExerciseToWorkout extends StatelessWidget {
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

                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(totalTimeString(exercise.objects)),
                  onTap: () {
                    Navigator.pop(context, exercise);
                  },
                );
              },
            ),
    );
  }
}
