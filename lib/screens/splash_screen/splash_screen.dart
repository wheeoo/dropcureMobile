import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/screens/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash-screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double latitude, longitude;
  LocationData userLocation;

  Future getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied ||
        _permissionGranted == PermissionStatus.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please give location permission",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      do {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          Fluttertoast.showToast(
              msg: "Please give location permission",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else if (_permissionGranted == PermissionStatus.deniedForever) break;
      } while (_permissionGranted != PermissionStatus.granted);
      if (_permissionGranted != PermissionStatus.granted) {}
    }
  }

  init() async {
    await getLocation();
    Timer(Duration(seconds: 2), () async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        URL url = URL();
        Dio dio = Dio();
        Response response = await dio.get(url.url + "get_version.php");
        String platform = Platform.isAndroid
            ? "android_version"
            : Platform.isIOS ? "ios_version" : "";
        String latestVersion = json.decode(response.data)["data"][platform];
        if (version == latestVersion) {
          SharedPreferences data = await SharedPreferences.getInstance();
          if (data.containsKey("user_id"))
            Navigator.of(context).pushReplacementNamed(
              HomePage.routeName,
            );
          else
            Navigator.of(context).pushReplacementNamed(
              Login.routeName,
            );
        } else {
          Fluttertoast.showToast(
              msg: "Please update your app to latest version",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              fontSize: 16.0);
          OpenAppstore.launch(
              androidAppId: packageInfo.packageName, iOSAppId: "");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please connect to internet",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            fontSize: 16.0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
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
