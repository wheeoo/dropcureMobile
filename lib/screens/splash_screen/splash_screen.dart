import 'dart:async';

import 'package:flutter/material.dart';

import '../login/login.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash-screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed(Login.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/splash.png"),
              fit: BoxFit.cover)),
    );
  }
}
