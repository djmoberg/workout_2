import 'package:flutter/material.dart';
import 'package:workout_2/exercise/EditExerciseObject.dart';

import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/utils.dart';

import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';

class AddExercise extends StatelessWidget {
  AddExercise();

  @override
  Widget build(BuildContext context) {
    return MyAddExercise();
  }
}

class MyAddExercise extends StatefulWidget {
  MyAddExercise();

  @override
  _MyAddExerciseState createState() => _MyAddExerciseState();
}

class _MyAddExerciseState extends State<MyAddExercise> {
  _MyAddExerciseState();

  List<ExerciseObject> _objetcs = List();
  Exercise _exercise;

  @override
  void initState() {
    super.initState();
    _exercise = Exercise(name: "", objects: _objetcs);
    Store().addExercise(_exercise);
  }

  _editNavigate(item) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditExerciseObject(
                  exercise: _exercise,
                  index: _exercise.objects.indexOf(item),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Exercise"),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.check),
          //   onPressed: _name == null ? null : () {},
          // )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextField(
              decoration: InputDecoration(labelText: "Name"),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() async {
                  _exercise.setName(value);
                  await Store().editExercise(_exercise);
                });
              },
            ),
          ),
          Expanded(
            child: DragAndDropList(
              _exercise.objects,
              itemBuilder: (context, item) {
                return SizedBox(
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: Text(covertTime(item.time)),
                      trailing: Icon(Icons.drag_handle),
                      onTap: () => _editNavigate(item),
                    ),
                  ),
                );
              },
              onDragFinish: (before, after) {
                ExerciseObject data = _exercise.objects[before];
                _exercise.objects.removeAt(before);
                _exercise.objects.insert(after, data);
                Store().editExercise(_exercise);
              },
              canBeDraggedTo: (oldIndex, newIndex) => true,
              dragElevation: 8.0,
            ),
          )
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: _exercise.objects.length,
          //     itemBuilder: (context, index) {
          //       ExerciseObject object = _exercise.objects[index];

          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //         child: Column(
          //           children: <Widget>[
          //             ListTile(
          //               // leading: Icon(Icons.sentiment_very_satisfied),
          //               title: Text(object.name),
          //               trailing: Text(covertTime(object.time)),
          //               onTap: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => EditExerciseObject(
          //                               exercise: _exercise,
          //                               index: index,
          //                             )));
          //               },
          //             ),
          //             Divider()
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            _exercise.objects.add(ExerciseObject(name: "", time: 5000));
            int index = _exercise.objects.length - 1;
            await Store().editExercise(_exercise);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditExerciseObject(
                          exercise: _exercise,
                          index: index,
                        )));
          }),
    );
  }
}
