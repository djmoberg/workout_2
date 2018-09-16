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

  @override
  Widget build(BuildContext context) {
    List<Workout> workouts = Store().workouts;

    return Scaffold(
      body: workouts == null || workouts.length == 0
          ? Center(child: Text("You have no workouts"))
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                Workout workout = workouts[index];

                return Dismissible(
                  child: ListTile(
                    title: Text(workout.name),
                    subtitle: Text(workoutTotalTimeString(workout.exercises)),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () => _viewNavigate(index),
                  ),
                  key: Key(index.toString()),
                  background: DismissibleContainer(),
                  onDismissed: (direction) {
                    Store().deleteWorkout(index);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          List<Exercise> exercises = List();
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
