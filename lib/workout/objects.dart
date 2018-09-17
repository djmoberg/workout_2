// import 'package:workout_2/exercise/objects.dart';

class Workout {
  String name;
  List<dynamic> exercises;

  Workout({this.name, this.exercises});

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["exercises"] = exercises;
    return map;
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json["name"],
      exercises: json["exercises"],
    );
  }
}
