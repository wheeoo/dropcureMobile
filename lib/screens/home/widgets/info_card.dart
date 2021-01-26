import 'package:dropcure/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'customer_popup.dart';

class InfoCard extends StatefulWidget {
  final Order order;
  final int counter;
  Function getOrders;
  InfoCard(this.order, this.counter, this.getOrders);
  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  Color getColor() {
    Color circleColor;
    switch (widget.order.orderStatus.toString()) {
      case "0":
        circleColor = Colors.blue;
        break;
      case "1":
        circleColor = Colors.green;
        break;
      case "2":
        circleColor = Colors.red;
        break;
      case "3":
        circleColor = Colors.black;
        break;
    }
    return circleColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.counter.toString().padLeft(2, "0"),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          GestureDetector(
            child: Container(
              height: 70,
              width: 70,
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/images/alt.jpeg",
                  image: widget.order.userImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    print(widget.order.noteStatus);
                    return CustomerPopup(widget.order, widget.getOrders, false);
                  });
            },
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.order.orderId,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "Location",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.order.city + ", ",
                      ),
                      Text(
                        widget.order.state,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      widget.order.zipCode,
                    ),
                  ),
                  Text(
                    getColor() == Colors.green
                        ? "Delivered"
                        : getColor() == Colors.blue
                            ? "Open"
                            : "Cancelled",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  FittedBox(
                    child: Text(
                      widget.order.date,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 40,
              width: 40,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: getColor()),
            ),
          ),
        ],
      ),
    );
  }
}
