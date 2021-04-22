//import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:weasel_social_media_app/Utilities/color.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';
//import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int attemptCount;
  String username;
  String pass;
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
                                        labelText: "Username",
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
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        username = value;
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
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      if (pass.length == 0) {
                                        //TODO
                                        showAlertDialog(
                                            "Error", 'Passwords must match');
                                      } else {
                                        //TODO: Sign up process
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/navigator',
                                            (Route<dynamic> route) => false);
                                      }
                                      //
                                      setState(() {
                                        attemptCount += 1;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Logging in')));
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
