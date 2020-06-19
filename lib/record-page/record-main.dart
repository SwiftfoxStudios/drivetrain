import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

int bgDark = 0xff202020;
int bgLight = 0xff2e2e2e;

class RecordMain extends StatefulWidget {
  @override
  _RecordMainState createState() => _RecordMainState();
}

class _RecordMainState extends State<RecordMain> {
  @override
  GoogleMapController _controller;
  static final CameraPosition initial =
      CameraPosition(target: LatLng(37.7, -122.1), zoom: 12);

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(bgDark),
          title: Text("RECORD",
              style: TextStyle(fontSize: 30, color: Colors.white)),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: null,
                iconSize: 30.0)
          ],
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: initial,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Stack(children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        color: Color(bgDark),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(15.0),
                            topRight: const Radius.circular(15.0))),
                    height: deviceHeight / 100 * 40,
                  ),
                  Container(
                    height: deviceHeight / 18,
                    decoration: new BoxDecoration(
                        color: Color(bgDark),
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(15.0),
                            topRight: const Radius.circular(15.0))),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                          color: Color(bgDark),
                          height: deviceHeight / 10,
                          width: deviceWidth)),
                  Positioned.fill(
                      top: deviceHeight / 18,
                      bottom: deviceHeight / 10,
                      child: Container(
                          color: Color(bgLight),
                          height: deviceHeight / 18,
                          width: deviceWidth)),
                ]))
          ],
        ));
  }
}
