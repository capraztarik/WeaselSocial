import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/sign_up.dart';
import 'package:weasel_social_media_app/welcome.dart';
import 'package:weasel_social_media_app/Onboard.dart';
import 'login.dart';



void main() => runApp(MaterialApp(
  home: Welcome(),
  initialRoute: '/onboard',
  routes: {
    '/onboard': (context) => Onboard(),
    '/welcome': (context) => Welcome(),
    '/login': (context) => Login(),
    '/sign_up': (context) => SignUp(),
  },
));