import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:weasel_social_media_app/Screens/Search.dart';
import 'package:weasel_social_media_app/Screens/profile.dart';
import 'feed.dart';
import 'notifications.dart';

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
    Notifications(),
    ProfilePage(
        username: "mesutozil",
        photoUrl:
            "https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg",
        displayName: "M10",
        bio: "Player for Fenerbahce",
        followerCount: 980,
        followingCount: 450),
  ];

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  void onTabTapped(int index) {
    _setLogEvent("Navigation Bar", "A button tapped on navigation bar.");
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _setLogEvent(String name, String action) async {
    await FirebaseAnalytics()
        .logEvent(name: name, parameters: <String, dynamic>{
      'action': action,
    });
    print('Custom event log succeeded');
  }

  Future<void> _setCurrentScreen() async {
    await FirebaseAnalytics().setCurrentScreen(
      screenName: 'Navigation Page',
    );
    print('setCurrentScreen succeeded');
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
