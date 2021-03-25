import 'package:flutter/material.dart';

import './analyse-screen/analyse-main.dart';
import './discover-screen/discover-main.dart';
import './record-screen/record-main.dart';

// Constants for colour schemes
int bgDark = 0xff202020;
int bgLight = 0xff2e2e2e;
int accent = 0xffff5d54;

// Home Page Widget Creator
class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

// Home Page Main Class
class _HomeMainState extends State<HomeMain> {
  // Changes view of slider for choice of traversal
  int _selectedIndex = 1;

  void navigatePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of Child pages
  final pages = [DiscoverMain(), RecordMain(), AnalyseMain()];
  @override
  // Page Builder
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
