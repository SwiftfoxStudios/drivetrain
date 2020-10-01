import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Poppins'),
        title: 'Drivetrain 0.1.0pr-8',
        home: new HomeMain());
  }
}
