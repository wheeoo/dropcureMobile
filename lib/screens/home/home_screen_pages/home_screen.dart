import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropcure/Theme/colors.dart';
import 'package:dropcure/Theme/url.dart';
import 'package:dropcure/models/order.dart';
import 'package:dropcure/screens/home/widgets/home_screen_order.dart';
import 'package:dropcure/screens/login/widgets/loading_dialog.dart';
import 'package:dropcure/screens/login/widgets/retry_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart'
    as Loc;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:mapbox_geocoding/mapbox_geocoding.dart';
import 'package:mapbox_geocoding/model/forward_geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> points = [];
  var orderLoc;
  String _accessToken =
      "pk.eyJ1IjoiYWJoaXNoYWgzNjQ1IiwiYSI6ImNrOWNsenIzNDA1ZWMzZ3A1d21wNWJ2eTQifQ.WjNsAJAjUeTNWSxE_jQcQQ";
  DateTime now = DateTime.now();
  var _origin;
  var _destination;
  bool isLoaded = false;
  Order order;
  Color color = Colors.blue;
  LocationData userLocation;
  Loc.MapboxNavigation _directions;
  MapController mapController = MapController();
  Location location = new Location();
  getdata() async {
    var locationData = await location.getLocation();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('user_id');
    try {
      Dio dio = Dio();
      URL url = URL();
      FormData userData = new FormData.fromMap({
        "user_id": id,
      });
      Response response =
          await dio.post(url.url + "homepage.php", data: userData);
      if (response.statusCode == 200) {
        var data = json.decode(response.data);
        if (data["status"]) {
          Response directionPoints;
          Order tempOrder = Order.fromJson(data["data"]["order"]);
          var destinationCoords;
          if (tempOrder.orderId != null) {
            try {
              MapboxGeocoding geocoding = MapboxGeocoding(_accessToken);
              ForwardGeocoding forwardModel =
                  await geocoding.forwardModel(tempOrder.customerAddress);
              var a = forwardModel.toJson();
              destinationCoords = a["features"][0]["geometry"]["coordinates"];
            } catch (Excepetion) {
              print("error");
              return 'Forward Geocoding Error';
            }
            directionPoints = await dio.get(
                "https://api.mapbox.com/directions/v5/mapbox/driving/" +
                    locationData.longitude.toString() +
                    "," +
                    locationData.latitude.toString() +
                    ";" +
                    destinationCoords[0].toString() +
                    "," +
                    destinationCoords[1].toString() +
                    "?geometries=geojson&access_token=" +
                    _accessToken);
          }
          setState(() {
            userLocation = locationData;
            _origin = Loc.Location(
                name: "Origin",
                latitude: userLocation.latitude,
                longitude: userLocation.longitude);
            order = tempOrder;
            if (order.orderId == null) {
              order = null;
              points = [];
            } else {
              orderLoc = destinationCoords;
              points =
                  directionPoints.data["routes"][0]["geometry"]["coordinates"];
              _destination = Loc.Location(
                  name: "Destination",
                  latitude: double.parse(orderLoc[1].toString()),
                  longitude: double.parse(orderLoc[0].toString()));
            }
            isLoaded = true;
          });
          if (order != null) {
            location.changeSettings(interval: 5000);
            location.onLocationChanged
                .listen((LocationData currentLocation) async {
              if (mounted) {
                Response response = await getPolylines(currentLocation);
                setState(() {
                  points =
                      response.data["routes"][0]["geometry"]["coordinates"];
                  userLocation = currentLocation;
                  _origin = Loc.Location(
                      name: "Origin",
                      latitude: userLocation.latitude,
                      longitude: userLocation.longitude);
                });
              }
            });
          }
        } else {
          print("not ok");
          print(data);
        }
      } else {
        print("not 200");
      }
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (ctx) {
            return RetryDialog("Something Went Wrong!", getdata);
          },
          barrierDismissible: false);
    }
  }

  Future<Response> getPolylines(currentLocation) async {
    Dio dio = Dio();
    var directionPoints = await dio.get(
        "https://api.mapbox.com/directions/v5/mapbox/driving/" +
            currentLocation.longitude.toString() +
            "," +
            currentLocation.latitude.toString() +
            ";" +
            orderLoc[0].toString() +
            "," +
            orderLoc[1].toString() +
            "?geometries=geojson&access_token=" +
            _accessToken);
    return directionPoints;
  }

  delivered() {
    if (order.noteStatus.toString() == "0") {
      Fluttertoast.showToast(
          msg: "Verify drop number!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    } else {
      updateOrder("complete");
      setState(() {
        color = Colors.green;
      });
    }
  }

  cancelled() {
    updateOrder("cancel");
    setState(() {
      color = Colors.black;
    });
  }

  updateOrder(String action) async {
    String msg;
    action.compareTo("complete") == 0
        ? msg = "Completing Order"
        : msg = "Cancelling Order";
    BuildContext loadContext;
    showDialog(
        context: context,
        builder: (ctx) {
          loadContext = ctx;
          return LoadingDialog(msg);
        });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.get("user_id");
      Dio dio = Dio();
      URL url = URL();
      FormData orderData = new FormData.fromMap(
          {"order_id": order.orderId, "user_id": userId, "type": action});
      Response response =
          await dio.post(url.url + "order_action.php", data: orderData);
      Navigator.pop(loadContext);
      getdata();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    _directions = Loc.MapboxNavigation(onRouteProgress: (arrived) async {
      if (arrived) {
        await Future.delayed(Duration(seconds: 3));
        await _directions.finishNavigation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenHeight = size.height;
    return isLoaded
        ? Stack(
            children: <Widget>[
              Container(
                height: screenHeight,
                child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      interactive: true,
                      center: userLocation != null
                          ? LatLng(
                              userLocation.latitude,
                              userLocation.longitude,
                            )
                          : null,
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
                        },
                      ),
                      PolylineLayerOptions(polylines: [
                        Polyline(
                            points: order != null
                                ? points.map((e) {
                                    return LatLng(e[1], e[0]);
                                  }).toList()
                                : [],
                            strokeWidth: 3.0,
                            color: Colors.red)
                      ]),
                      MarkerLayerOptions(
                        markers: [
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: order != null
                                ? LatLng(
                                    double.parse(orderLoc[1].toString()),
                                    double.parse(orderLoc[0].toString()),
                                  )
                                : null,
                            builder: (ctx) => Container(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: userLocation != null
                                ? LatLng(
                                    userLocation.latitude,
                                    userLocation.longitude,
                                  )
                                : null,
                            builder: (ctx) => Container(
                              child: Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
              order != null
                  ? Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: pinkColor),
                            child: Icon(
                              Icons.navigation,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () async {
                            try {
                              await _directions.startNavigation(
                                origin: _origin,
                                destination: _destination,
                                mode: Loc.NavigationMode.drivingWithTraffic,
                                language: "English",
                                units: Loc.VoiceUnits.metric,
                              );
                            }catch(e){
                              print(e);
                            }
                          },
                        ),
                      ),
                    )
                  : Container(),
              Column(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Container(
                    child: order != null
                        ? Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: HomeScreenOrder(order, getdata),
                            actions: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                child: IconSlideAction(
                                  caption: 'Complete Order',
                                  color: Colors.green,
                                  icon: Icons.check,
                                  onTap: () {
                                    delivered();
                                  },
                                ),
                              ),
                            ],
                            secondaryActions: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: IconSlideAction(
                                  caption: 'Cancel Order',
                                  color: Colors.black,
                                  icon: Icons.close,
                                  onTap: () {
                                    cancelled();
                                  },
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ),
                ],
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
