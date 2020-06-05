import 'dart:convert';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/screens/login/widgets/retry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/screens/login/widgets/loading_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  submit() async {
    BuildContext loadContext;
    showDialog(
        context: context,
        builder: (ctx) {
          loadContext = ctx;
          return LoadingDialog("Please wait..");
        },
        barrierDismissible: false);
    try {
      var email = emailController.text.trim();
      Dio dio = Dio();
      URL url = URL();
      var userEmail = FormData.fromMap({"email": email});
      Response response =
          await dio.post(url.url + "forgot_password.php", data: userEmail);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.data);
        if (responseData["status"]) {
          Navigator.of(loadContext).pop();
          Navigator.of(context).pop();
          Fluttertoast.showToast(
              msg: "Email sent to " + email,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else {
          Navigator.of(loadContext).pop();
          Fluttertoast.showToast(
              msg: responseData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      }
    } catch (e) {
      Navigator.of(loadContext).pop();
      showDialog(
          context: context,
          builder: (ctx) {
            return RetryDialog("Something Went Wrong!", submit);
          },
          barrierDismissible: false);
    }
  }

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
      content: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                fillColor: greyColor,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: pinkColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: pinkColor)),
              ),
              cursorColor: pinkColor,
              controller: emailController,
              validator: (value) {
                if (value.isEmpty)
                  return "Please enter Email";
                else if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) return "Invalid Email";
                return null;
              },
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  submit();
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(
                  "Send",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: pinkColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ],
        ),
      ),
    );
  }
}
