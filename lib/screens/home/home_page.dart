import 'dart:convert';

import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/models/order.dart';
import 'package:dropcure/screens/home/home_screen_pages/customer_list.dart';
import 'package:dropcure/screens/home/home_screen_pages/home_screen.dart';
import 'package:dropcure/screens/home/home_screen_pages/profile_popup.dart';
import 'package:dropcure/screens/login/login.dart';
import 'package:dropcure/screens/login/widgets/loading_dialog.dart';
import 'package:dropcure/screens/login/widgets/retry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget pageToShow = HomeScreen();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();
  bool isProfileclicked = false;
  List<Order> orders;
  Order openOrder;
  List<Map<String, dynamic>> bottomNavigationItems = [
    {
      "title": "Home",
      "icon": Container(
        height: 30,
        width: 30,
        child: Image.asset(
          "assets/images/home.png",
        ),
      ),
    },
    {
      "title": "List",
      "icon": Container(
        height: 25,
        width: 25,
        child: Image.asset(
          "assets/images/userprof.png",
        ),
      ),
    },
    {
      "title": "Logout",
      "icon": Icon(Icons.power_settings_new, color: Colors.black),
    },
    {
      "title": "Profile",
      "icon": Container(
        height: 25,
        width: 25,
        child: Image.asset(
          "assets/images/settings.png",
        ),
      ),
    }
  ];
  void itemClicked(index, ctx) {
    switch (index) {
      case 0:
        setState(() {
          pageToShow = HomeScreen();
          isProfileclicked = false;
        });
        break;
      case 1:
        setState(() {
          pageToShow = CustomerList();
          isProfileclicked = false;
        });
        break;
      case 2:
        logout(ctx);
        setState(() {
          isProfileclicked = false;
        });
        break;
      case 3:
        setState(() {
          if (isProfileclicked)
            isProfileclicked = false;
          else
            isProfileclicked = true;
        });
        break;
    }
  }

  closeProfile() {
    setState(() {
      isProfileclicked = false;
    });
  }

  void logout(ctx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loginType = prefs.getString('login_type');
    try {
      if (loginType.compareTo("google") == 0) {
        await googleSignIn.signOut();
      } else if (loginType.compareTo("fb") == 0) {
        await facebookLogin.logOut();
      }
      prefs.clear();
      Fluttertoast.showToast(
          msg: "Successfully Logged Out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Navigator.of(ctx).pushReplacementNamed(Login.routeName);
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) {
            return RetryDialog("Something Went Wrong!", logout);
          },
          barrierDismissible: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: infoCardBg,
      appBar: GradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.white, pinkColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        actions: <Widget>[Image.asset("assets/images/logo.png")],
      ),
      body: Stack(
        children: <Widget>[
          pageToShow != null ? pageToShow : Container(),
          isProfileclicked ? ProfilePopup(closeProfile) : Container()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            itemClicked(index, context);
          },
          backgroundColor: pinkColor,
          items: bottomNavigationItems.map((e) {
            return BottomNavigationBarItem(
                title: Text(e["title"]), icon: e["icon"]);
          }).toList()),
    );
  }
}
