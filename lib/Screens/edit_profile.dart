import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  String username;
  String displayname;
  String bio;
  String picture;

  Future<void> _setLogEvent(String name, String action) async {
    await FirebaseAnalytics()
        .logEvent(name: name, parameters: <String, dynamic>{
      'action': action,
    });
    print('Custom event log succeeded');
  }

  Future<void> _setCurrentScreen() async {
    await FirebaseAnalytics().setCurrentScreen(
      screenName: 'Profile Edit Page',
    );
    print('setCurrentScreen succeeded');
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> rcvdData =
        ModalRoute.of(context).settings.arguments;
    username = rcvdData["username"];
    displayname = rcvdData["displayname"];
    bio = rcvdData["bio"];
    picture = rcvdData["picture"];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87),
        ),
        backgroundColor: Colors.grey[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(picture),
                  backgroundColor: Colors.grey,
                ),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/feed');
                      //TODO: Change Picture
                    },
                    child: Text(
                      'Change Profile Picture',
                      style: kLabelTextStyle,
                    ),
                  ),
                )
              ],
            ),
            Divider(color: Colors.grey, height: 40, thickness: 1),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Name:',
                    style: kTextStyle,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60.00, 0, 0, 0),
                    child: TextFormField(
                      onSaved: (String value) {
                        displayname = value;
                      },
                      decoration: InputDecoration(
                        hintText: displayname,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey, height: 1, thickness: 1, indent: 150),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Username:',
                    style: kTextStyle,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25.00, 0, 0, 0),
                    child: TextFormField(
                      onSaved: (String value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                        hintText: username,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey, height: 1, thickness: 1, indent: 150),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Biography:',
                    style: kTextStyle,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28.00, 0, 0, 0),
                    child: TextFormField(
                      onSaved: (String value) {
                        bio = value;
                      },
                      decoration: InputDecoration(
                        hintText: bio,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // TODO push new values to database
                  _setLogEvent("Profile Edit", "Submit button pressed.");
                },
                child: Text(
                  'Submit Changes',
                  style: kLabelTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
