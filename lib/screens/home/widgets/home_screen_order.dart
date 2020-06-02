import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/models/order.dart';
import 'package:flutter/material.dart';

import 'customer_popup.dart';

class HomeScreenOrder extends StatefulWidget {
  final Order order;
  Function getData;
  HomeScreenOrder(this.order, this.getData);

  @override
  _HomeScreenOrderState createState() => _HomeScreenOrderState();
}

class _HomeScreenOrderState extends State<HomeScreenOrder> {
  @override
  Widget build(BuildContext context) {
    print(widget.order.userImage);
    return Container(
      margin: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        children: <Widget>[
          Container(
            height: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: pinkColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  height: 60,
                  width: 60,
                  margin: EdgeInsets.all(10),
                  child: Card(
                    elevation: 0.0,
//                    color: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/alt.jpeg",
                        image: widget.order.userImage,
                        fit: BoxFit.cover,
                      ),
//                      Image.network(
//                        widget.order.userImage,
//                        fit: BoxFit.cover,
//                      ),
                    ),
                  ),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return CustomerPopup(
                            widget.order, widget.getData, true);
                      });
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.order.orderId,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
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
                  Text(
                    widget.order.zipCode,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                height: 30,
                width: 30,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
