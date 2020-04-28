import 'package:dropcure/Theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Container(
        padding: EdgeInsets.all(20),
        child: Text(
          "Please enter your email address to reset password:",
          textAlign: TextAlign.center,
        ),
      ),
      titleTextStyle: TextStyle(color: pinkColor),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              fillColor: greyColor,
              filled: true,
              enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: pinkColor)),
              focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: pinkColor)),
            ),
            cursorColor: pinkColor,
          ),
          SizedBox(
            height: 10,
          ),
          RaisedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "Send",
                style: TextStyle(color: Colors.white),
              ),
            ),
            color: pinkColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ],
      ),
    );
  }
}
