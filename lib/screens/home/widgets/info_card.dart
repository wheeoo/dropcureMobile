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
              widget.counter.toString().length == 1
                  ? "0" + widget.counter.toString()
                  : widget.counter.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/alt.jpeg",
                    image: widget.order.userImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) {
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
                  Text(
                    widget.order.orderId,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      children: <Widget>[
                        Text(
                          widget.order.city + ", ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.order.state,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      widget.order.zipCode,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      widget.order.date,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 30,
              width: 30,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: getColor()),
            ),
          ),
        ],
      ),
    );
  }
}
