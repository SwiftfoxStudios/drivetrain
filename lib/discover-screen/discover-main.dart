// Import Dart Math and I/O handling and Asynchronous Event Handling
import 'dart:math';
import 'dart:core';
import 'dart:io';
import 'dart:async';

// Import XML and File Control Libraries
import 'package:xml/xml.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// Import local files including API key
import '../secrets/keys.dart';
import '../activityClass.dart';
import 'WorkoutPoint.dart';

// Import Google Material Design & Flutter Services
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Google Map Imports
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
                                      Text("GENERATE A ROUTE",
                                          style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("Find new routes using the circular route generator",
                                          style:
                                              TextStyle(height: 1.2, fontSize: deviceHeight / 41, color: Colors.black)),
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
                                      Text("IMPORT ACTIVITIES",
                                          style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("Import .gpx files into the app to use as previous activities",
                                          style: TextStyle(
                                              height: 1.2,
                                              fontSize: deviceHeight / 41,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w100)),
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

  static final CameraPosition initial = CameraPosition(target: LatLng(51.453318, -0.102559), zoom: 13);
  Location location = new Location();
  String userAddress;
  List<Marker> markerList = [];

  void apiKey() {}

  Future<void> moveCamera() async {
    /*
        DESC: Sets camera position of google map
        PARAMS: Null
        RETURNS: Null
    */
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15)));
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
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(result[0].latitude, result[0].longitude), zoom: 15)));
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

  List<double> calculatePoint(double lat1, double lon1, bearing, distance) {
    /*
        DESC: Calculates a destination point from an origin point with bearing and distance
        PARAMS: Origin point, Bearing & Distance
        RETURNS: List of coordinates
    */
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
    return [lat2, lon2];
  }

  _createPolylines(start, dest) async {
    /*
        DESC: Creates points to be shown on the map page
        PARAMS: Start pos, Destination pos
        RETURNS: Update list of polyline points
    */
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Keys.returnKey(), // API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(dest.latitude, dest.longitude),
      travelMode: TravelMode.bicycling,
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
    print("hello");
    print(polyline.points);
  }

  generateCircularRoute() {
    setState(() {
      polylines.clear();
      polylineCoords = [];
    });

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

        List<double> startPoint = [double.parse(startingLocationList[0]), double.parse(startingLocationList[1])];
        LatLng startCoords = LatLng(startPoint[0], startPoint[1]);

        List<double> destPoint = calculatePoint(startPoint[0], startPoint[1], 0, userDistanceInput / (2 * pi));
        LatLng destCoords = LatLng(destPoint[0], destPoint[1]);

        _createPolylines(startCoords, destCoords);

        for (var i = 1; i < 4; i++) {
          startPoint = destPoint;
          startCoords = destCoords;

          destPoint = calculatePoint(startPoint[0], startPoint[1], 360 / 4 * i, userDistanceInput / (2 * pi));
          destCoords = LatLng(destPoint[0], destPoint[1]);

          _createPolylines(startCoords, destCoords);
        }

        startPoint = destPoint;
        startCoords = destCoords;

        destPoint = [double.parse(startingLocationList[0]), double.parse(startingLocationList[1])];
        destCoords = LatLng(destPoint[0], destPoint[1]);

        _createPolylines(startCoords, destCoords);
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

class ImportRoutePage extends StatefulWidget {
  @override
  _ImportRoutePageState createState() => _ImportRoutePageState();
}

class _ImportRoutePageState extends State<ImportRoutePage> {
  String fileData = "";
  bool isUploaded = false;
  double riderMass = 57;
  double exertionSliderValue = 5;
  bool privacyisSwitched = false;
  Map calculatedMetadata;

  void openFile() async {
    /*
        DESC: Opens gpx file from user request
        PARAMS: null
        RETURNS: null
    */
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      String path = result.files.first.path;
      if (path.substring(path.length - 4) != ".gpx") {
        showInvalidFileError();
      } else {
        readFileMetadata(path);
      }
    }
  }

  showInvalidFileError() {
    /*
        DESC: Catches invalid file type
        PARAMS: null
        RETURNS: Error dialog box
    */
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("GPX file not selected"),
          backgroundColor: Colors.white,
          content: new Text("Please select a file with the file extension '.gpx'."),
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

  void readFileMetadata(String path) {
    /*
        DESC: Reads File Metadata
        PARAMS: File path
        RETURNS: Null
    */
    calculatedMetadata = null;
    final file = new File(path);
    final document = XmlDocument.parse(file.readAsStringSync());
    String workoutTitle = document.findAllElements('name').single.text;
    final workoutPoints = document.findAllElements('trkpt');

    List pointsData = workoutPoints.map((point) {
      bool hrExists = true;
      bool powerExists = true;
      Point workoutPoint = Point(
          point.findElements('time').first.text,
          double.parse(point.attributes[0].toString().substring(5, point.attributes[0].toString().length - 1)),
          double.parse(point.attributes[1].toString().substring(5, point.attributes[0].toString().length - 1)),
          double.parse(point.findElements('ele').first.text));
      try {
        point.findElements('extensions');
      } on StateError {
        hrExists = false;
        powerExists = false;
      }
      if (powerExists) {
        try {
          point.findElements('extensions').first.findElements('power').first;
        } on StateError {
          powerExists = false;
        }
      }
      if (hrExists) {
        try {
          point
              .findElements('extensions')
              .first
              .findElements('gpxtpx:TrackPointExtension')
              .first
              .findElements('gpxtpx:hr')
              .first;
        } on StateError {
          hrExists = false;
        }
      }
      if (hrExists) {
        workoutPoint.hr = int.parse(point
            .findElements('extensions')
            .first
            .findElements('gpxtpx:TrackPointExtension')
            .first
            .findElements('gpxtpx:hr')
            .first
            .text);
      }
      if (powerExists) {
        workoutPoint.power = int.parse(point.findElements('extensions').first.findElements('power').first.text);
      }
      return workoutPoint;
    }).toList();
    print(pointsData[0].lat);
    setState(() {
      fileData = workoutTitle;
      isUploaded = true;
    });

    double distance = 0;
    double climbed = 0;
    int movingTimeinMS = 0;
    for (var i = 0; i < pointsData.length; i++) {
      if (i != pointsData.length - 1) {
        distance += calculateDistance(pointsData[i].lat, pointsData[i].lon, pointsData[i + 1].lat,
            pointsData[i + 1].lon, pointsData[i].elevation, pointsData[i + 1].elevation);
        climbed += calculateClimbed(pointsData[i].elevation, pointsData[i + 1].elevation);
        movingTimeinMS += accumulatedMovingTime(
          pointsData[i].time,
          pointsData[i + 1].time,
          pointsData[i].lat,
          pointsData[i].lon,
          pointsData[i + 1].lat,
          pointsData[i + 1].lon,
        );
      }
    }
    int elapsed = calculateElapsedTime(pointsData[0].time, pointsData[pointsData.length - 1].time);
    print(distance);
    print(climbed);
    print(movingTimeinMS);

    calculatedMetadata = {
      "distance": distance,
      "climbed": climbed,
      "title": workoutTitle,
      "timestamp": DateTime.parse(pointsData[0].time).millisecondsSinceEpoch,
      "elapsedTime": elapsed / 1000,
      "movingTime": movingTimeinMS / 1000,
      "averageVelocity": distance / (movingTimeinMS / 1000) * 3.6,
      "caloriesBurnt": calculateCaloriesBurnt(movingTimeinMS / 1000, riderMass),
    };
  }

  int calculateCaloriesBurnt(time, mass) {
    const double metabolicTaskEquivalent = 9.5;
    double count = (time * metabolicTaskEquivalent * mass / (200 * 60));
    return count.round();
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2, double ele1, double ele2) {
    /*
        DESC: Uses Haversine Formula to calculate distance between two points
        PARAMS: Points and change in elevation between points
        RETURNS: Value of Distance
    */
    const double earthRadius = 6371e3;
    double lat1rad = lat1 * pi / 180;
    double lat2rad = lat2 * pi / 180;

    double deltaLat = (lat2 - lat1) * pi / 180;
    double deltaLon = (lon2 - lon1) * pi / 180;

    double angle =
        sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1rad) * cos(lat2rad) * sin(deltaLon / 2) * sin(deltaLon / 2);

    double angularDistance = 2 * atan2(sqrt(angle), sqrt(1 - angle));
    double returnedDistance = earthRadius * angularDistance;
    double elevationChange = ele2 - ele1;
    returnedDistance = sqrt(pow(returnedDistance, 2) + pow(elevationChange, 2));
    return returnedDistance;
    // Returned value is in metres
  }

  double calculateClimbed(double ele1, double ele2) {
    /*
        DESC: Calculates metres climbed between two points
        PARAMS: Change in elevation between points
        RETURNS: Value of Metres Climbed
    */
    if (ele2 > ele1) {
      return ele2 - ele1;
    } else
      return 0;
  }

  int calculateElapsedTime(String start, String end) {
    /*
        DESC: Calculates Elapsed Time
        PARAMS: Start and End times
        RETURNS: Time
    */
    DateTime startTime = DateTime.parse(start);
    DateTime endTime = DateTime.parse(end);
    return endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
  }

  int accumulatedMovingTime(String startTime, String endTime, double lat1, double lon1, double lat2, double lon2) {
    /*
        DESC: Calculates Moving Time
        PARAMS: Start and End times
        RETURNS: Time
    */
    if (lat1 == lat2 && lon1 == lon2) {
      return 0;
    } else {
      return DateTime.parse(endTime).millisecondsSinceEpoch - DateTime.parse(startTime).millisecondsSinceEpoch;
    }
  }

  void publishActivitytoDatabase(Map metadata) async {
    /*
        DESC: Publishes activity to database
        PARAMS: File metadata
        RETURNS: Null
    */
    Database database = await openDatabase(
      p.join(await getDatabasesPath(), 'activities.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE activities(id INT PRIMARY KEY, title TEXT, description TEXT, distance REAL, timeElapsed INTEGER, averageVelocity REAL, caloriesBurnt INTEGER, isPublic BOOL, exertion INTEGER)",
        );
      },
      version: 1,
    );
    bool isPublic = !privacyisSwitched;
    int exertion = exertionSliderValue.floor();

    final activityObject = Activity(
        timestamp: metadata["timestamp"],
        title: metadata["title"],
        description: "",
        distance: double.parse((metadata["distance"] / 1000).toStringAsFixed(1)),
        timeElapsedinSeconds: metadata["elapsedTime"].round(),
        averageVelocity: double.parse(metadata["averageVelocity"].toStringAsFixed(1)),
        caloriesBurnt: metadata["caloriesBurnt"],
        isPublic: isPublic,
        exertion: exertion);

    // UNCOMMENT THE LINE BELOW IF YOU messed UP
    //
    //
    // await deleteDatabase(p.join(await getDatabasesPath(), 'activities.db'));
    //
    //
    // UNCOMMENT THE LINE ABOVE IF YOU messed UP

    insertIntoDatabase(activityObject, database);
  }

  void insertIntoDatabase(Activity activity, Database database) async {
    /*
        DESC: Inserts activity into SQL database
        PARAMS: Activity & database location
        RETURNS: Null
    */
    await database.rawInsert(
        "INSERT INTO activities(id, title, description, distance, timeElapsed, averageVelocity, caloriesBurnt, isPublic, exertion) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
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

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(accent),
          title: Text("IMPORT ACTIVITY", style: TextStyle(fontSize: deviceHeight / 25, color: Colors.white)),
          elevation: 0.0,
          actions: [],
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            height: deviceHeight - statusHeight - 56,
            color: Color(bgDark),
            width: deviceWidth,
            child: Column(
              children: [
                Container(height: deviceHeight / 10),
                Center(
                  child: Text(
                    "Navigate to open file below:",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(height: deviceHeight / 50),
                Center(
                    child: Container(
                  padding: EdgeInsets.all(5),
                  decoration:
                      BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    "WARNING: FILES MUST BE DIRECTLY FROM STRAVA AND HAVE THE GPX FILE TYPE. IT MUST INCLUDE ELEVATION AND LOCATION DATA.",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                )),
                Container(height: deviceHeight / 50),
                Center(
                  child: FlatButton(
                    child: Text("OPEN FILE"),
                    onPressed: () {
                      openFile();
                    },
                    color: Color(accent),
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    splashColor: Colors.grey,
                  ),
                ),
                Container(height: deviceHeight / 50),
                Center(
                  child: Text(
                    isUploaded ? "UPLOADED:" : "",
                    style: TextStyle(color: Colors.green, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    fileData,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(height: deviceHeight / 50),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: isUploaded
                        ? BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.all(Radius.circular(10)))
                        : BoxDecoration(),
                    child: Text(
                      isUploaded ? "WARNING: FILE WILL HAVE INACCURACIES WITH DATA DUE TO GPX STANDARD." : "",
                      style: TextStyle(color: Colors.white, fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(height: deviceHeight / 15),
                isUploaded
                    ? Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Percieved Exertion:",
                              style: TextStyle(fontSize: deviceHeight / 40, color: Colors.white),
                            )))
                    : Container(),
                isUploaded
                    ? Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "(How hard was that activity?)",
                              style: TextStyle(fontSize: deviceHeight / 70, color: Colors.white),
                            )))
                    : Container(),
                isUploaded
                    ? Container(
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
                      ))
                    : Container(),
                Container(height: deviceHeight / 30),
                isUploaded
                    ? Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Activity Visibility:",
                              style: TextStyle(fontSize: deviceHeight / 40, color: Colors.white),
                            )))
                    : Container(),
                isUploaded
                    ? Container(
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
                        )))
                    : Container(),
                Container(height: deviceHeight / 50),
                isUploaded
                    ? Center(
                        child: FlatButton(
                          child: Text("PUBLISH"),
                          onPressed: () {
                            publishActivitytoDatabase(calculatedMetadata);
                          },
                          color: Color(accent),
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          splashColor: Colors.grey,
                        ),
                      )
                    : Center(),
              ],
            )));
  }
}
