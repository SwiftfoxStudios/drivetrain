import 'package:flutter/material.dart';

import 'package:gpx/gpx.dart';

import '../activityClass.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

int bgDark = 0xff202020;
int bgLight = 0xff2e2e2e;
int accent = 0xffff5d54;

class AnalyseMain extends StatefulWidget {
  @override
  _AnalyseMainState createState() => _AnalyseMainState();
}

class _AnalyseMainState extends State<AnalyseMain> {
  @override
  analyseRecordings() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AnalyseRecPage(),
    ));
  }

  analyseStats() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AnalyseStatsPage(),
    ));
  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(bgDark),
          title: Text("ANALYSE", style: TextStyle(fontSize: deviceHeight / 20, color: Colors.white)),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.settings, color: Colors.white), onPressed: null, iconSize: deviceHeight / 20)
          ],
        ),
        body: Container(
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
                                  analyseRecordings();
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
                                      Text("SEE PAST RECORDINGS",
                                          style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("View and manage your saved recordings",
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
                                  analyseStats();
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
                                      Text("SEE THE STATS",
                                          style: TextStyle(fontSize: deviceHeight / 28, color: Colors.black)),
                                      Container(height: 5),
                                      Text("Track your progress in several variables over time",
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

class AnalyseRecPage extends StatefulWidget {
  @override
  _AnalyseRecPageState createState() => _AnalyseRecPageState();
}

class _AnalyseRecPageState extends State<AnalyseRecPage> {
  String dropdownValue = "Date - Newest First";

  Object getActivitiesfromDatabase() async {
    Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
    await database.rawQuery("SELECT * FROM activities");
  }

  Widget build(BuildContext context) {
    // DEVICE DIMENSIONS FOR DEVICE-SPECIFIC MEASUREMENTS
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: Container(
            color: Color(bgDark),
            child: Column(
              children: [
                Container(height: statusHeight),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                    child: Text(
                      "PAST RECORDINGS",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                Container(
                    child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward, color: Color(accent)),
                  iconSize: 24,
                  elevation: 8,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  dropdownColor: Color(bgLight),
                  underline: Container(
                    height: 3,
                    color: Color(accent),
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>[
                    "Date - Newest First",
                    "Date - Oldest First",
                    "Distance - Longest First",
                    "Elapsed Time - Longest First",
                    "Exertion - Hardest First"
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),
                ListView()
              ],
            )));
  }
}

class AnalyseStatsPage extends StatefulWidget {
  @override
  _AnalyseStatsPageState createState() => _AnalyseStatsPageState();
}

class _AnalyseStatsPageState extends State<AnalyseStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.pink);
  }
}
