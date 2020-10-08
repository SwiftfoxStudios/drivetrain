// MATERIAL DESIGN IMPORT
import 'package:flutter/material.dart';

// COLOURS USED IN PROJECT
const bgDark = 0xff202020;
const bgLight = 0xff2e2e2e;
const accent = 0xffff5d54;

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
  _GenerateRoutePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.yellow);
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
