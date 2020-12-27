// MAIN DART PARENT IMPORT
import 'dart:async';
import 'dart:math';

// FILE DEPENDENCIES
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

import 'package:gpx/gpx.dart';

import '../activityClass.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

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
  int _isFullScreenIndex = 1;
  bool routeTypeisSwitched = false;

// SETS INITIAL PAGE OF NAVIGATION BAR
  void navigatePage(int index) {
    setState(() {
      _isFullScreenIndex = index;
    });
  }

  recordActivity() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Recording(travelType: routeTypeisSwitched),
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
                        value: routeTypeisSwitched,
                        onChanged: (value) {
                          setState(() {
                            routeTypeisSwitched = value;
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

  var clock = Stopwatch();
  final duration = const Duration(seconds: 1);
  String displayTime = "0:00";
  int displayTimeInSeconds = 0;
  String displayDistance = "0.3";
  String displayVelocity = "0.0";
  String displayAverageVelocity = "0.0";
  String displayIncline = "0";
  String displayPower = "0";
  double riderMass = 57;
  double bikeMass = 10.9;
  bool clockIsPaused = true;
  Icon isPaused;
  bool started = false;
  double cachedLat;
  double cachedLon;
  double journeyDistance = 0;
  double cachedDistance = 0;

  final Set<Polyline> polyline = {};
  List<LatLng> visitedPoints = [];
  bool isFullScreen = false;
  Icon isFullScreenWidget;
  final gpx = Gpx();
  List<Wpt> listOfGPXPoints;

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
    locationSubscription?.cancel();
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

  void checkifFullScreen() {
    if (!isFullScreen) {
      isFullScreenWidget = Icon(
        Icons.fullscreen,
        color: Colors.black,
        size: 35.0,
      );
    } else {
      isFullScreenWidget = Icon(
        Icons.fullscreen_exit,
        color: Colors.black,
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
      displayTimeInSeconds = clock.elapsed.inSeconds;
    });
    print(displayTimeInSeconds);
  }

  void startListening() async {
    gpx.metadata = Metadata(name: DateTime.now().millisecondsSinceEpoch.toString(), time: DateTime.now());
    location.changeSettings(distanceFilter: 10, accuracy: LocationAccuracy.high);
    locationSubscription = location.onLocationChanged.listen((LocationData positionUpdate) {
      updatePosition(positionUpdate.latitude, positionUpdate.longitude, positionUpdate.altitude);
      updateVelocity(positionUpdate.speed);
      updateAverageVelocity(displayDistance, displayTimeInSeconds);
    });
  }

  void stopListening() {
    print("hello");
    locationSubscription.cancel();
  }

  void updatePosition(double finalLat, double finalLon, double finalAltitude) async {
    print(visitedPoints);
    double initialLat;
    double initialLon;
    LatLng startPoint;
    LatLng finalPoint = LatLng(finalLat, finalLon);
    double startAltitude;
    if (started == false) {
      await location.getLocation().then((onValue) {
        initialLat = onValue.latitude;
        initialLon = onValue.longitude;
        startAltitude = onValue.altitude;
      });
      startPoint = LatLng(initialLat, initialLon);
      setState(() {
        visitedPoints.add(startPoint);
      });

      listOfGPXPoints.add(Wpt(lat: initialLat, lon: initialLon, ele: startAltitude, time: DateTime.now()));
      started = true;
    } else {
      initialLat = cachedLat;
      initialLon = cachedLon;
      startAltitude = finalAltitude;
      startPoint = LatLng(cachedLat, cachedLon);
      listOfGPXPoints.add(Wpt(lat: initialLat, lon: initialLon, ele: startAltitude, time: DateTime.now()));
      setState(() {
        visitedPoints.add(startPoint);
      });
    }

    cachedDistance = calculateDistance(initialLat, initialLon, finalLat, finalLon);

    print(startAltitude);
    print(finalAltitude);
    calculateAngleOfIncline(cachedDistance, startAltitude, finalAltitude);

    journeyDistance += cachedDistance;
    print(journeyDistance.round() / 1000);
    setState(() {
      displayDistance = (journeyDistance.round() / 1000).toStringAsFixed(1);
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

  void updateVelocity(double estimatedVelocity) {
    estimatedVelocity = estimatedVelocity * 18 / 5;
    setState(() {
      displayVelocity = estimatedVelocity.toStringAsFixed(1);
    });
  }

  void updateAverageVelocity(String elapsedDistance, int elapsedTime) {
    double distance = double.parse(elapsedDistance);
    double time = elapsedTime / 3600;
    double averageVelocity = distance / time;
    setState(() {
      displayAverageVelocity = averageVelocity.toStringAsFixed(1);
    });
  }

/* NEED TO EDIT BELOW FN TO ACCOUNT FOR DEVICES WITHOUT BAROMETER */
  void calculateAngleOfIncline(double distance, double startAltitude, double endAltitude) {
    double deltaAltitude = endAltitude - startAltitude;
    double estimatedIncline = deltaAltitude / distance * 100;
    setState(() {
      displayIncline = estimatedIncline.toStringAsFixed(0);
    });
  }

  void calculatePowerOutput() {
    // Nf = mgcos(x)
    double normalForce = (riderMass + bikeMass) * 9.81 * cos(atan(double.parse(displayIncline) / 100));
    double velocity = double.parse(displayVelocity);
    // Prr = Coefficient of rolling resistance * Normal force * Velocity
    // Normal force assumes not turning left/right
    double powerToOvercomeRollingResistance = (0.008 * velocity * normalForce);
    // Pw = 0.5 * density of air (roughly 1.22) * velocity^3 * drag coefficient * frontal area
    double powerToOvercomeAirResistance = (0.5 * 1.22 * pow(velocity, 3) * 0.7 * 0.59);
    // Pg = mass * g * sin(arctan(grade)) * velocity
    double powerToOvercomeGravity = (riderMass + bikeMass) * 9.81 * sin(atan(double.parse(displayIncline) / 100));
    double powerEstimate = powerToOvercomeRollingResistance + powerToOvercomeAirResistance + powerToOvercomeGravity;
    setState(() {
      displayPower = powerEstimate.toStringAsFixed(0);
    });
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

  showNullRouteError() {
    /*
        DESC: Catches empty distance counter
        PARAMS: null
        RETURNS: Error dialog box
    */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("No route recorded"),
          backgroundColor: Colors.white,
          content: new Text("Please start an activity to start the route counting."),
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

  Future<bool> showUserConfirmDialog() {
    /*
        DESC: Catches user pressing back button
        PARAMS: null
        RETURNS: Error dialog box
    */
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Are you sure you want to end this recording?"),
          backgroundColor: Colors.white,
          content: new Text("This will stop your recording and save it in the app."),
          actions: <Widget>[
            FlatButton(
              child: new Text("DISCARD ROUTE"),
              color: Color(accent),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: new Text("KEEP RECORDING"),
              textColor: Colors.black,
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: new Text("SAVE ROUTE"),
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SaveRoutePage(
                          fDistance: displayDistance,
                          fTime: displayTimeInSeconds,
                          fVelocity: displayAverageVelocity,
                          riderMass: riderMass,
                        )));
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
    checkifFullScreen();
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
                height: isFullScreen ? 200 : deviceHeight / 1.4,
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
                height: !isFullScreen ? deviceHeight - deviceHeight / 1.4 - statusHeight : deviceHeight - statusHeight - 200,
                decoration: new BoxDecoration(color: Color(bgDark)),
                child: Stack(
                  children: [
                    // ONLY VISIBLE ON FULLSCREEN
                    AnimatedContainer(
                        // velocity & avg velocity
                        duration: Duration(milliseconds: 200),
                        padding: isFullScreen ? EdgeInsets.only(top: 90) : EdgeInsets.only(top: 0),
                        child: isFullScreen
                            ? AnimatedAlign(
                                duration: Duration(milliseconds: 200),
                                alignment: isFullScreen ? Alignment.topCenter : Alignment.center,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                  Text(displayPower + "W", style: TextStyle(fontSize: deviceHeight / 16, color: Colors.white)),
                                  Text(displayIncline + "%", style: TextStyle(fontSize: deviceHeight / 16, color: Colors.white))
                                ]))
                            : null),
                    AnimatedContainer(
                        // speed titles
                        duration: Duration(milliseconds: 200),
                        padding: isFullScreen ? EdgeInsets.only(top: 60) : EdgeInsets.only(top: 0),
                        child: isFullScreen
                            ? AnimatedAlign(
                                duration: Duration(milliseconds: 200),
                                alignment: isFullScreen ? Alignment.topCenter : Alignment.center,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                  Text("POWER", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white)),
                                  Text("INCLINE", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white))
                                ]))
                            : null),
                    AnimatedContainer(
                        // velocity & avg velocity
                        duration: Duration(milliseconds: 200),
                        padding: isFullScreen ? EdgeInsets.only(top: 260) : EdgeInsets.only(top: 0),
                        child: isFullScreen
                            ? AnimatedAlign(
                                duration: Duration(milliseconds: 200),
                                alignment: isFullScreen ? Alignment.topCenter : Alignment.center,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                  Text(displayVelocity + " KM/H", style: TextStyle(fontSize: deviceHeight / 16, color: Colors.white)),
                                ]))
                            : null),
                    AnimatedContainer(
                        // speed titles
                        duration: Duration(milliseconds: 200),
                        padding: isFullScreen ? EdgeInsets.only(top: 230) : EdgeInsets.only(top: 0),
                        child: isFullScreen
                            ? AnimatedAlign(
                                duration: Duration(milliseconds: 200),
                                alignment: isFullScreen ? Alignment.topCenter : Alignment.center,
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                                  Text("SPEED", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white)),
                                ]))
                            : null),
                    // ALWAYS VISIBLE
                    AnimatedContainer(
                        // distance & time
                        duration: Duration(milliseconds: 200),
                        padding: isFullScreen ? EdgeInsets.only(bottom: 150) : EdgeInsets.only(bottom: 60),
                        child: AnimatedAlign(
                            duration: Duration(milliseconds: 200),
                            alignment: isFullScreen ? Alignment.bottomCenter : Alignment.center,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              Text(displayDistance + "KM", style: TextStyle(fontSize: deviceHeight / 16, color: Colors.white)),
                              Text(displayTime, style: TextStyle(fontSize: deviceHeight / 16, color: Colors.white))
                            ]))),
                    AnimatedContainer(
                        // distance & time titles
                        duration: Duration(milliseconds: 200),
                        padding: isFullScreen ? EdgeInsets.only(bottom: 210) : EdgeInsets.only(top: 10),
                        child: AnimatedAlign(
                            duration: Duration(milliseconds: 200),
                            alignment: isFullScreen ? Alignment.bottomCenter : Alignment.topCenter,
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              Text("DISTANCE", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white)),
                              Text("TIME", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white))
                            ]))),
                    AnimatedContainer(
                        padding: isFullScreen ? EdgeInsets.only(bottom: 50) : EdgeInsets.only(bottom: 20),
                        duration: Duration(milliseconds: 200),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RawMaterialButton(
                                  onPressed: () {
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
                                  onPressed: () {
                                    if (clockIsPaused) {
                                      if (displayDistance == "0.0") {
                                        showNullRouteError();
                                      } else {
                                        showUserConfirmDialog();
                                      }
                                    } else {
                                      // showConfirmRouteDialog();
                                    }
                                  },
                                  elevation: 2.0,
                                  fillColor: Color(accent),
                                  child: Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                                RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      isFullScreen = !isFullScreen;
                                    });
                                  },
                                  elevation: 2.0,
                                  fillColor: Colors.white,
                                  child: isFullScreenWidget,
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                              ],
                            )))
                  ],
                ),
              ),
            ]),
          ]),
        ));
  }
}

class SaveRoutePage extends StatefulWidget {
  final String fDistance;
  final int fTime;
  final String fVelocity;
  final double riderMass;
  SaveRoutePage({this.fDistance, this.fTime, this.fVelocity, this.riderMass});
  @override
  _SaveRoutePageState createState() => _SaveRoutePageState();
}

class _SaveRoutePageState extends State<SaveRoutePage> {
  double exertionSliderValue = 5;
  bool privacyisSwitched = false;
  String activityTitle;
  String activityDesc;

  final titleController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  // String fDistance;
  // int fTime;
  // String fVelocity;
  // _SaveRoutePageState({this.fDistance, this.fTime, this.fVelocity});

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

  showNullErrorDialog() {
    /*
        DESC: Catches null title
        PARAMS: null
        RETURNS: Error dialog box
    */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("No Activity Title"),
          backgroundColor: Colors.white,
          content: new Text("Enter a title for your activity before publishing."),
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

  int calculateCaloriesBurnt(time, mass) {
    const double metabolicTaskEquivalent = 9.5;
    double count = (time * metabolicTaskEquivalent * mass / (200 * 60));
    return count.round();
  }

  void insertIntoDatabase(Activity activity, Database database) async {
    await database.rawInsert("INSERT INTO activities(id, title, description, distance, timeElapsed, averageVelocity, caloriesBurnt, isPublic, exertion) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)", [
      activity.timestamp,
      activity.title,
      activity.description,
      activity.distance,
      activity.timeElapsedinSeconds,
      activity.averageVelocity,
      activity.caloriesBurnt,
      activity.isPublic,
      activity.exertion
    ]);

    print(await database.rawQuery("SELECT * FROM activities"));
  }

  void publishActivity(String title, String description) async {
    if (activityTitle == "" || activityTitle == null) {
      showNullErrorDialog();
    } else {
      Navigator.of(context).pop(true);

      int timestamp = DateTime.now().millisecondsSinceEpoch;
      double distance = double.parse(widget.fDistance);
      int time = widget.fTime;
      double velocity = double.parse(widget.fVelocity);
      bool isPublic = !privacyisSwitched;
      int exertion = exertionSliderValue.floor();

      int calories = calculateCaloriesBurnt(time, widget.riderMass);

      final activityObject = Activity(
          timestamp: timestamp,
          title: title,
          description: description,
          distance: distance,
          timeElapsedinSeconds: time,
          averageVelocity: velocity,
          caloriesBurnt: calories,
          isPublic: isPublic,
          exertion: exertion);

      await deleteDatabase(p.join(await getDatabasesPath(), 'activities.db'));

      Database database = await openDatabase(
        p.join(await getDatabasesPath(), 'activities.db'),
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE activities(id INT PRIMARY KEY, title TEXT, description TEXT, distance REAL, timeElapsed INTEGER, averageVelocity REAL, caloriesBurnt INTEGER, isPublic BOOL, exertion INTEGER)",
          );
        },
        version: 1,
      );

      insertIntoDatabase(activityObject, database);
    }
  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
        onWillPop: showReturnError,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            // PARENT APP BAR
            appBar: AppBar(
              backgroundColor: Color(bgDark),
              title: Text("SAVE ROUTE", style: TextStyle(fontSize: deviceHeight / 20, color: Colors.white)),
              elevation: 0.0,
            ),
            // PAGE BODY
            body: Container(
                color: Color(bgDark),
                child: Column(children: <Widget>[
                  Container(height: deviceHeight / 50),
                  Container(
                      padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 1.0),
                      child: TextField(
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          onSubmitted: (value) {
                            activityTitle = value;
                          },
                          autocorrect: true,
                          textCapitalization: TextCapitalization.sentences,
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "Title",
                            labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                            hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(accent)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ))),
                  Container(
                      padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
                      child: TextField(
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          onSubmitted: (value) {
                            activityDesc = value;
                          },
                          autocorrect: true,
                          textCapitalization: TextCapitalization.sentences,
                          controller: descController,
                          decoration: InputDecoration(
                            labelText: "Description",
                            labelStyle: TextStyle(fontSize: 14, color: Colors.white),
                            hintStyle: TextStyle(fontSize: 14, color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(accent)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ))),
                  Container(height: deviceHeight / 30),
                  Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Percieved Exertion:",
                            style: TextStyle(fontSize: deviceHeight / 40, color: Colors.white),
                          ))),
                  Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "(How hard was that activity?)",
                            style: TextStyle(fontSize: deviceHeight / 70, color: Colors.white),
                          ))),
                  Container(
                      child: Slider(
                    activeColor: Color(accent),
                    inactiveColor: Colors.grey,
                    value: exertionSliderValue,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: exertionSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        exertionSliderValue = value;
                      });
                    },
                  )),
                  Container(height: deviceHeight / 30),
                  Container(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Activity Visibility:",
                            style: TextStyle(fontSize: deviceHeight / 40, color: Colors.white),
                          ))),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                          child: Row(
                        // TOGGLE SWITCH UI
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.lock_outline_sharp, color: Colors.white),
                          Switch(
                            value: !privacyisSwitched,
                            onChanged: (value) {
                              setState(() {
                                privacyisSwitched = !value;
                              });
                            },
                            inactiveTrackColor: Colors.white,
                            inactiveThumbColor: Color(accent),
                            activeTrackColor: Colors.white,
                            activeColor: Color(accent),
                          ),
                          Icon(Icons.lock_open_sharp, color: Colors.white)
                        ],
                      ))),
                  Container(height: deviceHeight / 20),
                  Center(
                    // START RECORDING BUTTON
                    child: FlatButton(
                      child: Text(
                        "PUBLISH",
                        style: TextStyle(fontSize: 25),
                      ),
                      onPressed: () {
                        publishActivity(titleController.text, descController.text);
                      },
                      color: Color(accent),
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                      splashColor: Colors.grey,
                    ),
                  )
                ]))));
  }
}
