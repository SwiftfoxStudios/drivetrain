import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './record-page/record-main.dart';

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
        title: 'Welcome to Flutter',
        home: new RecordMain());
  }
}
