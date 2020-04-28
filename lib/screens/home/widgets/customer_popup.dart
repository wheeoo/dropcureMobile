import 'package:dropcure/Theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerPopup extends StatefulWidget {
  @override
  _CustomerPopupState createState() => _CustomerPopupState();
}

class _CustomerPopupState extends State<CustomerPopup> {
  TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      scrollable: true,
      contentPadding: EdgeInsets.all(0),
      content: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
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
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage("assets/images/photo.jpg"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Nancy Rodriquez",
                        style: labelStyle,
                      ),
                      Text(
                        "3210 East Dally Avenue\nLos Angeles, Ca 90222",
                      ),
                      Text(
                        "Order: JBO982032",
                        style: labelStyle,
                      ),
                    ],
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
                        String url = "tel:7359644374";
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
                                    borderRadius: BorderRadius.circular(8))
//                            OutlineInputBorder(
//                                gapPadding: 0,
//                                borderRadius: BorderRadius.circular(8),
//                                borderSide: BorderSide.none),
                                ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 30,
                        )
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
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Text or Special note here!",
                      hintStyle:
                          TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
                      border: InputBorder.none,
                      suffixIcon: GestureDetector(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                          size: 30,
                        ),
                        onTap: () {},
                      )),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*


 */
