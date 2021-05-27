import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Screens/Navigation.dart';
import 'Screens/Onboard.dart';
import 'Screens/Search.dart';
import 'Screens/feed.dart';
import 'Screens/login.dart';
import 'Screens/notifications.dart';
import 'Screens/profile.dart';
import 'Screens/edit_profile.dart';
import 'Screens/sign_up.dart';
import 'Screens/welcome.dart';
import 'welcomeNoFirebase.dart';
import 'Screens/share_post.dart';

final googleSignIn = GoogleSignIn();
User currentUserModel;
FirebaseAuth auth = FirebaseAuth.instance;
final usersReference = FirebaseFirestore.instance.collection('users');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return WelcomeViewNoFB();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Center(child: CircularProgressIndicator());
    }

    return MaterialApp(
      home: Onboard(),
      navigatorObservers: <NavigatorObserver>[observer],
      //initialRoute: '/onboard',
      debugShowCheckedModeBanner: false,
      routes: {
        '/onboard': (context) => Onboard(),
        '/welcome': (context) => Welcome(),
        '/login': (context) => Login(),
        '/sign_up': (context) => SignUp(),
        '/search': (context) => SearchPage(),
        '/navigator': (context) => NormalBottomNavBar(),
        '/feed': (context) => Feed(),
        '/profile': (context) => ProfilePage(),
        '/edit_profile': (context) => EditProfile(),
        '/notifications': (context) => Notifications(),
        '/share_post': (context) => Uploader(),
      },
    );
  }
}
