import 'dart:async';

import 'package:flutter/material.dart';

import 'package:workout_2/utils/Store.dart';

import 'package:workout_2/Home.dart';

Future main() async {
  await Store().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout 2',
      theme: Store().theme == "dark" ? ThemeData.dark() : ThemeData.light(),
      home: Home(
        update: () => _update(),
      ),
    );
  }
}
