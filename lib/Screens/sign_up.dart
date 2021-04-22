//import 'dart:convert';
//import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:weasel_social_media_app/Utilities/color.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';
//import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  int attemptCount;
  String mail;
  String pass;
  String pass2;
  String userName;
  final _formKey = GlobalKey<FormState>();

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

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/white_background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 220.0, left: 40, right: 40),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Enter Email",
                                  fillColor: AppColors.primary,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
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
                                  mail = value;
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
                                  labelText: "Username",
                                  fillColor: AppColors.primary,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                style: kLabelTextStyle,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your e-mail';
                                  }
                                  if (value.length < 4) {
                                    return 'Username is too short';
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  userName = value;
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
                                  fillColor: AppColors.primary,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
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
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 40, right: 40),
                          child: Row(children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Password Again",
                                  fillColor: AppColors.primary,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(),
                                  ),
                                  //fillColor: Colors.green
                                ),
                                keyboardType: TextInputType.text,
                                style: kLabelTextStyle,
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
                                  pass2 = value;
                                },
                              ),
                            ),
                          ])),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: SignInButtonBuilder(
                          text: "Sign Up",
                          fontSize: 16,
                          icon: Icons.arrow_forward_ios_rounded,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              if (pass != pass2) {
                                showAlertDialog(
                                    "Error", 'Passwords must match');
                              } else {
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/navigator',
                                    (Route<dynamic> route) => false);
                              }
                              //
                              setState(() {
                                attemptCount += 1;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Logging in')));
                            }
                          },
                          backgroundColor: AppColors.buttonColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
