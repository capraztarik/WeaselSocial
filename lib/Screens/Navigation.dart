import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weasel_social_media_app/Screens/Search.dart';
import 'feed.dart';

class NormalBottomNavBar extends StatefulWidget {
  NormalBottomNavBar({Key key}) : super(key: key);

  @override
  NormalBottomNavBarState createState() => NormalBottomNavBarState();
}

class NormalBottomNavBarState extends State<NormalBottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Feed(),
    SearchPage(),
    Feed(),
    SearchPage(),
    Feed(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], //
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, //
        currentIndex: _currentIndex, //
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.home_filled,
              color: Colors.black87,
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black87,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.black87,
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.black87,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_rounded,
              color: Colors.black87,
            ),
            label: 'Profile',
          ),
        ],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        selectedItemColor: Colors.black87,
      ),
    );
  }
}
