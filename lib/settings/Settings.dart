import 'package:flutter/material.dart';

import 'package:workout_2/utils/Store.dart';

class Settings extends StatelessWidget {
  Settings({Key key, this.update}) : super(key: key);

  final VoidCallback update;

  @override
  Widget build(BuildContext context) {
    return MySettings(update: update);
  }
}

class MySettings extends StatefulWidget {
  MySettings({Key key, this.update}) : super(key: key);

  final VoidCallback update;

  @override
  _MySettingsState createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Settings",
                style: Theme.of(context).textTheme.headline,
              ),
            ],
          ),
          decoration:
              BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
        ),
        ListTile(
          title: Text("Dark Theme"),
          trailing: Switch(
            onChanged: (value) {
              Store().setTheme(value ? "dark" : "light");
              widget.update();
            },
            value: Store().theme == "dark",
          ),
        ),
      ],
    );
  }
}
