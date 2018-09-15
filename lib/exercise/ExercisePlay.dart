import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayer2/audioplayer2.dart';
import 'package:screen/screen.dart';

import 'package:workout_2/exercise/objects.dart';
import 'package:workout_2/stats/objects.dart';
import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/utils.dart';

class ExercisePlay extends StatelessWidget {
  ExercisePlay({Key key, this.exercise}) : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return MyExercisePlay(
      exercise: exercise,
    );
  }
}

class MyExercisePlay extends StatefulWidget {
  MyExercisePlay({Key key, this.exercise}) : super(key: key);

  final Exercise exercise;

  @override
  _MyExercisePlayState createState() => _MyExercisePlayState();
}

enum PlayerState { stopped, playing, paused }

class _MyExercisePlayState extends State<MyExercisePlay> {
  _MyExercisePlayState();

  AudioPlayer audioPlayer;
  PlayerState playerState = PlayerState.playing;

  Exercise _exercise;
  ExerciseStat _exerciseStat;
  int _endTime = 0;
  int _currentIndex = 0;
  int _currentTime;
  Timer _timer;
  bool _done = false;
  bool _paused = false;
  String _longBeepPath;
  String _beepPath;
  bool _tapStop = false;

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _exercise = widget.exercise;
    _exerciseStat = ExerciseStat(
        name: _exercise.name, startTime: DateTime.now().millisecondsSinceEpoch);
    Screen.keepOn(true);
    ExerciseObject object = _exercise.objects[_currentIndex];
    _currentTime = object.time;
    _loadFiles();
    _loadFiles2();
    initAudioPlayer();
    _start(object.time);
  }

  @override
  void dispose() {
    audioPlayer.stop();
    Screen.keepOn(false);
    super.dispose();
  }

  Future<ByteData> loadAsset() async {
    return await rootBundle.load('sounds/beep_long.mp3');
  }

  Future _loadFiles() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file = new File('$tempPath/beep_long.mp3');
    await file.writeAsBytes((await loadAsset()).buffer.asUint8List());
    setState(() {
      _longBeepPath = file.path;
    });
  }

  Future<ByteData> loadAsset2() async {
    return await rootBundle.load('sounds/beep.mp3');
  }

  Future _loadFiles2() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    final file = new File('$tempPath/beep.mp3');
    await file.writeAsBytes((await loadAsset2()).buffer.asUint8List());
    setState(() {
      _beepPath = file.path;
    });
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
  }

  Future _playLongBeep() async {
    await audioPlayer.play(_longBeepPath, isLocal: true);
  }

  Future _playBeep() async {
    await audioPlayer.play(_beepPath, isLocal: true);
  }

  void _start(int time) {
    setState(() {
      _endTime = DateTime.now().millisecondsSinceEpoch + time;
    });
    _timer = Timer.periodic(Duration(milliseconds: 100), _updateTime);
  }

  void _updateTime(timer) {
    if (_currentTime <= 100) {
      _playLongBeep();
    }
    if (_currentTime <= 3050 && _currentTime >= 2950 ||
        _currentTime <= 2050 && _currentTime >= 1950 ||
        _currentTime <= 1050 && _currentTime >= 950) {
      _playBeep();
    }
    if (_currentTime <= 100) {
      if (_currentIndex + 1 >= _exercise.objects.length) {
        _timer.cancel();
        setState(() {
          _done = true;
        });
        _exerciseStat.endTime = DateTime.now().millisecondsSinceEpoch;
        Store().addExerciseStat(_exerciseStat);
      }

      ExerciseObject object = _exercise.objects[_currentIndex + 1];

      setState(() {
        _currentIndex++;
      });
      setState(() {
        _endTime =
            DateTime.now().millisecondsSinceEpoch + object.time; // + 1000
      });
      setState(() {
        _currentTime = object.time;
      });

      _controller.animateTo((0.0),
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      if (object.time == 0) {
        _timer.cancel();
        setState(() {
          _tapStop = true;
        });
      }
    } else {
      // print(_currentTime);
      setState(() {
        _currentTime = _endTime - DateTime.now().millisecondsSinceEpoch;
      });
    }
  }

  Widget _backButton() {
    if (_done || _paused) {
      return RaisedButton(
        child: Text("Back"),
        onPressed: () {
          Navigator.pop(context);
        },
      );
    } else {
      return SizedBox(
        height: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ExerciseObject object = _exercise.objects[_currentIndex];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.red,
                child: ListTile(
                  onTap: () {
                    if (_tapStop) {
                      setState(() {
                        _paused = false;
                        _endTime = DateTime.now().millisecondsSinceEpoch +
                            _currentTime;
                      });
                      setState(() {
                        _tapStop = false;
                      });
                      _timer = Timer.periodic(
                          Duration(milliseconds: 100), _updateTime);
                    }
                  },
                  title: _done
                      ? Column(
                          children: <Widget>[
                            Text(
                              "Done",
                              style: Theme.of(context).textTheme.display2,
                            ),
                            Text(
                              "00:00",
                              style: Theme.of(context).textTheme.display3,
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Text(
                              object.name,
                              style: Theme.of(context).textTheme.display2,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              _tapStop
                                  ? "Tap To Continue"
                                  : formatTime(_currentTime),
                              style: _tapStop
                                  ? Theme.of(context).textTheme.display1
                                  : Theme.of(context).textTheme.display3,
                            ),
                          ],
                        ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: _exercise.objects.length,
                itemBuilder: (context, index) {
                  ExerciseObject object = _exercise.objects[index];
                  if (index <= _currentIndex)
                    return SizedBox(
                      height: 0.0,
                    );
                  return ListTile(
                    title: Column(
                      children: <Widget>[
                        Text(
                          object.name,
                          style: Theme.of(context).textTheme.display2,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          formatTime(object.time),
                          style: Theme.of(context).textTheme.display3,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _backButton(),
          // _resetButton(),
        ],
      ),
      floatingActionButton: _paused
          ? FloatingActionButton(
              child: Icon(Icons.play_arrow),
              onPressed: () {
                setState(() {
                  _paused = false;
                  _endTime =
                      DateTime.now().millisecondsSinceEpoch + _currentTime;
                });
                _timer =
                    Timer.periodic(Duration(milliseconds: 100), _updateTime);
              },
            )
          : FloatingActionButton(
              child: Icon(Icons.pause),
              onPressed: () {
                setState(() {
                  _currentTime =
                      _endTime - DateTime.now().millisecondsSinceEpoch;
                  _paused = true;
                });
                _timer.cancel();
              },
            ),
    );
  }
}
