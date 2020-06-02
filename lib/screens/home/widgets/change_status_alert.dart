import 'package:dropcure/Theme/colors.dart';
import 'package:flutter/material.dart';

class ChangeStatusAlert extends StatelessWidget {
  final String msg;
  final Function changeStatus;
  final int index;
  ChangeStatusAlert(this.msg, this.changeStatus, this.index);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Center(
        child: Text(
          "Are you sure you want to change the status of this order?",
          textAlign: TextAlign.center,
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
            color: pinkColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("Change Status"),
            textColor: Colors.white,
            onPressed: () {
              changeStatus(msg, index);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: pinkColor)),
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
