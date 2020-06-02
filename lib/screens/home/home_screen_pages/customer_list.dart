import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/models/order.dart';
import 'package:dropcure/models/order_status.dart';
import 'package:dropcure/screens/home/widgets/change_status_alert.dart';
import 'package:dropcure/screens/home/widgets/delivery_count_widget.dart';
import 'package:dropcure/screens/home/widgets/info_card.dart';
import 'package:dropcure/screens/login/widgets/retry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<Order> orders;
  bool isLoaded = false;
  bool ordersPresent = false;
  DateTime now = DateTime.now();
  Map<String, dynamic> deliveries = {};

  getOrders() async {
    print("get orders called");
    deliveries = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('user_id');
    try {
      Dio dio = Dio();
      URL url = URL();
      FormData userData = new FormData.fromMap({
        "user_id": id,
      });
      Response response =
          await dio.post(url.url + "get_all_order.php", data: userData);
      Map<String, dynamic> data = json.decode(response.data);
      print("ORDERS------------------------");
      print(data);
      OrderStatus order = OrderStatus.fromRawJson(response.data);

      if (order.status) {
        setState(() {
          deliveries.putIfAbsent("completedDeliveries",
              () => data["data"]["order_count"]["complete"]);
          deliveries.putIfAbsent(
              "openDeliveries", () => data["data"]["order_count"]["open"]);
          deliveries.putIfAbsent("cancelledDeliveries",
              () => data["data"]["order_count"]["cancel"]);
          deliveries.putIfAbsent("totalDeliveries",
              () => data["data"]["order_count"]["deliveries"]);
          orders = order.data;
          if (orders.length < 1) {
            ordersPresent = false;
          } else {
            ordersPresent = true;
          }
          isLoaded = true;
        });
      } else {
        setState(() {
          if (data["data"].length > 0) {
            deliveries.putIfAbsent("completedDeliveries",
                () => data["data"]["order_count"]["complete"]);
            deliveries.putIfAbsent(
                "openDeliveries", () => data["data"]["order_count"]["open"]);
            deliveries.putIfAbsent("cancelledDeliveries",
                () => data["data"]["order_count"]["cancel"]);
            deliveries.putIfAbsent("totalDeliveries",
                () => data["data"]["order_count"]["deliveries"]);
            print(deliveries);
          }
          ordersPresent = false;
          isLoaded = true;
        });
      }
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (ctx) {
            return RetryDialog("Something Went Wrong!", getOrders);
          },
          barrierDismissible: false);
    }
  }

  changeStatus(action, index) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.get("user_id");
      Dio dio = Dio();
      URL url = URL();
      FormData orderData = new FormData.fromMap({
        "order_id": orders[index].orderId,
        "user_id": userId,
        "type": action
      });
      Response response =
          await dio.post(url.url + "order_action.php", data: orderData);
      getOrders();
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  changeOrderStatus(index) {
    String msg = "";
    if (orders[index].orderStatus.toString().compareTo("1") == 0) {
      msg = "cancel";
    } else if (orders[index].orderStatus.toString().compareTo("3") == 0) {
      msg = "complete";
    } else {
      return;
    }
    showDialog(
        context: context,
        builder: (_) {
          return ChangeStatusAlert(msg, changeStatus, index);
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEEE, MMMM d yyyy').format(now);
    var size = MediaQuery.of(context).size;
    var screenWidth = size.width;
    int c = 0;
    return isLoaded
        ? Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.only(top: 5, bottom: 20),
                  width: screenWidth,
                  color: Colors.white,
                  child: Center(
                      child: Text(
                    currentDate,
                    style: TextStyle(fontSize: 16),
                  ))),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: DeliveryCountWidget(
                    deliveries["totalDeliveries"] ??= 0,
                    deliveries["completedDeliveries"] ??= 0,
                    deliveries["openDeliveries"] ??= 0,
                    deliveries["cancelledDeliveries"] ??= 0),
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ordersPresent
                    ? ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (ctx, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: GestureDetector(
                              child:
                                  InfoCard(orders[index], index + 1, getOrders),
                              onTap: () {
                                changeOrderStatus(index);
                              },
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No orders completed yet",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(pinkColor),
            ),
          );
  }
}
