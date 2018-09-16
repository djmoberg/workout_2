import 'package:flutter/material.dart';
import 'package:flutter_list_drag_and_drop/drag_and_drop_list.dart';
import 'package:workout_2/components/DismissibleContainer.dart';
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';
import 'package:workout_2/workout/AddExerciseToWorkout.dart';
import 'package:workout_2/workout/objects.dart';

class EditWorkout extends StatelessWidget {
  EditWorkout({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return MyEditWorkout(index: index);
  }
}

class MyEditWorkout extends StatefulWidget {
  MyEditWorkout({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _MyEditWorkoutState createState() => _MyEditWorkoutState();
}

class _MyEditWorkoutState extends State<MyEditWorkout> {
  Workout _workout;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _workout = Store().workouts[widget.index];
    _controller = TextEditingController(text: _workout.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Workout"),
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
                  _workout.name = value;
                  await Store().updateWorkout(_workout, widget.index);
                });
              },
            ),
          ),
          // ListTile(
          //   title: Text("Auto Continue?"),
          //   trailing: Switch(
          //     value: true,
          //     onChanged: (value) {},
          //   ),
          // ),
          Expanded(
            child: DragAndDropList(
              _workout.exercises,
              itemBuilder: (context, item) {
                return SizedBox(
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Dismissible(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(totalTimeString(item.objects)),
                        trailing: Icon(Icons.drag_handle),
                      ),
                      key: Key(item.id),
                      background: DismissibleContainer(),
                      onDismissed: (direction) {
                        _workout.exercises.remove(item);
                        Store().updateWorkout(_workout, widget.index);
                      },
                    ),
                  ),
                );
              },
              onDragFinish: (before, after) {
                Exercise data = _workout.exercises[before];
                _workout.exercises.removeAt(before);
                _workout.exercises.insert(after, data);
                Store().updateWorkout(_workout, widget.index);
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
            Exercise exercise = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddExerciseToWorkout()));
            if (exercise != null) {
              _workout.exercises.add(exercise);
              Store().updateWorkout(_workout, widget.index);
            }
          }),
    );
  }
}
