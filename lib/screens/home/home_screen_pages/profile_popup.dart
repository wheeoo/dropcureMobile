import 'dart:ui';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/screens/home/widgets/delivery_count_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ProfilePopup extends StatelessWidget {
  Map<String, double> dataMap = new Map();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    dataMap.putIfAbsent("Completed", () => 28);
    dataMap.putIfAbsent("Open", () => 15);
    dataMap.putIfAbsent("Cancel", () => 2);
    TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold);
    return Positioned(
      top: 0,
      right: 15,
      child: Container(
        height: height * 0.67,
        width: width * 0.92,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
          gradient: LinearGradient(
              colors: [Colors.white, lightPinkColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: lightPinkColor),
                      image: DecorationImage(
                          image: AssetImage("assets/images/photo.jpg"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Mike J Titet"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("Level 3"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("234397"),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text("1234567890"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/car.png",
                      height: 70,
                      width: 70,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("2009 Honda Accord"),
                        Row(
                          children: <Widget>[
                            Text(
                              "Plate: ",
                              style: labelStyle,
                            ),
                            Text("44GHS93"),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Color: ",
                              style: labelStyle,
                            ),
                            Text("Blue"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                                shape: BoxShape.circle, color: greenColor),
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blue),
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
                    DeliveryCountWidget(28, 15, 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
