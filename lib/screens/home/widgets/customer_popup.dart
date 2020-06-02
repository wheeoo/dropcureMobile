import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/models/order.dart';
import 'package:dropcure/screens/login/widgets/loading_dialog.dart';
import 'package:dropcure/screens/login/widgets/retry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slider_button/slider_button.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerPopup extends StatefulWidget {
  final Order order;
  Function getOrders;
  bool submit;
  CustomerPopup(this.order, this.getOrders, this.submit);
  @override
  _CustomerPopupState createState() => _CustomerPopupState();
}

class _CustomerPopupState extends State<CustomerPopup> {
  TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold);
  TextEditingController dropNoController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool isEditable = true;

  updateOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('user_id');
    BuildContext loadContext;
    showDialog(
        context: context,
        builder: (ctx) {
          loadContext = ctx;
          return LoadingDialog("Please wait..");
        },
        barrierDismissible: false);
    try {
      var dropNo = dropNoController.text.trim();
      var note = noteController.text.trim();
      Dio dio = Dio();
      URL url = URL();
      var dropData = FormData.fromMap({
        "order_id": widget.order.orderId,
        "user_id": id,
        "drop_no": dropNo.trim(),
        "note": note.trim(),
      });
      Response response =
          await dio.post(url.url + "add_description.php", data: dropData);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.data);
        if (responseData["status"]) {
          Navigator.of(loadContext).pop();
          Navigator.of(context).pop();
          widget.getOrders();
          Fluttertoast.showToast(
              msg: responseData["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        } else {
          Navigator.of(loadContext).pop();
          Fluttertoast.showToast(
              msg: "Failed Updating\n" + responseData["message"],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              fontSize: 16.0);
        }
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      Navigator.of(loadContext).pop();
      showDialog(
          context: context,
          builder: (ctx) {
            return RetryDialog("Something Went Wrong!", updateOrder);
          },
          barrierDismissible: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.order.noteStatus.toString() == "0") {
      isEditable = true;
    } else {
      dropNoController.text = widget.order.dropNo ?? "";
      noteController.text = widget.order.notes ?? "";
      isEditable = false;
    }
    if (!widget.submit) {
      isEditable = false;
      dropNoController.text = widget.order.dropNo ?? "";
      noteController.text = widget.order.notes ?? "";
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      scrollable: true,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              lightPinkColor,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                  Navigator.of(context).pop();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/alt.jpeg",
                    image: widget.order.userImage,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.order.customerName,
                        style: labelStyle,
                      ),
                      Text(
                        widget.order.customerAddress,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Order: ",
                            style: labelStyle,
                          ),
                          Text(
                            widget.order.orderId,
                            style: labelStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 5, top: 5, bottom: 5),
                  child: GestureDetector(
                    child: Image.asset(
                      "assets/images/phone.png",
                      height: 50,
                      width: 50,
                    ),
                    onTap: () async {
                      String url = "tel:" + widget.order.phoneNumber;
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        print('Could not launch $url');
                      }
                    },
                  ),
                )
              ],
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.only(top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 132, 215, 1),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FittedBox(
                    child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Drop No  ",
                          style: labelStyle,
                        ),
                        Container(
                          width: 150,
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: lightPinkColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            controller: dropNoController,
                            enabled: isEditable,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(color: lightPinkColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Enter Text or Special note here!",
                    hintStyle:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                    border: InputBorder.none,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: noteController,
                  enabled: isEditable,
                ),
              ),
            ),
            isEditable && widget.submit
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: SliderButton(
                      dismissible: false,
                      vibrationFlag: false,
                      action: () {
                        updateOrder();
                      },
                      label: Text(
                        "Slide to Submit",
                        style: TextStyle(color: pinkColor),
                      ),
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      backgroundColor: lightPinkColor,
                      buttonColor: pinkColor,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
