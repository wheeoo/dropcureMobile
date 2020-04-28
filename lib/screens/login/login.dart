import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './widgets/forgotPassword.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void forgotPasswordPopup() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) {
          return ForgotPassword();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover)),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  hintText: "Username",
                  prefixIcon: Container(
                    height: 3,
                    width: 3,
                    padding: EdgeInsets.all(12),
                    child: Image.asset(
                      "assets/images/user.png",
                    ),
                  ),
                  hintStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              cursorColor: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Container(
                  height: 3,
                  width: 3,
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/password.png",
                  ),
                ),
                hintStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              obscureText: true,
              cursorColor: Colors.white,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 30),
              child: RaisedButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(HomePage.routeName);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "Let's Go!",
                    style: TextStyle(fontSize: 25, color: pinkColor),
                  ),
                ),
              ),
            ),
            FlatButton(
              child: Text(
                "Forgot my password",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                forgotPasswordPopup();
              },
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                "or login with",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: pinkColor),
                        child: Image.asset("assets/images/google.png")),
                  ),
                  GestureDetector(
                    child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: pinkColor),
                        child: Image.asset("assets/images/fb.png")),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
