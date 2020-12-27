import 'package:gpx/gpx.dart';

class Activity {
  int timestamp;
  String title;
  String description;
  double distance;
  int timeElapsedinSeconds;
  double averageVelocity;
  int caloriesBurnt;
  bool isPublic;
  int exertion;
  Gpx routeGpx;

  Activity({this.timestamp, this.title, this.description, this.distance, this.timeElapsedinSeconds, this.averageVelocity, this.caloriesBurnt, this.isPublic, this.exertion, this.routeGpx});
}
