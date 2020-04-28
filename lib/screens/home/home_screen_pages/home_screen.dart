import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:dropcure/screens/home/widgets/delivery_count_widget.dart';
import 'package:dropcure/screens/home/widgets/info_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _accessToken =
      "pk.eyJ1IjoiYWJoaXNoYWgzNjQ1IiwiYSI6ImNrOWNsenIzNDA1ZWMzZ3A1d21wNWJ2eTQifQ.WjNsAJAjUeTNWSxE_jQcQQ";
  DateTime now = DateTime.now();
  int completedDeliveries = 28;
  int openDeliveries = 15;
  int cancelledDeliveries = 2;

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEEE, MMMM d yyyy').format(now);
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    var screenWidth = size.width;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: screenHeight * 0.50,
            child: Card(
              child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(
                      22.307159,
                      73.181221,
                    ),
                    zoom: 13.0,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                            "https://api.mapbox.com/styles/v1/abhishah3645/ck9cq9fey04jd1ipjbb0wy8wi/tiles/256/{z}/{x}/{y}@2x?access_token=" +
                                _accessToken,
                        additionalOptions: {
                          'accessToken': _accessToken,
                          'id': 'mapbox.mapbox-streets-v8'
                        }),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: LatLng(
                            22.307159,
                            73.181221,
                          ),
                          builder: (ctx) => Container(
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  currentDate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: DeliveryCountWidget(completedDeliveries,
                      openDeliveries, cancelledDeliveries)),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: InfoCard("JB0982032", "Torrence 90422", Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
