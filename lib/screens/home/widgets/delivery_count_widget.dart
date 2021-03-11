import 'package:dropcure/Theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeliveryCountWidget extends StatelessWidget {
  final int completedDeliveries,
      openDeliveries,
      canceledDeliveries,
      totalDeliveries;
  final bool isClickable;
  final Function onClick;
  final int selected;
  final bool small;
  DeliveryCountWidget(this.totalDeliveries, this.completedDeliveries,
      this.openDeliveries, this.canceledDeliveries,
      {this.isClickable = false,
      this.onClick,
      this.selected,
      this.small = false});
  @override
  Widget build(BuildContext context) {
    TextStyle deliveryDataStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: small ? 28 : 34);
    TextStyle deliveryLabelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: small ? 13 : 16,
    );
    return IgnorePointer(
      ignoring: !isClickable,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: isClickable
                  ? Stack(
                      children: [
                        Container(
                          decoration: selected == -1
                              ? BoxDecoration(
                                  color: infoCardBg,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          // padding: selected == -1 ? EdgeInsets.all(15) : null,
                          height: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                          width: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
              onTap: () {
                onClick(-1);
              },
            ),
            GestureDetector(
              child: isClickable
                  ? Stack(
                      children: [
                        Container(
                          decoration: selected == 1
                              ? BoxDecoration(
                                  color: infoCardBg,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          // padding: selected == -1 ? EdgeInsets.all(15) : null,
                          height: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                          width: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
              onTap: () {
                onClick(1);
              },
            ),
            GestureDetector(
              child: isClickable
                  ? Stack(
                      children: [
                        Container(
                          decoration: selected == 0
                              ? BoxDecoration(
                                  color: infoCardBg,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          // padding: selected == -1 ? EdgeInsets.all(15) : null,
                          height: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                          width: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
              onTap: () {
                onClick(0);
              },
            ),
            GestureDetector(
              child: isClickable
                  ? Stack(
                      children: [
                        Container(
                          decoration: selected == 2
                              ? BoxDecoration(
                                  color: infoCardBg,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          // padding: selected == -1 ? EdgeInsets.all(15) : null,
                          height: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                          width: small
                              ? MediaQuery.of(context).size.width / 5
                              : MediaQuery.of(context).size.width / 4,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(canceledDeliveries.toString(),
                                    style: deliveryDataStyle.copyWith(
                                        color: Colors.red)),
                                Text(
                                  "Cancel",
                                  style: deliveryLabelStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(canceledDeliveries.toString(),
                            style:
                                deliveryDataStyle.copyWith(color: Colors.red)),
                        Text(
                          "Cancel",
                          style: deliveryLabelStyle,
                        ),
                      ],
                    ),
              onTap: () {
                onClick(2);
              },
            ),
          ],
        ),
      ),
    );
  }
}
