// Required imports for Google Material Design and Flutter Services
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import home page file
import './home.dart';

void main() {
  const bgDark = 0xff202020;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(bgDark),
    statusBarColor: Color(bgDark),
  ));
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sets important constants
    return new MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData(fontFamily: 'Poppins'), title: 'Drivetrain 0.2', home: new HomeMain());
  }
}
