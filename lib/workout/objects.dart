import 'package:workout_2/exercise/objects.dart';

class Workout {
  String name;
  List<Exercise> exercises;

  Workout({this.name, this.exercises});

  List<dynamic> _exercisesToJson(List<Exercise> exercises) {
    List<dynamic> list = List();
    exercises.forEach((exercise) {
      list.add(exercise.toJson());
    });
    return list;
  }

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["exercises"] = _exercisesToJson(exercises);
    return map;
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    List<Exercise> _exercisesFromJson(List<dynamic> exercises) {
      List<Exercise> list = List();
      exercises.forEach((exerciseJson) {
        list.add(Exercise.fromJson(exerciseJson));
      });
      return list;
    }

    return Workout(
      name: json["name"],
      exercises: _exercisesFromJson(json["exercises"]),
    );
  }
}
