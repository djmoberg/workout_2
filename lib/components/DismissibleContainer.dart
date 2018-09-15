import 'package:flutter/material.dart';

class DismissibleContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Icon(Icons.delete), Icon(Icons.delete)],
        ),
      ),
    );
  }
}
