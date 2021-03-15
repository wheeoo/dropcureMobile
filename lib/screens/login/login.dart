import 'dart:convert';
import 'dart:convert' as JSON;
import 'dart:io' show Platform;

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/models/user.dart';
import 'package:dropcure/screens/home/home_page.dart';
import 'package:dropcure/screens/login/widgets/loading_dialog.dart';
import 'package:dropcure/screens/login/widgets/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './widgets/forgotPassword.dart';
import './widgets/retry_dialog.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  var passwordIcon = Icons.visibility_off;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Map userProfile;
  final facebookLogin = FacebookLogin();

  signInWithGoogle() async {
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    BuildContext loadContext;
    showDialog(
        context: context,
        builder: (ctx) {
          loadContext = ctx;
          return LoadingDialog("Logging in please wait..");
        },
        barrierDismissible: false);
    try {
      Dio dio = Dio();
      URL url = URL();
      String deviceType = Platform.isAndroid
          ? "A"
          : Platform.isIOS
              ? "I"
              : "";
      FormData userData = new FormData.fromMap({
        "email": googleAccount.email.trim().toLowerCase(),
        "social_key": googleAccount.id,
        "name": googleAccount.displayName.trim(),
        "login_type": "2",
        "profile_pic": googleAccount.photoUrl,
        "device_type": deviceType,
        "device_token": await _getId(),
      });
      Response response =
          await dio.post(url.url + "social_login.php", data: userData);
      var data = json.decode(response.data);
      if (data["status"]) {
        User user = User.fromJson(data["data"]);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', user.id.toString());
        prefs.setString('login_type', "google");
        Navigator.pop(loadContext);
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      } else {
        Navigator.pop(loadContext);
        showDialog(
            context: context,
            builder: (ctx) {
              return ShowAlert("Error Logging in!", data["message"].toString());
            });
        await _googleSignIn.signOut();
      }
    } catch (e) {
      Navigator.of(loadContext).pop();
      showDialog(
          context: context,
          builder: (ctx) {
            return RetryDialog("Something Went Wrong!", login);
          },
          barrierDismissible: false);
    }
  }

  _loginWithFB() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        Dio dio = Dio();
        final graphResponse = await dio.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        final profile = JSON.jsonDecode(graphResponse.data);
        BuildContext loadContext;
        showDialog(
            context: context,
            builder: (ctx) {
              loadContext = ctx;
              return LoadingDialog("Logging in please wait..");
            },
            barrierDismissible: false);
        try {
          Dio dio = Dio();
          URL url = URL();
          String deviceType = Platform.isAndroid
              ? "A"
              : Platform.isIOS
                  ? "I"
                  : "";
          FormData userData = new FormData.fromMap({
            "email": profile["email"].trim().toLowerCase(),
            "social_key": profile["id"],
            "name": profile["name"].trim(),
            "login_type": "1",
            "profile_pic": profile["picture"]["data"]["url"],
            "device_type": deviceType,
            "device_token": await _getId(),
          });
          Response response =
              await dio.post(url.url + "social_login.php", data: userData);
          var data = json.decode(response.data);
          if (data["status"]) {
            User user = User.fromJson(data["data"]);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('user_id', user.id.toString());
            prefs.setString('login_type', "fb");
            Navigator.pop(loadContext);
            Navigator.of(context).pushReplacementNamed(HomePage.routeName);
          } else {
            Navigator.pop(loadContext);
            showDialog(
                context: context,
                builder: (ctx) {
                  return ShowAlert(
                      "Error Logging in!", data["message"].toString());
                });
          }
        } catch (e) {
          Navigator.of(loadContext).pop();
          showDialog(
              context: context,
              builder: (ctx) {
                return RetryDialog("Something Went Wrong!", login);
              },
              barrierDismissible: false);
        }
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }

  loginApple() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [
          Scope.email,
          Scope.fullName,
        ])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.user);
          BuildContext loadContext;
          showDialog(
              context: context,
              builder: (ctx) {
                loadContext = ctx;
                return LoadingDialog("Logging in please wait..");
              },
              barrierDismissible: false);
          try {
            Dio dio = Dio();
            URL url = URL();
            String deviceType = Platform.isAndroid
                ? "A"
                : Platform.isIOS
                    ? "I"
                    : "";
            FormData userData = new FormData.fromMap({
              "email": result.credential.email,
              "social_key": result.credential.user ?? "",
              "name": result.credential.fullName,
              "login_type": "3",
              "profile_pic": "",
              "device_type": deviceType,
              "device_token": await _getId(),
            });
            Response response =
                await dio.post(url.url + "social_login.php", data: userData);
            var data = json.decode(response.data);
            if (data["status"]) {
              User user = User.fromJson(data["data"]);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('user_id', user.id.toString());
              prefs.setString('login_type', "fb");
              Navigator.pop(loadContext);
              Navigator.of(context).pushReplacementNamed(HomePage.routeName);
            } else {
              Navigator.pop(loadContext);
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return ShowAlert(
                        "Error Logging in!", data["message"].toString());
                  });
            }
          } catch (e) {
            Navigator.of(loadContext).pop();
            showDialog(
                context: context,
                builder: (ctx) {
                  return RetryDialog("Something Went Wrong!", login);
                },
                barrierDismissible: false);
          }
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    } else {
      print('Apple SignIn is not available for your device');
    }
  }

  void forgotPasswordPopup() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) {
          return ForgotPassword();
        });
  }

  Future<String> _getId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  login() async {
    BuildContext loadContext;
    showDialog(
        context: context,
        builder: (ctx) {
          loadContext = ctx;
          return LoadingDialog("Logging in please wait..");
        },
        barrierDismissible: false);
//    try {
    Dio dio = Dio();
    URL url = URL();
    String email = emailController.text.trim().toLowerCase();
    String password = passwordController.text.trim();
    String deviceType = Platform.isAndroid
        ? "A"
        : Platform.isIOS
            ? "I"
            : "";
    FormData userData = new FormData.fromMap({
      "username": email,
      "password": password,
      "device_type": deviceType,
      "device_token": await _getId(),
    });
    Response response = await dio.post(url.url + "login.php", data: userData);
    var data = json.decode(response.data);
    if (data["status"]) {
      User user = User.fromJson(data["data"]);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', user.id.toString());
      prefs.setString('login_type', "email");
      Navigator.pop(loadContext);
      Navigator.of(context).pushReplacementNamed(
        HomePage.routeName,
      );
    } else {
      Navigator.pop(loadContext);
      showDialog(
          context: context,
          builder: (ctx) {
            return ShowAlert("Error Logging in!", data["message"].toString());
          });
    }
//    } catch (e) {
//      Navigator.of(loadContext).pop();
//      showDialog(
//          context: context,
//          builder: (ctx) {
//            return RetryDialog("Something Went Wrong!", login);
//          },
//          barrierDismissible: false);
//    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/login_bg.png"),
                  fit: BoxFit.cover)),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.white),
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
                            borderSide: BorderSide(color: pinkColor))),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    cursorColor: pinkColor,
                    validator: (value) {
                      if (value.isEmpty) return "Please enter Username";
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.white),
                      hintText: "Password",
                      prefixIcon: Container(
                        height: 3,
                        width: 3,
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/images/password.png",
                        ),
                      ),
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: pinkColor)),
                      suffixIcon: GestureDetector(
                        child: Icon(passwordIcon, color: Colors.white),
                        onTap: () {
                          if (passwordIcon == Icons.visibility_off) {
                            setState(() {
                              obscureText = false;
                              passwordIcon = Icons.visibility;
                            });
                          } else {
                            setState(() {
                              obscureText = true;
                              passwordIcon = Icons.visibility_off;
                            });
                          }
                        },
                      ),
                    ),
                    obscureText: obscureText,
                    cursorColor: pinkColor,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    validator: (value) {
                      if (value.isEmpty) return "Please enter Password";
                      return null;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 30),
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        if (_formKey.currentState.validate()) login();
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
                            child: Image.asset("assets/images/google.png"),
                          ),
                          onTap: () {
                            signInWithGoogle();
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: pinkColor),
                            child: Image.asset("assets/images/fb.png"),
                          ),
                          onTap: () {
                            _loginWithFB();
                          },
                        ),
                        Platform.isIOS
                            ? GestureDetector(
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: pinkColor),
                                  child: Image.asset("assets/images/apple.png"),
                                ),
                                onTap: () {
                                  loginApple();
                                },
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
