class Exercises {
  final List<Exercise> execises;

  Exercises({this.execises});

  factory Exercises.fromJson(List<Exercise> json) {
    return Exercises(
      execises: List<Exercise>.from(json),
    );
  }
}

class Exercise {
  String id;
  String name;
  List<ExerciseObject> objects;

  Exercise({this.id, this.name, this.objects});

  void setId(String id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setObjects(var objects) {
    this.objects = objects;
  }

  List<dynamic> _objectsToJson(List<ExerciseObject> objects) {
    List<dynamic> list = List();
    objects.forEach((object) {
      list.add(object.toJson());
    });
    return list;
  }

  Map toJson() {
    Map map = new Map();
    map["id"] = id;
    map["name"] = name;
    map["objects"] = _objectsToJson(objects);
    return map;
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    List<ExerciseObject> _objectsFromJson(List<dynamic> objects) {
      List<ExerciseObject> list = List();
      objects.forEach((objectJson) {
        list.add(ExerciseObject.fromJson(objectJson));
      });
      return list;
    }

    return Exercise(
      id: json["id"],
      name: json["name"],
      objects: _objectsFromJson(json["objects"]),
    );
  }
}

class ExerciseObject {
  String name;
  int time;

  ExerciseObject({this.name, this.time});

  Map toJson() {
    Map map = new Map();
    map["name"] = name;
    map["time"] = time;
    return map;
  }

  factory ExerciseObject.fromJson(Map<String, dynamic> json) {
    return ExerciseObject(
      name: json["name"],
      time: json["time"],
    );
  }
}
