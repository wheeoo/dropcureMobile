import 'package:dropcure/screens/home/widgets/info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  List<Map<String, dynamic>> customers = [
    {
      "id": "abcd",
      "address": "sad asd",
      "color": Colors.white,
    },
    {
      "id": "abcd",
      "address": "sad asd",
      "color": Colors.white,
    },
    {
      "id": "abcd",
      "address": "sad asd",
      "color": Colors.white,
    },
    {
      "id": "abcd",
      "address": "sad asd",
      "color": Colors.white,
    },
    {
      "id": "abcd",
      "address": "sad asd",
      "color": Colors.white,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: customers.length,
      itemBuilder: (ctx, index) {
        return Container(
          padding: EdgeInsets.all(10),
            child: InfoCard(customers[index]["id"], customers[index]["address"],
                customers[index]["color"]),
        );
      },
    );
  }
}
