import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/sign_up.dart';
import 'package:weasel_social_media_app/welcome.dart';

import 'login.dart';



void main() => runApp(MaterialApp(
  //home: Welcome(),
  //initialRoute: '/login',
  routes: {
    '/': (context) => Welcome(),
    '/login': (context) => Login(),
    '/sign_up': (context) => SignUp(),
  },
));