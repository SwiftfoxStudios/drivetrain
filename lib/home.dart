import 'package:flutter/material.dart';

import './analyse-screen/analyse-main.dart';
import './discover-screen/discover-main.dart';
import './record-screen/record-main.dart';

int bgDark = 0xff202020;
int bgLight = 0xff2e2e2e;
int accent = 0xffff5d54;

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  int _selectedIndex = 1;

  void navigatePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final pages = [DiscoverMain(), RecordMain(), AnalyseMain()];
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    final statusHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: deviceHeight / 10,
        child: BottomNavigationBar(
          backgroundColor: Color(bgDark),
          unselectedItemColor: Colors.white,
          unselectedFontSize: deviceHeight / 48,
          selectedFontSize: deviceHeight / 48,
          iconSize: deviceHeight / 25,
          selectedItemColor: Color(accent),
          currentIndex: _selectedIndex,
          onTap: navigatePage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.navigation),
              title: Text('DISCOVER'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.adjust),
              title: Text('RECORD'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.data_usage),
              title: Text('ANALYSE'),
            ),
          ],
        ),
      ),
    );
  }
}
