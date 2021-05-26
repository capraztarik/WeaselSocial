import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:weasel_social_media_app/Utilities/color.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int attemptCount;
  String email;
  String pass;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is signed out');
      } else {
        print('User is signed in');
      }
    });
    _setCurrentScreen();
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
      screenName: 'Login Page',
    );
    print('setCurrentScreen succeeded');
  }

  Future<void> showAlertDialog(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(message),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential =
          await auth.signInWithEmailAndPassword(email: email, password: pass);
      print(userCredential.toString());
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      _setLogEvent("Login", "Successful login.");

      Navigator.pushNamedAndRemoveUntil(
          context, '/navigator', (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      if (e.code == 'user-not-found') {
        showAlertDialog("Error", 'User not found. Please sign up.');
      } else if (e.code == 'wrong-password') {
        showAlertDialog("Error", 'Please check your password');
      }
    }
  }

  Widget build(BuildContext context) {
    print('Build called');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/white_background.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 250.0, left: 40, right: 40),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        fillColor: AppColors.primary,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(),
                                        ),
                                        //fillColor: Colors.green
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      style: kLabelTextStyle,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your e-mail';
                                        }
                                        if (!EmailValidator.validate(value)) {
                                          return 'The e-mail address is not valid';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        email = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 40, right: 40),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(),
                                        ),
                                        //fillColor: Colors.green
                                      ),
                                      style: kLabelTextStyle,
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        if (value.length < 8) {
                                          return 'Password must be at least 8 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        pass = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 80.0),
                                child: SignInButtonBuilder(
                                  text: "Login",
                                  fontSize: 16,
                                  icon: Icons.arrow_forward_ios_rounded,
                                  onPressed: () {
                                    _setLogEvent(
                                        "Login", "Login button pressed.");

                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 25),
                                        content: Row(
                                          children: <Widget>[
                                            CircularProgressIndicator(),
                                            Text("  Logging In...")
                                          ],
                                        ),
                                      ));

                                      loginUser();
                                    } else {
                                      attemptCount += 1;
                                    }
                                  },
                                  backgroundColor: AppColors.buttonColor,
                                )),
                          ],
                        ))
                  ]),
            )
          ],
        ));
  }
}
