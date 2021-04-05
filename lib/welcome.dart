import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(image: new AssetImage("welcome_background.jpg"), fit: BoxFit.cover,),
              ),
            ),
            new Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child:Text(
                        'Weasel',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontFamily: "Rancho",
                            fontStyle:FontStyle.italic,
                            color: Colors.black87),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:370.0),
                      child: SignInButtonBuilder(
                        text: "Login",
                        icon:Icons.arrow_forward_ios_rounded,
                        onPressed: () {},
                        backgroundColor: Colors.blueGrey[200],
                      )
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: SignInButton(
                        Buttons.Email,
                        text: "Sign Up with Email",
                        onPressed: () {},
                        )

             ),


                  ]
              ),
            )
          ],
        )

    );

  }
}