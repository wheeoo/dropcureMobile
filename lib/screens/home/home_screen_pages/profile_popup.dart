import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/screens/home/widgets/delivery_count_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePopup extends StatefulWidget {
  final Function closeProfile;

  ProfilePopup(this.closeProfile);

  @override
  _ProfilePopupState createState() => _ProfilePopupState();
}

class _ProfilePopupState extends State<ProfilePopup> {
  Map<String, double> dataMap = {"Completed": 0, "Open": 0, "Cancel": 0};
  var details;
  bool isLoaded = false;

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('user_id');
    Dio dio = Dio();
    URL url = URL();
    print("id" + id);
    FormData userData = new FormData.fromMap({
      "user_id": id,
    });
    dio.post(url.url + "driver_profile.php", data: userData).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          var data = json.decode(value.data);
          details = data["data"];
          print("Profile" + details.toString());
          dataMap["Completed"] =
              double.parse(details["order"]["complete"].toString());
          dataMap["Open"] = double.parse(details["order"]["open"].toString());
          dataMap["Cancel"] =
              double.parse(details["order"]["cancel"].toString());
          isLoaded = true;
        });
      } else {
        print(value.statusCode);
        print(value.statusMessage);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold);
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        height: height * 0.67,
        width: width * 0.92,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
              colors: [Colors.white, lightPinkColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: isLoaded
            ? SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        child: Icon(
                          Icons.close,
                          color: pinkColor,
                        ),
                        onTap: () {
                          widget.closeProfile();
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: lightPinkColor),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        details["user"]["user_image"]),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 75,
                              width: 75,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/car.png"),
                                    fit: BoxFit.contain),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Agent: ",
                                        style: labelStyle,
                                      ),
                                      Text(
                                        "Access: ",
                                        style: labelStyle,
                                      ),
                                      Text(
                                        "Empid: ",
                                        style: labelStyle,
                                      ),
                                      Text(
                                        "Cell: ",
                                        style: labelStyle,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(details["user"]["full_name"]),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(details["user"]["access"]),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(details["user"]["id"]),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(details["user"]["phone_number"]
                                                  .toString()
                                                  .isNotEmpty
                                              ? "(" +
                                                  details["user"]
                                                          ["phone_number"]
                                                      .toString()
                                                      .substring(0, 3) +
                                                  ")" +
                                                  details["user"]
                                                          ["phone_number"]
                                                      .toString()
                                                      .substring(3)
                                              : ""),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(details["user"]["car_name"]),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Plate: ",
                                        style: labelStyle,
                                      ),
                                      Text(details["user"]["car_plate"]),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Color: ",
                                        style: labelStyle,
                                      ),
                                      Text(details["user"]["car_color"]),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        Container(
//                          margin: EdgeInsets.only(right: 10),
//                          height: 75,
//                          width: 75,
//                          decoration: BoxDecoration(
//                            shape: BoxShape.circle,
//                            border: Border.all(color: lightPinkColor),
//                            image: DecorationImage(
//                                image:
//                                    NetworkImage(details["user"]["user_image"]),
//                                fit: BoxFit.cover),
//                          ),
//                        ),
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text(
//                              "Agent: ",
//                              style: labelStyle,
//                            ),
//                            Text(
//                              "Access: ",
//                              style: labelStyle,
//                            ),
//                            Text(
//                              "Empid: ",
//                              style: labelStyle,
//                            ),
//                            Text(
//                              "Cell: ",
//                              style: labelStyle,
//                            ),
//                          ],
//                        ),
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Row(
//                              children: <Widget>[
//                                Text(details["user"]["full_name"]),
//                              ],
//                            ),
//                            Row(
//                              children: <Widget>[
//                                Text(details["user"]["access"]),
//                              ],
//                            ),
//                            Row(
//                              children: <Widget>[
//                                Text(details["user"]["id"]),
//                              ],
//                            ),
//                            Row(
//                              children: <Widget>[
//                                Text(details["user"]["phone_number"]),
//                              ],
//                            ),
//                          ],
//                        )
//                      ],
//                    ),
//                    SizedBox(
//                      height: 24,
//                    ),
//                    Container(
////                      margin: EdgeInsets.only(right: 10),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
////                          Image.asset(
////                            "assets/images/car.png",
////                            height: 70,
////                            width: 70,
////                          ),
//                          Container(
//                            margin: EdgeInsets.only(right: 10),
//                            height: 75,
//                            width: 75,
//                            decoration: BoxDecoration(
//                              image: DecorationImage(
//                                  image: AssetImage("assets/images/car.png"),
//                                  fit: BoxFit.contain),
//                            ),
//                          ),
//                          Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(details["user"]["car_name"]),
//                              Row(
//                                children: <Widget>[
//                                  Text(
//                                    "Plate: ",
//                                    style: labelStyle,
//                                  ),
//                                  Text(details["user"]["car_plate"]),
//                                ],
//                              ),
//                              Row(
//                                children: <Widget>[
//                                  Text(
//                                    "Color: ",
//                                    style: labelStyle,
//                                  ),
//                                  Text(details["user"]["car_color"]),
//                                ],
//                              ),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: lightPinkColor),
                      child: PieChart(
                        dataMap: dataMap,
                        chartRadius: width / 2.7,
                        showLegends: false,
                        showChartValuesInPercentage: false,
                        chartValueStyle: TextStyle(color: Colors.transparent),
                        colorList: [greenColor, Colors.blue, redColor],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
//                padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 35, right: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: greenColor),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: redColor),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DeliveryCountWidget(
                              details["order"]["deliveries"],
                              details["order"]["complete"],
                              details["order"]["open"],
                              details["order"]["cancel"]),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(pinkColor),
                ),
              ),
      ),
    );
  }
}
