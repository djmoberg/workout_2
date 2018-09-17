import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/stats/objects.dart';

import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/workout/objects.dart';

const backend = "https://workout-2-backend.herokuapp.com";
const backend2 = "http://192.168.38.110:3000";

Future<bool> putStore() async {
  var store = {
    "theme": Store().theme,
    "exercises": Store().exercises,
    "exerciseStats": Store().exerciseStats,
    "workoutStats": Store().workoutStats,
    "workouts": Store().workouts,
  };

  http.Response response = await http.put(
    backend + "/workout/store",
    headers: {"Content-Type": "application/json"},
    body: json.encode(store),
  );

  if (response.statusCode == 200)
    return true;
  else
    return false;
}

Future<bool> getStore() async {
  http.Response response = await http.get(
    backend + "/workout/store",
  );

  if (response.statusCode == 200) {
    await Store().clear();
    var data = json.decode(response.body);
    Store().setTheme(data["theme"]);
    await addExercises(data["exercises"]);
    await addExerciseStats(data["exerciseStats"]);
    await addWorkoutStats(data["workoutStats"]);
    await addWorkouts(data["workouts"]);
    return true;
  } else {
    return false;
  }
}

addExercises(var exercises) async {
  await exercises.forEach((exercise) async {
    await Store().addExerciseWithId(Exercise.fromJson(exercise));
  });
}

addExerciseStats(var exerciseStats) async {
  await exerciseStats.forEach((stat) async {
    await Store().addExerciseStat(ExerciseStat.fromJson(stat));
  });
}

addWorkoutStats(var workoutStats) async {
  await workoutStats.forEach((stat) async {
    await Store().addWorkoutStat(ExerciseStat.fromJson(stat));
  });
}

addWorkouts(var workouts) async {
  await workouts.forEach((workout) async {
    await Store().addWorkout(Workout.fromJson(workout));
  });
}
