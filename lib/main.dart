import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Screens/Search.dart';
import 'package:weasel_social_media_app/Screens/sign_up.dart';
import 'package:weasel_social_media_app/Screens/welcome.dart';
import 'package:weasel_social_media_app/Screens/Onboard.dart';
import 'Screens/Navigation.dart';
import 'Screens/feed.dart';
import 'Screens/login.dart';
import 'Screens/notifications.dart';
import 'Screens/profile.dart';

void main() => runApp(MaterialApp(
      home: Welcome(),
      initialRoute: '/onboard',
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboard': (context) => Onboard(),
        '/welcome': (context) => Welcome(),
        '/login': (context) => Login(),
        '/sign_up': (context) => SignUp(),
        '/search': (context) => SearchPage(),
        '/navigator': (context) => NormalBottomNavBar(),
        '/feed': (context) => Feed(),
        '/profile': (context) => ProfilePage(),//should go own profile
        '/notifications': (context) => Notifications(),
      },
    ));
