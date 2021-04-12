//import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/welcome.dart';

class Onboard extends StatefulWidget {
  @override
  _Onboard createState() => _Onboard();
}

class _Onboard extends State<Onboard> {
  int pageIndex = 0;
  bool _visible = false;
  List<String> titles = [
    "Welcome to Weasel",
    "Connect with your friends!",
    "Lets Weasel !!!"
  ];
  List<String> descriptions = [
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
  ];

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Welcome()),
    );
  }

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  Widget build(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: Text(
                    titles[pageIndex],
                    style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: "Rancho",
                        fontStyle: FontStyle.italic,
                        color: Colors.black87),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: 190.0,
                  height: 190.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/onboard_image_1.jpg')),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 44.0),
                  child: Text(
                    descriptions[pageIndex],
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Rancho",
                        fontStyle: FontStyle.italic,
                        color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Visibility(
                        visible: _visible,
                        child: ElevatedButton(
                            child: Text('Previous'),
                            onPressed: () {
                              if (pageIndex == 1) {
                                _toggle();
                              }
                              pageIndex--;
                              setState(() {});
                            }),
                      ),
                      ElevatedButton(
                          child: Text('Next'),
                          onPressed: () {
                            if (pageIndex == 0) {
                              _toggle();
                            }
                            if (pageIndex == 2) {
                              _onIntroEnd(context);
                              setState(() {});
                            } else {
                              pageIndex++;
                              setState(() {});
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
