import 'package:flutter/material.dart';

import 'package:workout_2/utils/Store.dart';
import 'package:workout_2/utils/requests.dart';

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
  bool _loading = false;
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
        _loading ? Center(child: CircularProgressIndicator()) : SizedBox(),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: RaisedButton(
            child: Text("Save to server"),
            onPressed: _loading
                ? null
                : () async {
                    setState(() {
                      _loading = true;
                    });
                    bool success = await putStore();
                    setState(() {
                      _loading = false;
                    });
                    Navigator.pop(context);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(success ? "Succes" : "Error"),
                    ));
                  },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: RaisedButton(
            child: Text("Get from server"),
            onPressed: _loading
                ? null
                : () async {
                    bool confirmation = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Are you sure?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("No"),
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                ),
                                FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ));
                    if (confirmation) {
                      setState(() {
                        _loading = true;
                      });
                      bool success = await getStore();
                      setState(() {
                        _loading = false;
                      });
                      Navigator.pop(context);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(success ? "Succes" : "Error"),
                      ));
                    }
                  },
          ),
        ),
      ],
    );
  }
}
