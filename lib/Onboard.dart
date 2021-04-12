//import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/welcome.dart';

class Onboard extends StatefulWidget {
  @override
  _Onboard createState() => _Onboard();
}
class _Onboard extends State<Onboard> {
  int pageIndex=0;
  List<String> titles=[
    "Welcome to Weasel, the cutest network ",
    "Connect your friends around the Word!",
    "Lets Weasel !!!"];
  List<String> descriptions=[
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
  ];

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => Welcome()),
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
                        Padding(
                          padding: const EdgeInsets.only(top:180.0),
                          child:Text(
                            titles[pageIndex],
                            style: TextStyle(
                                fontSize: 40.0,
                                fontFamily: "Rancho",
                                fontStyle:FontStyle.italic,
                                color: Colors.black87),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top:44.0),
                            child:Text(
                              descriptions[pageIndex],
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: "Rancho",
                                  fontStyle:FontStyle.italic,
                                  color: Colors.black87),
                            ),
                        ),
                      Padding(
                          padding: const EdgeInsets.only(top:20.0),
                          child:ElevatedButton(
                            child: Text('Next'),
                            onPressed: () {
                              if(pageIndex==2){
                                _onIntroEnd(context);
                                setState(
                                        () {}
                                );
                              }
                              else{
                                pageIndex++;
                              setState(
                                      () {}
                              );
                              }
                            }

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