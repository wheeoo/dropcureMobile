import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/screens/home/home_screen_pages/customer_list.dart';
import 'package:dropcure/screens/home/home_screen_pages/home_screen.dart';
import 'package:dropcure/screens/home/home_screen_pages/profile_popup.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class HomePage extends StatefulWidget {
  static const routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isProfileclicked = false;
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
  void itemClicked(index) {
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

  Widget pageToShow = HomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          pageToShow,
          isProfileclicked ? ProfilePopup() : Container()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) {
            itemClicked(index);
          },
          backgroundColor: pinkColor,
          items: bottomNavigationItems.map((e) {
            return BottomNavigationBarItem(
                title: Text(e["title"]), icon: e["icon"]);
          }).toList()),
    );
  }
}
