import 'package:gpx/gpx.dart';

class Activity {
  int timestamp;
  String title;
  String description;
  double distance;
  double climbed;
  int timeElapsedinSeconds;
  int movingTimeinSeconds;
  double averageVelocity;
  int caloriesBurnt;
  bool isPublic;
  int exertion;
  Gpx routeGpx;

  Activity(
      {this.timestamp,
      this.title,
      this.description,
      this.distance,
      this.climbed,
      this.timeElapsedinSeconds,
      this.movingTimeinSeconds,
      this.averageVelocity,
      this.caloriesBurnt,
      this.isPublic,
      this.exertion,
      this.routeGpx});
}
