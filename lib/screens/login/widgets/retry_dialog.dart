import 'package:flutter/material.dart';

class RetryDialog extends StatelessWidget {
  final String title;
  final Function retry;
  RetryDialog(this.title, this.retry);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: <Widget>[
        FlatButton(
          child: Text("Retry"),
          onPressed: () {
            Navigator.pop(context);
            retry();
          },
        ),
      ],
    );
  }
}
