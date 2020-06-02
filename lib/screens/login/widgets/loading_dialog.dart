import 'package:dropcure/Theme/colors.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String msg;
  LoadingDialog(this.msg);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: 100,
        width: 100,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(pinkColor),
          ),
        ),
      ),
    );
  }
}
