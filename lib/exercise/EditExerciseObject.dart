import 'package:flutter/material.dart';
import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/utils/Store.dart';

import 'package:numberpicker/numberpicker.dart';

class EditExerciseObject extends StatelessWidget {
  EditExerciseObject({Key key, this.exercise, this.index}) : super(key: key);

  final Exercise exercise;
  final int index;

  @override
  Widget build(BuildContext context) {
    return MyEditExerciseObject(exercise: exercise, index: index);
  }
}

class MyEditExerciseObject extends StatefulWidget {
  MyEditExerciseObject({Key key, this.exercise, this.index}) : super(key: key);

  final Exercise exercise;
  final int index;

  @override
  _MyEditExerciseObjectState createState() => _MyEditExerciseObjectState();
}

class _MyEditExerciseObjectState extends State<MyEditExerciseObject> {
  Exercise _exercise;
  ExerciseObject _exerciseObject;

  TextEditingController _controller;
  bool _timed;
  int _minutes;
  int _seconds;
  int _index;

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise;
    _index = widget.index;
    _exerciseObject = _exercise.objects[_index];

    _controller = TextEditingController(text: _exerciseObject.name);
    _timed = _exerciseObject.time != 0;
    _minutes = Duration(milliseconds: _exerciseObject.time).inMinutes;
    _seconds = ((_exerciseObject.time / 1000) % 60).round();
  }

  _setTime() {
    _exerciseObject.time =
        Duration(minutes: _minutes, seconds: _seconds).inMilliseconds;
    _exercise.objects.removeAt(_index);
    _exercise.objects.insert(_index, _exerciseObject);
    Store().editExercise(_exercise);
  }

  Widget _timePicker() {
    if (!_timed)
      return SizedBox(
        height: 0.0,
      );
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Minutes"),
            Text("Seconds"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NumberPicker.integer(
                initialValue: _minutes,
                minValue: 0,
                maxValue: 59,
                onChanged: (value) {
                  setState(() {
                    _minutes = !_timed ? 0 : value;
                  });
                  _setTime();
                }),
            Text(
              ":",
              style: Theme.of(context).textTheme.display1,
            ),
            NumberPicker.integer(
                initialValue: _seconds,
                minValue: 0,
                maxValue: 59,
                onChanged: (value) {
                  setState(() {
                    _seconds = !_timed ? 0 : value;
                  });
                  _setTime();
                }),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Object"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.check), onPressed: () => Navigator.pop(context))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: "Name"),
            textCapitalization: TextCapitalization.sentences,
            onChanged: (value) {
              _exerciseObject.name = value;
              _exercise.objects.removeAt(_index);
              _exercise.objects.insert(_index, _exerciseObject);
              Store().editExercise(_exercise);
            },
          ),
          SizedBox(
            height: 32.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Timed?"),
              Switch(
                onChanged: (value) {
                  setState(() {
                    _timed = value;
                    _seconds = 0;
                    _minutes = 0;
                  });
                  _setTime();
                },
                value: _timed,
              ),
            ],
          ),
          SizedBox(
            height: 32.0,
          ),
          _timePicker(),
        ],
      ),
    );
  }
}
