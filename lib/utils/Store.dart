import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:workout_2/exercise/objects.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_2/stats/objects.dart';
import 'package:workout_2/workout/objects.dart';

class Store {
  static final Store _singleton = new Store._internal();
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  factory Store() {
    return _singleton;
  }

  Store._internal();

  String theme = "light";
  List<Exercise> exercises;
  List<ExerciseStat> exerciseStats;
  List<ExerciseStat> workoutStats;
  List<Workout> workouts;

  Future init() async {
    theme = await _getTheme();
    exercises = await _getExercises();
    exerciseStats = await _getExerciseStats();
    workoutStats = await _getWorkoutStats();
    workouts = await _getWorkouts();
  }

  static Future<String> _getTheme() async {
    String theme = await _prefs.then((prefs) {
      return (prefs.getString("theme") ?? "light");
    });
    return theme;
  }

  Future setTheme(value) async {
    await _prefs.then((prefs) {
      prefs.setString("theme", value);
    });
    theme = value;
  }

  // exercises
  static Future<List<Exercise>> _getExercises() async {
    // ExerciseObject defaultObject = ExerciseObject(name: "Test", time: 1000);
    // List<ExerciseObject> defaultObjectList = List();
    // defaultObjectList.add(defaultObject);
    // Exercise defaultExercise =
    //     Exercise(name: "Test Exercise", objects: defaultObjectList);
    // List<Exercise> defaultExerciseList = List();
    // defaultExerciseList.add(defaultExercise);
    // defaultExerciseList.add(defaultExercise);

    List<String> exercisesString = await _prefs.then((prefs) {
      return (prefs.getStringList("exercises") ?? null);
    });

    if (exercisesString == null) {
      return List();
    } else {
      List<Exercise> list = List();

      exercisesString.forEach((value) async {
        Exercise exercise = await _getExercise(value);
        if (exercise != null) list.add(exercise);
      });

      return list;
    }
  }

  static Future<Exercise> _getExercise(String id) async {
    String exerciseString = await _prefs.then((prefs) {
      return (prefs.getString(id) ?? null);
    });
    return exerciseString == null
        ? null
        : Exercise.fromJson(json.decode(exerciseString));
  }

  Future addExercise(Exercise value) async {
    var uuid = new Uuid();
    String id = uuid.v1();

    value.setId(id);
    exercises.add(value);

    await _prefs.then((prefs) {
      List<String> list = prefs.getStringList("exercises") ?? List();
      list.add(id);
      prefs.setStringList("exercises", list);
      prefs.setString(id, json.encode(value.toJson()));
    });
  }

  Future addExerciseWithId(Exercise value) async {
    exercises.add(value);

    await _prefs.then((prefs) {
      List<String> list = prefs.getStringList("exercises") ?? List();
      list.add(value.id);
      prefs.setStringList("exercises", list);
      prefs.setString(value.id, json.encode(value.toJson()));
    });
  }

  Future editExercise(Exercise editedExercise) async {
    await _prefs.then((prefs) {
      prefs.setString(editedExercise.id, json.encode(editedExercise.toJson()));
    });
  }

  Future deleteExercise(String id) async {
    await _prefs.then((prefs) {
      exercises.removeWhere((e) => e.id == id);
      List<String> list = prefs.getStringList("exercises") ?? List();
      list.remove(id);
      prefs.setStringList("exercises", list);
      prefs.remove(id);
    });
  }

  // Future setExercises(value) async {
  //   await _prefs.then((prefs) {
  //     prefs.setString("exercises", value);
  //   });
  //   exercises = Exercises.fromJson(json.decode(value)).execises;
  // }

  // Future addExercise(Exercise value) async {
  //   exercises.add(value);

  //   // await _prefs.then((prefs) {
  //   //   prefs.setString("exercises", json.encode(exercises));
  //   // });

  //   // exercises = Exercises.fromJson(json.decode(value)).execises;
  // }

  // /exercises

  // exerciseStats
  static Future<List<ExerciseStat>> _getExerciseStats() async {
    List<String> exerciseStatsString = await _prefs.then((prefs) {
      return (prefs.getStringList("exerciseStats") ?? null);
    });

    if (exerciseStatsString == null) {
      return List();
    } else {
      List<ExerciseStat> list = List();

      exerciseStatsString.forEach((value) async {
        ExerciseStat exerciseStat = ExerciseStat.fromJson(json.decode(value));
        if (exerciseStat != null) list.add(exerciseStat);
      });

      return list;
    }
  }

  Future addExerciseStat(ExerciseStat value) async {
    exerciseStats.add(value);

    await _prefs.then((prefs) {
      List<String> list = prefs.getStringList("exerciseStats") ?? List();
      list.add(json.encode(value.toJson()));
      prefs.setStringList("exerciseStats", list);
    });
  }
  // / exerciseStats

  // workoutStats
  static Future<List<ExerciseStat>> _getWorkoutStats() async {
    List<String> workoutStatsString = await _prefs.then((prefs) {
      return (prefs.getStringList("workoutStats") ?? null);
    });

    if (workoutStatsString == null) {
      return List();
    } else {
      List<ExerciseStat> list = List();

      workoutStatsString.forEach((value) async {
        ExerciseStat exerciseStat = ExerciseStat.fromJson(json.decode(value));
        if (exerciseStat != null) list.add(exerciseStat);
      });

      return list;
    }
  }

  Future addWorkoutStat(ExerciseStat value) async {
    workoutStats.add(value);

    await _prefs.then((prefs) {
      List<String> list = prefs.getStringList("workoutStats") ?? List();
      list.add(json.encode(value.toJson()));
      prefs.setStringList("workoutStats", list);
    });
  }
  // / workoutStats

  // workouts
  static Future<List<Workout>> _getWorkouts() async {
    List<String> workoutsString = await _prefs.then((prefs) {
      return (prefs.getStringList("workouts") ?? null);
    });

    if (workoutsString == null) {
      return List();
    } else {
      List<Workout> list = List();

      workoutsString.forEach((value) async {
        Workout workout = Workout.fromJson(json.decode(value));
        if (workout != null) list.add(workout);
      });

      return list;
    }
  }

  Future addWorkout(Workout value) async {
    workouts.add(value);

    await _prefs.then((prefs) {
      List<String> list = prefs.getStringList("workouts") ?? List();
      list.add(json.encode(value.toJson()));
      prefs.setStringList("workouts", list);
    });
  }

  Future updateWorkout(Workout editedWorkout, int index) async {
    workouts.removeAt(index);
    workouts.insert(index, editedWorkout);
    await _prefs.then((prefs) {
      List<String> list = prefs.getStringList("workouts") ?? List();
      list.removeAt(index);
      list.insert(index, json.encode(editedWorkout.toJson()));
      prefs.setStringList("workouts", list);
    });
  }

  Future deleteWorkout(int index) async {
    workouts.removeAt(index);
    await _prefs.then((prefs) {
      List<String> list = prefs.getStringList("workouts") ?? List();
      list.removeAt(index);
      prefs.setStringList("workouts", list);
    });
  }

  List<Exercise> getExercisesInWorkout(Workout workout) {
    List<Exercise> list = List();

    workout.exercises.forEach((id) {
      list.add(exercises.firstWhere((exercise) => exercise.id == id));
    });

    return list;
  }
  // / workouts

  Future clear() async {
    await _prefs.then((prefs) async {
      await prefs.clear();
      theme = "light";
      exercises = List();
      exerciseStats = List();
      workoutStats = List();
      workouts = List();
    });
  }

  //Non persistence

}
