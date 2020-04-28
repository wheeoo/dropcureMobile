import 'package:flutter/material.dart';

class DeliveryCountWidget extends StatelessWidget {
  int completedDeliveries, openDeliveries, canceldeliveries;
  DeliveryCountWidget(
      this.completedDeliveries, this.openDeliveries, this.canceldeliveries);
  @override
  Widget build(BuildContext context) {
    int totalDeliveries =
        completedDeliveries + openDeliveries + canceldeliveries;
    TextStyle deliveryDataStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 34);
    TextStyle deliveryLabelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              totalDeliveries.toString(),
              style: deliveryDataStyle,
            ),
            Text(
              "Deliveries",
              style: deliveryLabelStyle,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              completedDeliveries.toString(),
              style: deliveryDataStyle,
            ),
            Text(
              "Completed",
              style: deliveryLabelStyle,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text(
              openDeliveries.toString(),
              style: deliveryDataStyle,
            ),
            Text(
              "Open",
              style: deliveryLabelStyle,
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Text(canceldeliveries.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: Colors.red)),
            Text(
              "Cancel",
              style: deliveryLabelStyle,
            ),
          ],
        ),
      ],
    );
  }
}
