// MAIN DART PARENT IMPORT
import 'dart:async';

// FILE DEPENDENCIES
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

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
  @override
  Location location = new Location();
  int _selectedIndex = 1;
  bool isSwitched = false;

// SETS INITIAL PAGE OF NAVIGATION BAR
  void navigatePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

// SETS INITIAL CAMERA POSITION OF GOOGLE MAP
  Future<void> moveCamera() async {
    var pos = await location.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 15)));
  }

  // timerCounter() async {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     moveCamera();
  //   });
  // }

  static final CameraPosition initial =
      CameraPosition(target: LatLng(51.453318, -0.102559), zoom: 16);

  Widget build(BuildContext context) {
    moveCamera();
    // timerCounter();
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(bgDark),
        title: Text("RECORD",
            style: TextStyle(fontSize: deviceHeight / 20, color: Colors.white)),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: null,
              iconSize: deviceHeight / 20)
        ],
      ),
      body: Column(children: <Widget>[
        Container(
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
            decoration: new BoxDecoration(
                color: Color(bgDark),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            height: deviceHeight / 2 - (56 + statusHeight) - deviceHeight / 10,
          ),
          Container(
            height: deviceHeight / 18,
            decoration: new BoxDecoration(
                color: Color(bgDark),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(0.0),
                    topRight: const Radius.circular(0.0))),
          ),
          Positioned.fill(
            top: deviceHeight / 18,
            bottom: 0,
            child: Container(
                color: Color(bgLight),
                height: deviceHeight / 1,
                width: deviceWidth,
                child: Column(children: <Widget>[
                  Container(height: deviceHeight / 25),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.directions_bike, color: Colors.white),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
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
                    child: RaisedButton(
                      child: Text("START RECORDING"),
                      onPressed: () {},
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
