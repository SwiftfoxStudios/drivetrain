// MAIN DART PARENT IMPORT
import 'dart:async';
import 'dart:math';

// FILE DEPENDENCIES
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// COLOURS USED IN PROJECT
const bgDark = 0xff202020;
const bgLight = 0xff2e2e2e;
const accent = 0xffff5d54;

// MAIN CLASS INSTANTIATION OF PAGE "RECORD PAGE"
class RecordMain extends StatefulWidget {
  @override
  _RecordMainState createState() => _RecordMainState();
}

// EXTENSION OF INSTANTIATION
class _RecordMainState extends State<RecordMain> {
  Completer<GoogleMapController> _controller = Completer();

  Location location = Location();
  int _selectedIndex = 1;
  bool isSwitched = false;

// SETS INITIAL PAGE OF NAVIGATION BAR
  void navigatePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  recordActivity() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Recording(travelType: isSwitched),
    ));
  }

// SETS INITIAL CAMERA POSITION OF GOOGLE MAP
  Future<void> moveCamera() async {
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15)));
  }

  // timerCounter() async {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     moveCamera();
  //   });
  // }

  static final CameraPosition initial = CameraPosition(target: LatLng(51.453318, -0.102559), zoom: 16);

  // PARENT WIDGET, HOLDS ALL WIDGETS
  Widget build(BuildContext context) {
    moveCamera();
    // timerCounter();
    // DEVICE DIMENSIONS FOR DEVICE-SPECIFIC MEASUREMENTS
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      // PARENT APP BAR
      appBar: AppBar(
        backgroundColor: Color(bgDark),
        title: Text("RECORD", style: TextStyle(fontSize: deviceHeight / 20, color: Colors.white)),
        elevation: 0.0,
        actions: <Widget>[
          // SETTINGS ICON
          IconButton(icon: Icon(Icons.settings, color: Colors.white), onPressed: null, iconSize: deviceHeight / 20)
        ],
      ),
      // PAGE BODY
      body: Column(children: <Widget>[
        Container(
            // GOOGLE MAP CONTAINER
            height: deviceHeight / 2,
            child: GoogleMap(
              initialCameraPosition: initial,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )),
        Stack(children: <Widget>[
          Container(
            // PARENT CONTAINER
            decoration: new BoxDecoration(color: Color(bgDark), borderRadius: new BorderRadius.only(topLeft: const Radius.circular(15.0), topRight: const Radius.circular(15.0))),
            height: deviceHeight / 2 - (56 + statusHeight) - deviceHeight / 10,
          ),
          Container(
            // BREAKPOINT FOR SOME BULLSHIT I CANT FUCKING REMEMBER
            // too bad !
            height: deviceHeight / 18,
            decoration: new BoxDecoration(color: Color(bgDark), borderRadius: new BorderRadius.only(topLeft: const Radius.circular(0.0), topRight: const Radius.circular(0.0))),
          ),
          Positioned.fill(
            top: deviceHeight / 18,
            bottom: 0,
            child: Container(
                // CONTAINER FOR MAIN UI
                color: Color(bgLight),
                height: deviceHeight / 1,
                width: deviceWidth,
                child: Column(children: <Widget>[
                  // BREAKPOINT
                  Container(height: deviceHeight / 25),
                  Center(
                      child: Row(
                    // TOGGLE SWITCH UI
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.directions_bike, color: Colors.white),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                          });
                        },
                        inactiveTrackColor: Colors.white,
                        inactiveThumbColor: Color(accent),
                        activeTrackColor: Colors.white,
                        activeColor: Color(accent),
                      ),
                      Icon(Icons.directions_run, color: Colors.white)
                    ],
                  )),
                  Center(
                    // START RECORDING BUTTON
                    child: FlatButton(
                      child: Text("START RECORDING"),
                      onPressed: () {
                        recordActivity();
                      },
                      color: Color(accent),
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      splashColor: Colors.grey,
                    ),
                  )
                ])),
          )
        ]),
      ]),
    );
  }
}

class Recording extends StatefulWidget {
  final bool travelType;
  Recording({this.travelType});

  @override
  _RecordingState createState() => _RecordingState(travelType);
}

class _RecordingState extends State<Recording> {
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription locationSubscription;
  Location location = Location();
  bool travelType;
  Color testVal;
  FlutterLocalNotificationsPlugin notifPlugin;

  var clock = Stopwatch();
  final duration = const Duration(seconds: 1);
  String displayTime = "0:00";
  String displayDistance = "0.0";
  bool clockIsPaused = true;
  Icon isPaused;
  bool started = false;
  double cachedLat;
  double cachedLon;
  double journeyDistance = 0;
  double cachedDistance = 0;

  final Set<Polyline> polyline = {};
  List<LatLng> visitedPoints = [];
  bool selected = false;

  static final CameraPosition initial = CameraPosition(target: LatLng(51.453318, -0.102559), zoom: 16);
  _RecordingState(this.travelType);

  void parseType() {
    if (travelType) {
      testVal = Colors.green;
    } else {
      testVal = Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  Future<void> moveCamera() async {
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15)));
  }

  void checkPaused() {
    if (clockIsPaused) {
      isPaused = Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 35.0,
      );
    } else {
      isPaused = Icon(
        Icons.pause,
        color: Colors.white,
        size: 35.0,
      );
    }
  }

  void startClock() {
    clockIsPaused = false;
    Timer(duration, iterateClock);
  }

  void pauseClock() {
    clockIsPaused = true;
  }

  void iterateClock() {
    if (clock.isRunning) {
      startClock();
    }
    int elapsedHours = clock.elapsed.inHours;
    int elapsedMinutes = clock.elapsed.inMinutes % 60;
    int elapsedSeconds = clock.elapsed.inSeconds % 60;
    setState(() {
      if (elapsedHours == 0) {
        displayTime = elapsedMinutes.toString() + ":" + elapsedSeconds.toString().padLeft(2, "0");
      } else {
        displayTime = elapsedHours.toString() + ":" + elapsedMinutes.toString().padLeft(2, "0") + ":" + elapsedSeconds.toString().padLeft(2, "0");
      }
    });
  }

  void startListening() async {
    location.changeSettings(distanceFilter: 5, accuracy: LocationAccuracy.high);
    locationSubscription = location.onLocationChanged.listen((LocationData positionUpdate) {
      updatePosition(positionUpdate.latitude, positionUpdate.longitude);
    });
  }

  void stopListening() {
    print("hello");
    locationSubscription.cancel();
  }

  updatePosition(double finalLat, double finalLon) async {
    print(visitedPoints);
    double initialLat;
    double initialLon;
    if (!started) {
      var initialPosition = await location.getLocation();
      initialLat = initialPosition.latitude;
      initialLon = initialPosition.longitude;
      setState(() {
        visitedPoints.add(LatLng(initialPosition.latitude, initialPosition.longitude));
      });
      started = true;
    } else {
      initialLat = cachedLat;
      initialLon = cachedLon;
      setState(() {
        visitedPoints.add(LatLng(cachedLat, cachedLon));
      });
    }
    cachedDistance = calculateDistance(initialLat, initialLon, finalLat, finalLon);
    journeyDistance += cachedDistance;
    print(journeyDistance.round());
    setState(() {
      displayDistance = (journeyDistance.round() / 1000).toStringAsFixed(2);
    });
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    cachedLat = lat2;
    cachedLon = lon2;
    // HAVERSINE FORMULA
    const double earthRadius = 6371e3;
    double lat1rad = lat1 * pi / 180;
    double lat2rad = lat2 * pi / 180;

    double deltaLat = (lat2 - lat1) * pi / 180;
    double deltaLon = (lon2 - lon1) * pi / 180;

    double angle = sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1rad) * cos(lat2rad) * sin(deltaLon / 2) * sin(deltaLon / 2);

    double angularDistance = 2 * atan2(sqrt(angle), sqrt(1 - angle));
    double returnedDistance = earthRadius * angularDistance;
    return returnedDistance;
    // Returned value is in metres
  }

  Future<bool> showReturnError() {
    /*
        DESC: Catches user pressing back button
        PARAMS: null
        RETURNS: Error dialog box
    */
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you sure you want to exit?"),
          backgroundColor: Colors.white,
          content: new Text("This will cancel your route and all progress you've made."),
          actions: <Widget>[
            FlatButton(
              child: new Text("NO"),
              color: Color(accent),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: new Text("YES, EXIT"),
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }

  void addPoly() {
    PolylineId id = PolylineId("test");
    setState(() {
      polyline.add(Polyline(polylineId: id, points: visitedPoints, width: 5, color: Color(accent)));
    });
  }

  Widget build(BuildContext context) {
    parseType();
    checkPaused();
    moveCamera();
    addPoly();
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
        onWillPop: showReturnError,
        child: Scaffold(
          // PARENT APP BAR
          // PAGE BODY
          body: Column(children: <Widget>[
            Container(height: statusHeight),
            AnimatedContainer(
                duration: Duration(milliseconds: 200),
                // GOOGLE MAP CONTAINER
                height: selected ? 200 : deviceHeight / 1.4,
                child: GoogleMap(
                    initialCameraPosition: initial,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    polylines: polyline)),
            Stack(children: <Widget>[
              AnimatedContainer(
                // BREAKPOINT FOR SOME BULLSHIT I CANT FUCKING REMEMBER
                // too bad !
                duration: Duration(milliseconds: 200),
                height: !selected ? deviceHeight - deviceHeight / 1.4 - statusHeight : deviceHeight - statusHeight - 200,
                decoration: new BoxDecoration(color: Color(bgDark)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text(displayDistance, style: TextStyle(fontSize: deviceHeight / 16, color: Colors.white)), Text(displayTime, style: TextStyle(fontSize: deviceHeight / 16, color: Colors.white))]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [Text("KM", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white)), Text("TIME", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white))]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              selected = !selected;
                            });
                            if (clockIsPaused) {
                              startListening();

                              clock.start();
                              startClock();
                            } else {
                              stopListening();
                              clock.stop();
                              pauseClock();
                            }
                          },
                          elevation: 2.0,
                          fillColor: Color(accent),
                          child: isPaused,
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                        RawMaterialButton(
                          onPressed: () {},
                          elevation: 2.0,
                          fillColor: Colors.white,
                          child: Icon(
                            Icons.fullscreen,
                            color: Colors.black,
                            size: 35.0,
                          ),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ]),
        ));
  }
}
