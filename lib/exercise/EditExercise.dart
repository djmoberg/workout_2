import 'package:flutter/material.dart';
import 'package:workout_2/components/DismissibleContainer.dart';
import 'package:workout_2/exercise/EditExerciseObject.dart';

import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/utils.dart';

import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';

class EditExercise extends StatelessWidget {
  EditExercise({Key key, this.exercise}) : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return MyEditExercise(exercise: exercise);
  }
}

class MyEditExercise extends StatefulWidget {
  MyEditExercise({Key key, this.exercise}) : super(key: key);

  final Exercise exercise;

  @override
  _MyEditExerciseState createState() => _MyEditExerciseState();
}

class _MyEditExerciseState extends State<MyEditExercise> {
  _MyEditExerciseState();

  Exercise _exercise;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise;
    _controller = TextEditingController(text: _exercise.name);
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
        title: Text("Edit Exercise"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextField(
              controller: _controller,
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
                    child: Dismissible(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(covertTime(item.time)),
                        trailing: Icon(Icons.drag_handle),
                        onTap: () => _editNavigate(item),
                      ),
                      key: Key(item.name),
                      background: DismissibleContainer(),
                      onDismissed: (direction) {
                        _exercise.objects.remove(item);
                        Store().editExercise(_exercise);
                      },
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            _exercise.objects.add(ExerciseObject(name: "", time: 5000));
            await Store().editExercise(_exercise);
            _editNavigate(_exercise.objects.last);
          }),
    );
  }
}
