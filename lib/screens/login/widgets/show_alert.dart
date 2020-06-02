import 'package:dropcure/Theme/colors.dart';
import 'package:flutter/material.dart';

class ShowAlert extends StatelessWidget {
  final String title, content;
  ShowAlert(this.title, this.content);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Close",
            style: TextStyle(color: pinkColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
