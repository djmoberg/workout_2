import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:workout_2/exercise/objects.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_2/stats/objects.dart';

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

  Future init() async {
    theme = await _getTheme();
    exercises = await _getExercises();
    exerciseStats = await _getExerciseStats();
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

  //Non persistence

}