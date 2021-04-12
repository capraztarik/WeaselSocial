import 'dart:convert';
//import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:email_validator/email_validator.dart';
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
        }
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("white_background.jpg"), fit: BoxFit.fill,),
              ),
            ),
            new Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:250.0,left:40,right:40),
                          child:Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Enter Email",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w800,
                                  ),
                                  validator: (value) {
                                    if(value.isEmpty) {
                                      return 'Please enter your e-mail';
                                    }
                                    if(!EmailValidator.validate(value)) {
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
                            padding: const EdgeInsets.only(top:10.0,left:40,right:40),
                            child:Row(
                            children: [
                              Expanded(
                                flex: 1,

                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Username",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w800,
                                  ),
                                  keyboardType: TextInputType.text,

                                  validator: (value) {
                                    if(value.isEmpty) {
                                      return 'Please enter your e-mail';
                                    }
                                    if(value.length < 4) {
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
                            padding: const EdgeInsets.only(top:10.0,left:40,right:40),
                            child:Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration: new InputDecoration(
                                    labelText: "Password",
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(
                                      ),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w800,
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,

                                  validator: (value) {
                                    if(value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if(value.length < 8) {
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
                      padding: const EdgeInsets.only(top:10.0,left:40,right:40),
                  child:Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Password Again",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                          //fillColor: Colors.green
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w800,
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,

                        validator: (value) {
                          if(value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if(value.length < 8) {
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
                                  padding: const EdgeInsets.only(top:80.0),
                                  child: SignInButtonBuilder(
                                    text: "Sign Up",
                                    icon:Icons.arrow_forward_ios_rounded,
                                    onPressed: () {
                                      if(_formKey.currentState.validate()) {
                                        _formKey.currentState.save();

                                        if(pass != pass2) {
                                          showAlertDialog("Error", 'Passwords must match');
                                        }
                                        else {
                                          //TODO: Sign up process
                                        }
                                        //
                                        setState(() {
                                          attemptCount += 1;
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text('Logging in')));
                                      }
                                    },
                                    backgroundColor: Colors.blueGrey[200],
                                  )
                              ),


                        ],
                      )
                    )


                  ]
              ),
            )
          ],
        )


    );
  }
}