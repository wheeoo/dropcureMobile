import 'package:dropcure/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'customer_popup.dart';
import 'package:swipedetector/swipedetector.dart';

class InfoCard extends StatefulWidget {
  String id;
  String address;
  Color circleColor;
  InfoCard(this.id, this.address, this.circleColor);
  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: infoCardBg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: widget.circleColor),
            ),
            Container(
                height: 50,
                width: 50,
                child: Image.asset("assets/images/box.png")),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.id,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.address,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            GestureDetector(
              child: Container(
                height: 60,
                width: 60,
                margin: EdgeInsets.all(10),
                child: Card(
                  elevation: 7,
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/photo.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return CustomerPopup();
                    });
              },
            ),
          ],
        ),
      ),
      onSwipeLeft: () {
        print("left");
        setState(() {
          widget.circleColor = Colors.black;
        });
      },
      onSwipeRight: () {
        print("right");
        setState(() {
          widget.circleColor = Colors.green;
        });
      },
    );
  }
}
