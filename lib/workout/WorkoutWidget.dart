import 'package:flutter/material.dart';
import 'package:workout_2/components/DismissibleContainer.dart';
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';
import 'package:workout_2/workout/EditWorkout.dart';
import 'package:workout_2/workout/WorkoutView.dart';
import 'package:workout_2/workout/objects.dart';

class WorkoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyWorkoutWidget();
  }
}

class MyWorkoutWidget extends StatefulWidget {
  @override
  _MyWorkoutWidgetState createState() => _MyWorkoutWidgetState();
}

class _MyWorkoutWidgetState extends State<MyWorkoutWidget> {
  _editNavigate(index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditWorkout(
                  index: index,
                )));
  }

  _viewNavigate(index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutView(
                  index: index,
                )));
  }

  _delete(index) async {
    await Store().deleteWorkout(index);
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Workout> workouts = Store().workouts;

    return Scaffold(
      body: workouts == null || workouts.length == 0
          ? Center(child: Text("You have no workouts"))
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 70.0),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                Workout workout = workouts[index];
                List<Exercise> exercises =
                    Store().getExercisesInWorkout(workout);

                return ListTile(
                  title: Text(workout.name),
                  subtitle: Text(workoutTotalTimeString(exercises)),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () => _viewNavigate(index),
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text(
                                  "This will permanently delete the workout"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () => _delete(index),
                                )
                              ],
                            ));
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          List<String> exercises = List();
          Workout workout = Workout(name: "", exercises: exercises);
          Store().addWorkout(workout);

          _editNavigate(workouts.length - 1);
        },
        icon: Icon(Icons.add),
        label: Text("New Workout"),
      ),
    );
  }
}
