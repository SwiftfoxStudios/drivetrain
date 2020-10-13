// MATERIAL DESIGN IMPORT
import 'dart:math';

import 'package:flutter/material.dart';

import 'dart:async';

// GMAP FOR ROUTE GENERATION
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
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
          title: Text("DISCOVER",
              style:
                  TextStyle(fontSize: deviceHeight / 20, color: Colors.white)),
          elevation: 0.0,
          actions: <Widget>[
            // SETTINGS ICON
            IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: null,
                iconSize: deviceHeight / 20)
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
                                          bottomLeft:
                                              const Radius.circular(15.0),
                                          bottomRight:
                                              const Radius.circular(15.0),
                                        )),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("GENERATE A ROUTE",
                                              style: TextStyle(
                                                  fontSize: deviceHeight / 28,
                                                  color: Colors.black)),
                                          Container(height: 5),
                                          Text(
                                              "Find new routes using the circular route generator",
                                              style: TextStyle(
                                                  height: 1.2,
                                                  fontSize: deviceHeight / 41,
                                                  color: Colors.black)),
                                        ]),
                                    padding:
                                        EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
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
                                          bottomLeft:
                                              const Radius.circular(15.0),
                                          bottomRight:
                                              const Radius.circular(15.0),
                                        )),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("VIEW SAVED ROUTES",
                                              style: TextStyle(
                                                  fontSize: deviceHeight / 28,
                                                  color: Colors.black)),
                                          Container(height: 5),
                                          Text(
                                              "View and manage the routes you have saved",
                                              style: TextStyle(
                                                  height: 1.2,
                                                  fontSize: deviceHeight / 41,
                                                  color: Colors.black)),
                                        ]),
                                    padding:
                                        EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
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
                                          bottomLeft:
                                              const Radius.circular(15.0),
                                          bottomRight:
                                              const Radius.circular(15.0),
                                        )),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("SEE POPULAR ROUTES",
                                              style: TextStyle(
                                                  fontSize: deviceHeight / 28,
                                                  color: Colors.black)),
                                          Container(height: 5),
                                          Text(
                                              "View the most popular routes according to our users",
                                              style: TextStyle(
                                                  height: 1.2,
                                                  fontSize: deviceHeight / 41,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w100)),
                                        ]),
                                    padding:
                                        EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
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
                                          bottomLeft:
                                              const Radius.circular(15.0),
                                          bottomRight:
                                              const Radius.circular(15.0),
                                        )),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("IMPORT ROUTES",
                                              style: TextStyle(
                                                  fontSize: deviceHeight / 28,
                                                  color: Colors.black)),
                                          Container(height: 5),
                                          Text(
                                              "Import .gpx files into the app to use as routes",
                                              style: TextStyle(
                                                  height: 1.2,
                                                  fontSize: deviceHeight / 41,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w100)),
                                        ]),
                                    padding:
                                        EdgeInsets.fromLTRB(14, 5, 20, 12)))))),
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

  static final CameraPosition initial =
      CameraPosition(target: LatLng(51.453318, -0.102559), zoom: 13);
  Location location = new Location();
  String userAddress;
  List<Marker> markerList = [];

// SETS INITIAL CAMERA POSITION OF GOOGLE MAP
  Future<void> moveCamera() async {
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15)));
  }

  showError() {
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

  placeMarker(LatLng point) {
    print(point);
    setState(() {
      markerList = [];
      HapticFeedback.heavyImpact();
      markerList
          .add(Marker(markerId: MarkerId(point.toString()), position: point));
    });
  }

  findLocation() async {
    final GoogleMapController controller = await _controller.future;

    try {
      List result =
          await gcd.locationFromAddress(userAddress, localeIdentifier: "en");
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(result[0].latitude, result[0].longitude), zoom: 15)));
    } on gcd.NoResultFoundException {
      showError();
    }
  }

  rad2deg(theta) {
    return theta * 180 / pi;
  }

  deg2rad(theta) {
    return theta * pi / 180;
  }

  calculatePoint(lat1, lon1, bearing, distance) {
    double lat1Rad = deg2rad(lat1);
    double lon1Rad = deg2rad(lon1);
    double bearingRad = deg2rad(bearing);
    // 6371.01 is the average radius of Earth in km
    double distRad = distance / 6371.01;
    double rlon;
    double rlat;
    double lat2;
    double lon2;

    rlat = asin(sin(lat1Rad) * cos(distRad) +
        cos(lat1Rad) * sin(distRad) * cos(bearingRad));

    if (cos(rlat) == 0) {
      // To handle returns of North/south poles
      rlon = lon1Rad;
    } else {
      rlon =
          ((lon1Rad - asin(sin(bearingRad) * sin(distRad) / cos(rlat)) + pi) %
                  (2 * pi)) -
              pi;
    }

    lat2 = rad2deg(rlat);
    lon2 = rad2deg(rlon);
    print(lat2.toStringAsFixed(5));
    print(lon2.toStringAsFixed(5));
  }

  @override
  Widget build(BuildContext context) {
    calculatePoint(51, 22, 180, 111.1);
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(bgLight),
        appBar: AppBar(
          backgroundColor: Color(bgDark),
          centerTitle: true,
          title: Text("GENERATE ROUTE",
              style:
                  TextStyle(fontSize: deviceHeight / 30, color: Colors.white)),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Stack(children: <Widget>[
            Container(
                // GOOGLE MAP CONTAINER
                height: deviceHeight - statusHeight - 56,
                child: GoogleMap(
                  markers: Set.from(markerList),
                  initialCameraPosition: initial,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onLongPress: placeMarker,
                )),
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Container(
                height: 55,
                width: double.infinity,
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
            ),
            Positioned(
              top: deviceHeight / 1.8,
              left: 15,
              right: 15,
              child: Container(
                  padding: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(alphaBg),
                  ),
                  height: 200,
                  width: double.infinity,
                  child: Text(
                    "Long press on map to select start/end point",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
            ),
          ])
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
