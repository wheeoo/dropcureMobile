import 'package:dropcure/screens/home/home_page.dart';
import 'package:dropcure/screens/login/login.dart';
import 'package:dropcure/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropcure',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Roboto"),
      home: SplashScreen(),
      routes: {
        Login.routeName: (context) => Login(),
        HomePage.routeName: (context) => HomePage(),
      },
    );
  }
}
