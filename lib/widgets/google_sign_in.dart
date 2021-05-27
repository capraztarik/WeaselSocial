import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Utilities/google_auth.dart';
import 'package:weasel_social_media_app/models/userclass.dart';

import '../main.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            )
          : ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.all(Colors.indigo[800]),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User user =
                    await Authentication.signInWithGoogle(context: context);

                CollectionReference users =
                    FirebaseFirestore.instance.collection('users');
                //currentUserModel = auth.currentUser;
                users
                    .doc(auth.currentUser.uid)
                    .set({
                      "uid": auth.currentUser.uid,
                      'username': auth.currentUser.email,
                      'bio': "Default bio",
                      "name": auth.currentUser.email,
                      "profileState": "public",
                      "profile_picture":
                          "https://firebasestorage.googleapis.com/v0/b/weaselsocial.appspot.com/o/Splash.png?alt=media&token=ced17135-e65c-47fa-8cd3-3570130b1309",
                      "followers": {},
                      "following": {},
                    })
                    .then((value) => print("User Added"))
                    .catchError((error) => print("Failed to add user: $error"));

                DocumentSnapshot userRecord =
                    await usersReference.doc(auth.currentUser.uid).get();
                currentUserModel = UserClass.fromDocument(userRecord);

                setState(() {
                  _isSigningIn = false;
                });

                if (user != null) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/navigator', (Route<dynamic> route) => false);
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 23, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 18.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
