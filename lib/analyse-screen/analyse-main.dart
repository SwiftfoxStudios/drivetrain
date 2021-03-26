// Import Google Material Design
import 'package:flutter/material.dart';

// Import GPX Handling Library
import 'package:gpx/gpx.dart';

// Import File Path Handling Library, SQL and International Date Handling Libraries
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

// Colour Constants
int bgDark = 0xff202020;
int bgLight = 0xff2e2e2e;
int accent = 0xffff5d54;

class AnalyseMain extends StatefulWidget {
  @override
  _AnalyseMainState createState() => _AnalyseMainState();
}

class _AnalyseMainState extends State<AnalyseMain> {
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
  List<Map> activities = List<Map>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map>> getAndSortActivities(String method) async {
    switch (method) {
      case "Date - Newest First":
        {
          Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
          await database.rawQuery("SELECT * FROM activities ORDER BY id DESC").then((value) => activities = value);
        }
        break;
      case "Date - Oldest First":
        {
          Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
          await database.rawQuery("SELECT * FROM activities ORDER BY id ASC").then((value) => activities = value);
        }
        break;
      case "Distance - Longest First":
        {
          Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
          await database
              .rawQuery("SELECT * FROM activities ORDER BY distance DESC, id DESC")
              .then((value) => activities = value);
        }
        break;
      case "Elapsed Time - Longest First":
        {
          Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
          await database
              .rawQuery("SELECT * FROM activities ORDER BY timeElapsed DESC, id DESC")
              .then((value) => activities = value);
        }
        break;
      case "Exertion - Hardest First":
        {
          Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
          await database
              .rawQuery("SELECT * FROM activities ORDER BY exertion DESC, id DESC")
              .then((value) => activities = value);
        }
        break;
    }

    return activities;
  }

  String convertToHMS(int seconds) {
    
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String unixToDate(int unixTime) {
    DateTime datetime = DateTime.fromMillisecondsSinceEpoch(unixTime);
    return DateFormat("HH:mm, dd MMM y").format(datetime);
  }

  List displayExertion(int exertion) {
    List exertionValues = List();
    if (exertion <= 2) {
      exertionValues.add("Very Easy");
      exertionValues.add(Colors.greenAccent[700]);
    } else if (exertion >= 3 && exertion <= 4) {
      exertionValues.add("Easy");
      exertionValues.add(Colors.greenAccent[400]);
    } else if (exertion >= 5 && exertion <= 6) {
      exertionValues.add("Medium");
      exertionValues.add(Colors.yellow);
    } else if (exertion >= 7 && exertion <= 8) {
      exertionValues.add("Challenging");
      exertionValues.add(Colors.blue);
    } else {
      exertionValues.add("Hard");
      exertionValues.add(Colors.red);
    }
    return exertionValues;
  }

  navigateToRoutePage(int id) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RouteAnalysisPage(
        activityID: id,
      ),
    ));
  }

  Widget build(BuildContext context) {
    // DEVICE DIMENSIONS FOR DEVICE-SPECIFIC MEASUREMENTS
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        body: Container(
            color: Color(bgDark),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  getAndSortActivities(dropdownValue);
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
              Expanded(
                  child: FutureBuilder<List<Map>>(
                      future: getAndSortActivities(dropdownValue),
                      builder: (context, AsyncSnapshot<List<Map>> snapshot) {
                        if (snapshot.hasData) {
                          return SizedBox(
                              child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                            itemCount: activities.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                  onTap: () {
                                    navigateToRoutePage(activities[index]["id"]);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      color: Color(bgDark),
                                      child: Container(
                                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              color: Color(bgLight)),
                                          child: Column(
                                            children: [
                                              Container(
                                                  constraints: BoxConstraints(maxWidth: deviceWidth / 100 * 75),
                                                  child: Text(activities[index]["title"],
                                                      style: TextStyle(color: Colors.white, fontSize: 25),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center)),
                                              Container(
                                                  constraints: BoxConstraints(maxWidth: deviceWidth / 100 * 75),
                                                  child: Text(activities[index]["description"],
                                                      style: TextStyle(color: Colors.grey, fontSize: 10),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.center)),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text("${activities[index]["distance"].toString()}KM",
                                                        style: TextStyle(color: Colors.white, fontSize: 20)),
                                                    Text(convertToHMS(activities[index]["timeElapsed"]),
                                                        style: TextStyle(color: Colors.white, fontSize: 20)),
                                                    Text(displayExertion(activities[index]["exertion"])[0],
                                                        style: TextStyle(
                                                            color: displayExertion(activities[index]["exertion"])[1],
                                                            fontSize: 20))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  child: Text(unixToDate(activities[index]["id"]),
                                                      style: TextStyle(color: Colors.white, fontSize: 20)))
                                            ],
                                          ))));
                            },
                          ));
                        } else {
                          return CircularProgressIndicator();
                        }
                      }))
            ])));
  }
}

class RouteAnalysisPage extends StatefulWidget {
  final int activityID;

  RouteAnalysisPage({this.activityID});

  @override
  _RouteAnalysisPageState createState() => _RouteAnalysisPageState();
}

class _RouteAnalysisPageState extends State<RouteAnalysisPage> {
  Map activity = Map();

  Future<Map> getActivitybyID(int id) async {
    Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
    await database.rawQuery("SELECT * FROM activities WHERE id = ?", [id]).then((value) => activity = value[0]);
    return activity;
  }

  String convertToHMS(int seconds) {
    /*
        DESC: Converts Seconds to Hours, Minutes & Seconds
        PARAMS: Number of seconds
        RETURNS: String of HMS
    */
    Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }

  List displayExertion(int exertion) {
    /*
        DESC: Displays how hard the user found their exercise
        PARAMS: User exertion input
        RETURNS: List of exertion metadata
    */
    List exertionValues = List();
    if (exertion <= 2) {
      exertionValues.add("Very Easy");
      exertionValues.add(Colors.greenAccent[700]);
      exertionValues.add("Zone 2 (Endurance)");
      exertionValues.add(Colors.lightBlue);
    } else if (exertion >= 3 && exertion <= 4) {
      exertionValues.add("Easy");
      exertionValues.add(Colors.greenAccent[400]);
      exertionValues.add("Zone 3 (Tempo)");
      exertionValues.add(Colors.green);
    } else if (exertion >= 5 && exertion <= 6) {
      exertionValues.add("Medium");
      exertionValues.add(Colors.yellow);
      exertionValues.add("Zone 3 (SST)");
      exertionValues.add(Colors.yellow[200]);
    } else if (exertion >= 7 && exertion <= 8) {
      exertionValues.add("Challenging");
      exertionValues.add(Colors.blue);
      exertionValues.add("Zone 4 (Threshold)");
      exertionValues.add(Colors.yellow[800]);
    } else {
      exertionValues.add("Hard");
      exertionValues.add(Colors.red);
      exertionValues.add("Zone 5 (Above Threshold)");
      exertionValues.add(Colors.orange[700]);
    }
    return exertionValues;
  }

  List publicChecker(int isPublic) {
    /*
        DESC: Checks if entry is public or private
        PARAMS: User entered request of privacy
        RETURNS: List of privacy metadata
    */
    List checkValues = List();
    if (isPublic == 1) {
      checkValues.add("PUBLIC ACTIVITY");
      checkValues.add(Colors.green);
    } else {
      checkValues.add("PRIVATE ACTIVITY");
      checkValues.add(Colors.red);
    }
    return checkValues;
  }

  editActivity(int id) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditActivityPage(
        activityID: id,
      ),
    ));
  }

  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(accent),
          title: Text("ACTIVITY", style: TextStyle(fontSize: deviceHeight / 25, color: Colors.white)),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  editActivity(widget.activityID);
                },
                iconSize: deviceHeight / 25)
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                height: deviceHeight - statusHeight,
                color: Color(bgDark),
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(bgLight)),
                  child: Column(children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        child: Center(
                            child: FutureBuilder<Map>(
                                future: getActivitybyID(widget.activityID),
                                builder: (context, AsyncSnapshot<Map> snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(children: [
                                      Text(
                                        activity["title"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: deviceHeight / 45,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        publicChecker(activity["isPublic"])[0],
                                        style: TextStyle(
                                          color: publicChecker(activity["isPublic"])[1],
                                          fontSize: deviceHeight / 55,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        activity["description"],
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: deviceHeight / 65,
                                        ),
                                        textAlign: TextAlign.left,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Container(height: 20),
                                      Text("DISTANCE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 65,
                                          )),
                                      Text("${activity["distance"]} KM",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 25,
                                          )),
                                      Container(height: 20),
                                      Text("ELAPSED TIME",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 65,
                                          )),
                                      Text("${convertToHMS(activity["timeElapsed"])}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 25,
                                          )),
                                      Container(height: 20),
                                      Text("AVERAGE SPEED",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 65,
                                          )),
                                      Text("${activity["averageVelocity"].toString()} KM/H",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 25,
                                          )),
                                      Container(height: 20),
                                      Text("CALORIES BURNT",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 65,
                                          )),
                                      Text("${activity["caloriesBurnt"]} kcal",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 25,
                                          )),
                                      Container(height: 20),
                                      Text("PERCEIVED EXERTION",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight / 65,
                                          )),
                                      Text("${displayExertion(activity["exertion"])[0]}",
                                          style: TextStyle(
                                            color: displayExertion(activity["exertion"])[1],
                                            fontSize: deviceHeight / 25,
                                          )),
                                      Text(
                                          "About the same intensity as an hour at ${displayExertion(activity["exertion"])[2]}",
                                          style: TextStyle(
                                            color: displayExertion(activity["exertion"])[3],
                                            fontSize: deviceHeight / 70,
                                          ),
                                          textAlign: TextAlign.center)
                                    ]);
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                })))
                  ]),
                ))));
  }
}

class EditActivityPage extends StatefulWidget {
  final int activityID;
  EditActivityPage({this.activityID});
  @override
  _EditActivityPageState createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  double exertionSliderValue = 5;
  bool privacyisSwitched = false;
  String activityTitle;
  String activityDesc;
  bool firstRun = true;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  Map activity = Map();

  Future<Map> getActivitybyID(int id) async {
    /*
        DESC: Gets activity from unique ID
        PARAMS: ID
        RETURNS: Data Map of activity
    */
    Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
    await database.rawQuery("SELECT * FROM activities WHERE id = ?", [id]).then((value) => activity = value[0]);
    if (firstRun) {
      titleController..text = activity["title"];
      descController..text = activity["description"];
      exertionSliderValue = activity["exertion"].toDouble();
      if (activity["isPublic"] == 1) {
        privacyisSwitched = false;
      } else {
        privacyisSwitched = true;
      }
    }
    firstRun = false;
    return activity;
  }

  saveChanges(title, desc) async {
    int isPublic;
    Database database = await openDatabase(p.join(await getDatabasesPath(), 'activities.db'));
    if (!privacyisSwitched) {
      isPublic = 1;
    } else {
      isPublic = 0;
    }
    await database.rawUpdate(
        "UPDATE activities SET title = ?, description = ?, exertion = ?, isPublic = ? WHERE id = ?",
        [title, desc, exertionSliderValue, isPublic, widget.activityID]);
    Navigator.of(context).pop();
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
          content: new Text("Changes will not be saved."),
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

  @override
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
              centerTitle: true,
              title: Text("EDIT ACTIVITY", style: TextStyle(fontSize: deviceHeight / 30, color: Colors.white)),
              elevation: 0.0,
            ),
            // PAGE BODY
            body: Container(
                color: Color(bgDark),
                child: FutureBuilder<Map>(
                    future: getActivitybyID(widget.activityID),
                    builder: (context, AsyncSnapshot<Map> snapshot) {
                      if (snapshot.hasData) {
                        return Column(children: <Widget>[
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
                                "SAVE CHANGES",
                                style: TextStyle(fontSize: 25),
                              ),
                              onPressed: () {
                                saveChanges(titleController.text, descController.text);
                              },
                              color: Color(accent),
                              textColor: Colors.white,
                              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                              splashColor: Colors.grey,
                            ),
                          ),
                          Container(height: 10),
                          Container(
                              width: deviceWidth / 100 * 90,
                              child: Text(
                                "ACTIVITY WILL UPDATE WHEN ALL ACTIVITIES ARE RELOADED AGAIN FROM HOME SCREEN.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: deviceHeight / 70),
                              ))
                        ]);
                      } else {
                        return CircularProgressIndicator();
                      }
                    }))));
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
