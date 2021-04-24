import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Utilities/color.dart';
import 'package:weasel_social_media_app/widgets/post_view.dart';
import 'package:weasel_social_media_app/models/user.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';
import 'package:weasel_social_media_app/models/user.dart';
import 'package:weasel_social_media_app/models/post_info.dart';

class EditProfile extends StatefulWidget{
  @override
  _EditProfile createState() => _EditProfile();


}


class _EditProfile extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text(
          'Edit Profile',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[400],
      ),
        body: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage('https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg'),
                        backgroundColor: Colors.grey,
                      ),
                    )
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                      child: OutlineButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/feed');
                            //TODO: Change Picture
                          },
                          child: Text(
                            'Change Profile Picture',
                          style: kLabelTextStyle,
                          ),
                        ),
                    ),
                  )
                ],
              ),
              Divider(color: Colors.grey, height: 40, thickness: 1),

      Row(
        children: [
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(18.0),
                child:
                Text(
                  'Name:',
                  style: kTextStyle,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60.00,0,0,0),
            child: Column(
              children: [
                OutlineButton(onPressed:(){
                  Navigator.pushNamed(context, '/feed');
                  //TODO: Change Picture

                },
                  child: Text('mesut'),

                )
              ],
            ),
          ),
        ],

      ),

              Divider(color: Colors.grey, height: 1, thickness: 1, indent: 150),
              Row(
                children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child:
                    Text(
                      'Username:',
                      style: kTextStyle,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25.00,0,0,0),
                child: Column(
                  children: [
                    OutlineButton(onPressed:(){
                      Navigator.pushNamed(context, '/feed');
                      //TODO: Change Picture

                    },
                      child: Text('mesutozil'),

                    )
                  ],
                ),
              ),
                ],

              ),
              Divider(color: Colors.grey, height: 1, thickness: 1, indent: 150),
              Row(
                children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child:
                    Text(
                      'Biography:',
                      style: kTextStyle,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.00,0,0,0),
                child: Column(
                  children: [
                    OutlineButton(onPressed:(){
                      Navigator.pushNamed(context, '/feed');
                      //TODO: Change Picture

                    },
                      child: Text('M10 Player for Fenerbahçe'),

                    )
                  ],
                ),
              ),
                ],

              )
    ],),);








}}


