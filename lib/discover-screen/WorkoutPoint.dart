class Point {
  String time;
  double lat, lon, elevation;
  int hr, power;

  Point(this.time, this.lat, this.lon, this.elevation, {this.hr, this.power});

  String toString() {
    return 'DataPoint: {time: $time, lat: $lat, lon: $lon, ele: $elevation, hr: $hr, power: $power}';
  }
}
