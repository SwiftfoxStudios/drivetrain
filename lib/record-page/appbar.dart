import 'package:flutter/material.dart';

const bgDark = 0xff202020;

class LogoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            body: Container(
                height: deviceHeight / 14,
                width: deviceWidth,
                color: Color(bgDark),
                child: Align(
                    alignment: Alignment(-0.96, 0),
                    child: Text("RECORD",
                        style:
                            TextStyle(fontSize: 30, color: Colors.white))))));
  }
}
