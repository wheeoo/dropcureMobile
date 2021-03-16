import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/models/order.dart';
import 'package:dropcure/screens/home/home_screen_pages/customer_list.dart';
import 'package:dropcure/screens/home/home_screen_pages/home_screen.dart';
import 'package:dropcure/screens/home/home_screen_pages/profile_popup.dart';
import 'package:dropcure/screens/login/login.dart';
import 'package:dropcure/screens/login/widgets/retry_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  DateTime selectedDate = DateTime.now();
  DateTime pickerDate;
  bool showDrawer = false;
  var image;
  var name;
  var details;
  final key = GlobalKey<ScaffoldState>();
  final orderKey = GlobalKey<CustomerListState>();

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
          showDrawer = false;
          pageToShow = HomeScreen();
          isProfileclicked = false;
        });
        break;
      case 1:
        setState(() {
          print(selectedDate);
          pageToShow = CustomerList(
            selectedDate,
            openDrawer,
            key: orderKey,
          );
          isProfileclicked = false;
          showDrawer = true;
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
          showDrawer = false;
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
      if (pageToShow is CustomerList) {
        showDrawer = true;
      }
      isProfileclicked = false;
    });
  }

  openDrawer() async {
    await getData();
    key.currentState.openDrawer();
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

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('user_id');
    Dio dio = Dio();
    URL url = URL();
    FormData userData = new FormData.fromMap({
      "user_id": id,
    });
    Response response =
        await dio.post(url.url + "driver_profile.php", data: userData);
    setState(() {
      var data = json.decode(response.data);
      details = data["data"];
      image = data["data"]["user"]["user_image"];
      name = data["data"]["user"]["full_name"];
    });
  }

  @override
  void initState() {
    super.initState();
    pickerDate = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: infoCardBg,
      drawer: showDrawer
          ? Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Drawer(
                child: Container(
                  color: infoCardBg,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 20,
                              bottom: 20),
                          color: pinkColor,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Container(
                                  height:
                                      MediaQuery.of(context).size.width * .2,
                                  width: MediaQuery.of(context).size.width * .2,
                                  decoration: BoxDecoration(
                                      image: image == null
                                          ? null
                                          : DecorationImage(
                                              image: NetworkImage(image),
                                              fit: BoxFit.cover),
                                      shape: BoxShape.circle),
                                ),
                                title: Text(
                                  "Delivery Dashboard",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Partner: ${name ?? ''}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      "EmpId: ${details == null ? "" : details["user"]["id"]}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Select Date",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        height: 200,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: CupertinoTheme(
                                          data: CupertinoThemeData(
                                            textTheme: CupertinoTextThemeData(
                                              dateTimePickerTextStyle:
                                                  TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                          child: CupertinoDatePicker(
                                            initialDateTime: pickerDate,
                                            onDateTimeChanged: (date) {
                                              pickerDate = date;
                                            },
                                            mode: CupertinoDatePickerMode.date,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Delivery Data To Date",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        // padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Table(
                                          columnWidths: {
                                            1: IntrinsicColumnWidth()
                                          },
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            TableRow(children: [
                                              Icon(Icons.delivery_dining),
                                              Text(
                                                "Delivery Total",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Text(
                                                    details == null
                                                        ? ""
                                                        : details["order"]
                                                                ["deliveries"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Icon(Icons
                                                  .check_circle_outline_sharp),
                                              Text(
                                                "Delivery Completed",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Text(
                                                    details == null
                                                        ? ""
                                                        : details["order"]
                                                                ["complete"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Icon(Icons.remove_circle_outline),
                                              Text(
                                                "Delivery Open",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Text(
                                                    details == null
                                                        ? ""
                                                        : details["order"]
                                                                ["open"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            TableRow(children: [
                                              Icon(
                                                Icons.not_interested_sharp,
                                                color: Colors.red,
                                              ),
                                              Text(
                                                "Delivery Cancelled",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 5),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black),
                                                child: Center(
                                                  child: Text(
                                                    details == null
                                                        ? ""
                                                        : details["order"]
                                                                ["cancel"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  height: 150,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Image.asset(
                                            "assets/images/submit.png",
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          print(pickerDate);
                                          orderKey.currentState
                                              .change(pickerDate);
                                        },
                                      ),
                                      // SizedBox(
                                      //   width: 30,
                                      // ),
                                      InkWell(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Image.asset(
                                            "assets/images/exit.png",
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, pinkColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: <Widget>[Image.asset("assets/images/logo.png")],
        leading: Container(),
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
