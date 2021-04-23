import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:weasel_social_media_app/Utilities/color.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/welcome_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    'Weasel',
                    style: kHeadingTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 370.0),
                  child: SignInButtonBuilder(
                    text: "Login",
                    fontSize: 16,
                    icon: Icons.arrow_forward_ios_rounded,
                    elevation: 5,
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    backgroundColor: AppColors.buttonColor,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SignInButtonBuilder(
                      //Buttons.Email,
                      icon: Icons.mail,
                      text: "Sign Up with Email",
                      elevation: 5,
                      fontSize: 16,
                      backgroundColor: Colors.brown[600],
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_up');
                      },
                    )),
              ]),
        )
      ],
    ));
  }
}