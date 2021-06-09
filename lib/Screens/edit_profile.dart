import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:weasel_social_media_app/Screens/profile.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';
import 'package:weasel_social_media_app/main.dart';
import 'package:weasel_social_media_app/models/userclass.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  String username = currentUserModel.username;
  String displayname = currentUserModel.displayName;
  String bio = currentUserModel.bio;
  String picture = currentUserModel.photoUrl;
  bool isPrivate = currentUserModel.isPrivate;
  ImagePicker imagePicker = ImagePicker();
  File _image;
  PickedFile imageFile;
  String _uploadedFileURL = currentUserModel.photoUrl;
  final editKey = GlobalKey<FormState>();
  List<UserClass> allUsers = [];
  bool changeSuccess = false;

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

  Future<void> showAlertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      "Username already exists. Please try with a different username."),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    Reference ref =
        FirebaseStorage.instance.ref().child("profiles/pp_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> getUsers() async {
    QuerySnapshot querySnapshot = await usersReference.get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      UserClass temp = UserClass.fromDocument(querySnapshot.docs[i]);
      allUsers.add(temp);
    }
  }

  Future<void> applyChanges() async {
    bool flag = true;
    await getUsers();
    for (int x = 0; x < allUsers.length ?? 0; x++) {
      if (allUsers[x].uid != currentUserModel.uid &&
          allUsers[x].username == username) flag = false;
    }
    if (flag) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserModel.uid)
          .update({
        "username": username,
        "name": displayname,
        "bio": bio,
        "isPrivate": isPrivate,
        "profile_picture": _uploadedFileURL ?? currentUserModel.photoUrl,
      });
      DocumentSnapshot userRecord =
          await usersReference.doc(auth.currentUser.uid).get();
      currentUserModel = UserClass.fromDocument(userRecord);

      for (int i = 0; i < userPostList12.length ?? 0; i++) {
        if (userPostList12[i].uid == currentUserModel.uid) {
          FirebaseFirestore.instance
              .collection('posts')
              .doc(userPostList12[i].pid)
              .update({
            "profilePhotoUrl": _uploadedFileURL ?? currentUserModel.photoUrl,
          });
        }
      }
      changeSuccess = true;
    } else {
      changeSuccess = false;
      print("Username must be unique");
    }
  }

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: editKey,
          child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(_uploadedFileURL),
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
                      onPressed: () async {
                        //Navigator.pushNamed(context, '/feed');
                        imageFile = await imagePicker.getImage(
                            source: ImageSource.gallery,
                            maxWidth: 1920,
                            maxHeight: 1200,
                            imageQuality: 80);
                        setState(() {
                          _image = File(imageFile.path);
                        });
                        _uploadedFileURL = await uploadImage(_image);
                        setState(() {});
                      },
                      child: Text(
                        'Change Profile Picture',
                        style: kLabelTextStyle,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Display Name:',
                      style: kTextStyle,
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40.00, 0, 0, 0),
                      child: TextFormField(
                        onSaved: (String value) {
                          if (value != "") displayname = value;
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Private Profile:',
                      style: kTextStyle,
                    ),
                  ),
                  SizedBox(width: 40),
                  Switch(
                    value: isPrivate,
                    onChanged: (value) {
                      setState(() {
                        isPrivate = value;
                      });
                    },
                    activeTrackColor: Colors.greenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
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
                      padding: const EdgeInsets.fromLTRB(40.00, 0, 0, 0),
                      child: TextFormField(
                        onSaved: (String value) {
                          if (value != "") username = value;
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
                      padding: const EdgeInsets.fromLTRB(40.00, 0, 0, 0),
                      child: TextFormField(
                        onSaved: (String value) {
                          if (value != "") bio = value;
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
                  onPressed: () async {
                    changeSuccess = false;
                    _setLogEvent("Profile Edit", "Submit button pressed.");
                    if (editKey.currentState.validate()) {
                      editKey.currentState.save();
                      applyChanges().whenComplete(() {
                        if (changeSuccess) {
                          print("Success.");
                          Navigator.pushNamedAndRemoveUntil(context,
                              '/navigator', (Route<dynamic> route) => false);
                        } else {
                          showAlertDialog();
                          print("Changes are not saved.");
                        }
                      });
                    }
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
      ),
    );
  }
}
