import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Screens/sign_up.dart';
import 'package:weasel_social_media_app/Screens/welcome.dart';
import 'package:weasel_social_media_app/Screens/Onboard.dart';
import 'Screens/feed.dart';
import 'Screens/login.dart';

void main() => runApp(MaterialApp(
      //home: Welcome(),
      home:Feed(), //for debugging purposes.

      //initialRoute: '/onboard',
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboard': (context) => Onboard(),
        '/welcome': (context) => Welcome(),
        '/login': (context) => Login(),
        '/sign_up': (context) => SignUp(),
      },
    ));
