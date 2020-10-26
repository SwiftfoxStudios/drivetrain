// MATERIAL DESIGN IMPORT
import 'dart:math';
import 'dart:core';

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

// GMAP FOR ROUTE GENERATION
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as gcd;

// COLOURS USED IN PROJECT
const bgDark = 0xff202020;
const bgLight = 0xff2e2e2e;
const accent = 0xffff5d54;
const alphaBg = 0xf1202020;

// MAIN CLASS INSTANTIATION OF PAGE "DISCOVER PAGE"
class DiscoverMain extends StatefulWidget {
  @override
  _DiscoverMainState createState() => _DiscoverMainState();
}

// EXTENSION OF INSTANTIATION
class _DiscoverMainState extends State<DiscoverMain> {
  discoverGenerate() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GenerateRoutePage(),
    ));
  }

  discoverSaved() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SavedRoutePage(),
    ));
  }

  discoverPopular() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PopularRoutePage(),
    ));
  }

  discoverImport() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ImportRoutePage(),
    ));
  }

  // PARENT WIDGET, HOLDS ALL WIDGETS
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        // APPBAR
        appBar: AppBar(
          backgroundColor: Color(bgDark),
          title: Text("DISCOVER", style: TextStyle(fontSize: deviceHeight / 20, color: Colors.white)),
          elevation: 0.0,
          actions: <Widget>[
            // SETTINGS ICON
            IconButton(icon: Icon(Icons.settings, color: Colors.white), onPressed: null, iconSize: deviceHeight / 20)
          ],
        ),
        body: Container(
            // BODY OF BUTTONS
            color: Color(bgLight),
            child: Column(
              children: <Widget>[
                Container(
                  color: Color(bgLight),
                  height: deviceHeight / 40,
                ),
                Container(
                    color: Color(bgLight),
                    height: deviceHeight / 5.4,
                    child: Center(
                        child: Container(
                            child: InkWell(
                                onTap: () {
                                  discoverGenerate();
                                },
                                child: Container(
                                    height: deviceHeight / 6.4,
                                    width: deviceWidth / 100 * 95,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(15.0),
                                          topRight: const Radius.circular(15.0),
                                          bottomLeft: const Radius.circular(15.0),
                                          bottomRight: const Radius.circular(15.0),
                                        )),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                      Text("GENERATE A ROUTE", style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("Find new routes using the circular route generator", style: TextStyle(height: 1.2, fontSize: deviceHeight / 41, color: Colors.black)),
                                    ]),
                                    padding: EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
                Container(
                    color: Color(bgLight),
                    height: deviceHeight / 5.4,
                    child: Center(
                        child: Container(
                            child: InkWell(
                                onTap: () {
                                  discoverSaved();
                                },
                                child: Container(
                                    height: deviceHeight / 6.4,
                                    width: deviceWidth / 100 * 95,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(15.0),
                                          topRight: const Radius.circular(15.0),
                                          bottomLeft: const Radius.circular(15.0),
                                          bottomRight: const Radius.circular(15.0),
                                        )),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                      Text("VIEW SAVED ROUTES", style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("View and manage the routes you have saved", style: TextStyle(height: 1.2, fontSize: deviceHeight / 41, color: Colors.black)),
                                    ]),
                                    padding: EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
                Container(
                    color: Color(bgLight),
                    height: deviceHeight / 5.4,
                    child: Center(
                        child: Container(
                            child: InkWell(
                                onTap: () {
                                  discoverPopular();
                                },
                                child: Container(
                                    height: deviceHeight / 6.4,
                                    width: deviceWidth / 100 * 95,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(15.0),
                                          topRight: const Radius.circular(15.0),
                                          bottomLeft: const Radius.circular(15.0),
                                          bottomRight: const Radius.circular(15.0),
                                        )),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                      Text("SEE POPULAR ROUTES", style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("View the most popular routes according to our users", style: TextStyle(height: 1.2, fontSize: deviceHeight / 41, color: Colors.black, fontWeight: FontWeight.w100)),
                                    ]),
                                    padding: EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
                Container(
                    color: Color(bgLight),
                    height: deviceHeight / 5.4,
                    child: Center(
                        child: Container(
                            child: InkWell(
                                onTap: () {
                                  discoverImport();
                                },
                                child: Container(
                                    height: deviceHeight / 6.4,
                                    width: deviceWidth / 100 * 95,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: new BorderRadius.only(
                                          topLeft: const Radius.circular(15.0),
                                          topRight: const Radius.circular(15.0),
                                          bottomLeft: const Radius.circular(15.0),
                                          bottomRight: const Radius.circular(15.0),
                                        )),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                                      Text("IMPORT ROUTES", style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("Import .gpx files into the app to use as routes", style: TextStyle(height: 1.2, fontSize: deviceHeight / 41, color: Colors.black, fontWeight: FontWeight.w100)),
                                    ]),
                                    padding: EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
              ],
            )));
  }
}

class GenerateRoutePage extends StatefulWidget {
  @override
  _GenerateRoutePageState createState() => _GenerateRoutePageState();
}

class _GenerateRoutePageState extends State<GenerateRoutePage> {
  Completer<GoogleMapController> _controller = Completer();
  // Set initial text of 'distance' on Generate pagee
  TextEditingController initalDistanceController = TextEditingController()..text = '10';

// Initialise polyline data fields
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoords = [];
  Map<PolylineId, Polyline> polylines = {};

  _createPolylines(start, dest) async {
    print("hello");
    /*
        DESC: Creates points to be shown on the map page
        PARAMS: Start pos, Destination pos
        RETURNS: Update list of polyline points
    */
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDIjNLerMn_mn006T9_DLAQuyzuC_8FWiA", // API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(dest.latitude, dest.longitude),
      travelMode: TravelMode.driving,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoords.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    int epoch = DateTime.now().microsecondsSinceEpoch;
    PolylineId id = PolylineId(epoch.toString());

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Color(accent),
      points: polylineCoords,
      width: 5,
    );

    // Adding the polyline to the map
    setState(() {
      polylines[id] = polyline;
    });
  }

  static final CameraPosition initial = CameraPosition(target: LatLng(51.453318, -0.102559), zoom: 13);
  Location location = new Location();
  String userAddress;
  List<Marker> markerList = [];

// SETS INITIAL CAMERA POSITION OF GOOGLE MAP
  Future<void> moveCamera() async {
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15)));
  }

  showLocationError() {
    /*
        DESC: Catches invalid location entered
        PARAMS: null
        RETURNS: Error dialog box
    */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Invalid Location"),
          backgroundColor: Colors.white,
          content: new Text("Sorry, that location could not be found."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              color: Color(accent),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showGeneratorError() {
    /*
        DESC: Catches invalid distance type or length entered
        PARAMS: null
        RETURNS: Error dialog box
    */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Invalid Distance"),
          backgroundColor: Colors.white,
          content: new Text("The distance must be under 1000km."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              color: Color(accent),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  showUnselectedError() {
    /*
        DESC: Catches no start location selected on map
        PARAMS: null
        RETURNS: Error dialog box
    */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Start point not entered"),
          backgroundColor: Colors.white,
          content: new Text("Long press on the map to select a start point."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("CLOSE"),
              color: Color(accent),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  placeMarker(LatLng point) {
    /*
        DESC: Places marker on user click
        PARAMS: Point user clicks on
        RETURNS: Marker on map at position of click
    */
    print(point);
    setState(() {
      markerList = [];
      HapticFeedback.heavyImpact();
      markerList.add(Marker(markerId: MarkerId(point.toString()), position: point));
    });
  }

  findLocation() async {
    /*
        DESC: Attemps to find location user has entered using 'geocoding' library
        PARAMS: null
        RETURNS ON SUCCESS: Move camera to target location
        RETURNS ON FAILURE: Location Error
    */
    final GoogleMapController controller = await _controller.future;

    try {
      List result = await gcd.locationFromAddress(userAddress, localeIdentifier: "en");
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(result[0].latitude, result[0].longitude), zoom: 15)));
    } on gcd.NoResultFoundException {
      showLocationError();
    } on PlatformException {
      showLocationError();
    }
  }

  rad2deg(theta) {
    return theta * 180 / pi;
  }

  deg2rad(theta) {
    return theta * pi / 180;
  }

  List calculatePoint(lat1, lon1, bearing, distance) {
    double lat1Rad = deg2rad(lat1);
    double lon1Rad = deg2rad(lon1);
    double bearingRad = deg2rad(bearing);
    // 6371.01 is the average radius of Earth in km
    double distRad = distance / 6371.01;
    num rlon;
    double rlat;
    double lat2;
    double lon2;

    rlat = asin(sin(lat1Rad) * cos(distRad) + cos(lat1Rad) * sin(distRad) * cos(bearingRad));

    if (cos(rlat) == 0) {
      // To handle returns of North/south poles
      rlon = lon1Rad;
    } else {
      rlon = ((lon1Rad - asin(sin(bearingRad) * sin(distRad) / cos(rlat)) + pi) % (2 * pi)) - pi;
    }

    lat2 = rad2deg(rlat);
    lon2 = rad2deg(rlon);
    return [lat2.toStringAsFixed(5), lon2.toStringAsFixed(5)];
  }

  generateCircularRoute() {
    String userDistanceInputRaw = initalDistanceController.text;
    num userDistanceInput;
    try {
      userDistanceInput = num.parse(userDistanceInputRaw);
      if (userDistanceInput > 1000) {
        showGeneratorError();
      }
      try {
        String startingLocation = markerList[0].markerId.value;
        // turns string into latlng directly by removing 'latlng()'
        startingLocation = startingLocation.substring(7, startingLocation.length - 1);
        List<String> startingLocationList = startingLocation.split(",");
        List centralPoint = [startingLocationList[0].toString(), startingLocationList[1].toString()];
        // List centralPoint = calculatePoint(double.parse(startingLocationList[0]), double.parse(startingLocationList[1]), 360 * 1 / 16, userDistanceInput / 2 * pi);

        String centralLat = centralPoint[0];
        num numCentralLat = num.parse(centralLat);
        String centralLon = centralPoint[1];
        num numCentralLon = num.parse(centralLon);

        List oldPoint = calculatePoint(numCentralLat, numCentralLon, 360 * 1 / 16, userDistanceInput / (2 * pi));
        List newPoint;
        LatLng setDestinationPoint;
        LatLng setOriginPoint = LatLng(double.parse(oldPoint[0]), double.parse(oldPoint[1]));
        for (var i = 2; i <= 16; i++) {
          newPoint = calculatePoint(numCentralLat, numCentralLon, 360 * i / 16, userDistanceInput / (2 * pi));
          setDestinationPoint = LatLng(double.parse(oldPoint[0]), double.parse(oldPoint[1]));
          print(i);
          _createPolylines(setOriginPoint, setDestinationPoint);
          print(polylines);

          oldPoint = newPoint;
        }
      } on RangeError {
        showUnselectedError();
      }
    } on FormatException {
      showGeneratorError();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(bgLight),
        appBar: AppBar(
          backgroundColor: Color(bgDark),
          centerTitle: true,
          title: Text("GENERATE ROUTE", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white)),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(height: deviceWidth / 20),
          Container(
            height: 55,
            width: deviceWidth / 100 * 95,
            child: TextField(
              // expands: true,
              onSubmitted: (value) {
                findLocation();
              },
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: "Search Address or Location",
                  hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 16),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    color: Color(accent),
                    onPressed: findLocation,
                    iconSize: 40,
                  )),
              onChanged: (value) {
                setState(() {
                  userAddress = value;
                });
              },
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(alphaBg),
            ),
          ),
          Container(height: deviceWidth / 20),
          Container(
            padding: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(alphaBg),
            ),
            height: 100,
            width: deviceWidth / 100 * 95,
            child: Column(children: [
              Text(
                "Long press on map to select start/end point",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Container(width: 20),
                  Container(child: Text("Distance:", style: TextStyle(fontSize: 16, color: Color(accent)))),
                  Container(
                      width: 52,
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          controller: initalDistanceController,
                          autocorrect: true,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 16, color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(accent)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ))),
                  Container(
                      child: Text("km",
                          // REMEMBER TO CHANGE IF UNITS SETTINGS EXIST
                          style: TextStyle(fontSize: 16, color: Color(accent)))),
                  Container(width: 100),
                  FlatButton(
                    child: Text("GENERATE!"),
                    onPressed: () {
                      generateCircularRoute();
                    },
                    color: Color(accent),
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.green,
                  )
                ],
              )
            ]),
          ),
          Container(height: deviceWidth / 20),
          Container(
            // GOOGLE MAP CONTAINER
            height: deviceHeight - deviceWidth / 20 * 3 - 100 - 56 - statusHeight - 56,
            child: GoogleMap(
              markers: Set.from(markerList),
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: initial,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // _createPolylines(LatLng(51.453318, -0.102559), LatLng(52.453318, -0.102559));
              },
              onLongPress: placeMarker,
            ),
          ),
        ])));
  }
}

class SavedRoutePage extends StatefulWidget {
  @override
  _SavedRoutePageState createState() => _SavedRoutePageState();
}

class _SavedRoutePageState extends State<SavedRoutePage> {
  _SavedRoutePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.orange);
  }
}

class PopularRoutePage extends StatefulWidget {
  @override
  _PopularRoutePageState createState() => _PopularRoutePageState();
}

class _PopularRoutePageState extends State<PopularRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.lightGreen);
  }
}

class ImportRoutePage extends StatefulWidget {
  @override
  _ImportRoutePageState createState() => _ImportRoutePageState();
}

class _ImportRoutePageState extends State<ImportRoutePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.cyan);
  }
}
