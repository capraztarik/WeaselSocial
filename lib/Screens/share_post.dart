import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import '../main.dart';

File file;
bool isVideo = false;

class Uploader extends StatefulWidget {
  _Uploader createState() => _Uploader();
}

class _Uploader extends State<Uploader> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool uploading = false;

  @override
  initState() {
    super.initState();
  }

  //method to get Location and save into variables
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white70,
          leading: IconButton(
              icon: Icon(Icons.clear, color: Colors.black),
              onPressed: clearImage),
          title: const Text(
            'New Post',
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: postImage,
                child: Text(
                  "Post",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ))
          ],
        ),
        body: ListView(
          children: <Widget>[
            PostForm(
              descriptionController: descriptionController,
              loading: uploading,
            ),
          ],
        ));
  }

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

  //method to build buttons with location.

  void postToFireStore(
      {String mediaUrl, String location, String description}) async {
    var reference = FirebaseFirestore.instance.collection('posts');

    reference.add({
      "username": currentUserModel.username,
      "likes": [],
      "comments": {},
      "mediaUrl": mediaUrl,
      "description": description,
      "ownerId": currentUserModel.uid,
      "profilePhotoUrl": currentUserModel.photoUrl,
      "timestamp": DateTime.now(),
    }).then((DocumentReference doc) {
      String docId = doc.id;
      reference.doc(docId).update({"postId": docId});
    });
    showAlertDialog("Success", "Post successfully shared.");
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postImage() {
    if (file != null) {
      setState(() {
        uploading = true;
      });
      uploadImage(file).then((String data) {
        postToFireStore(
          mediaUrl: data,
          description: descriptionController.text,
        );
      }).then((_) {
        setState(() {
          file = null;
          uploading = false;
          descriptionController.clear();
        });
      });
    } else {
      showAlertDialog("Error", "Please upload an image.");
    }
  }
}

class PostForm extends StatefulWidget {
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final bool loading;
  PostForm({this.descriptionController, this.loading, this.locationController});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  ImagePicker imagePicker = ImagePicker();

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

  _selectImage(BuildContext parentContext) async {
    return showDialog<Null>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.camera,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose Photo from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getImage(
                      source: ImageSource.gallery,
                      maxWidth: 1920,
                      maxHeight: 1200,
                      imageQuality: 80);
                  setState(() {
                    file = File(imageFile.path);
                  });
                }),
            SimpleDialogOption(
                child: const Text('Choose Video from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getVideo(
                    source: ImageSource.gallery,
                  );
                  setState(() {
                    file = File(imageFile.path);
                    isVideo = true;
                  });
                  showAlertDialog("Success", "Video successfully added.");
                }),
            SimpleDialogOption(
                child: const Text('Capture a Video'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile imageFile = await imagePicker.getVideo(
                    source: ImageSource.camera,
                  );
                  setState(() {
                    file = File(imageFile.path);
                    isVideo = true;
                  });
                }),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.loading
            ? LinearProgressIndicator()
            : Padding(padding: EdgeInsets.only(top: 0.0)),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(currentUserModel.photoUrl),
            ),
            Container(
              width: 250.0,
              child: TextField(
                controller: widget.descriptionController,
                decoration: InputDecoration(
                    hintText: "Write a caption...", border: InputBorder.none),
              ),
            ),
            GestureDetector(
              onTap: () async {
                _selectImage(context);
              },
              child: Container(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter,
                      image: (file == null || isVideo == true)
                          ? AssetImage("assets/images/add_photo.png")
                          : FileImage(file),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<String> uploadImage(var imageFile) async {
  var uuid = Uuid().v1();
  if (isVideo) {
    Reference ref =
        FirebaseStorage.instance.ref().child("posts/post_$uuid.mp4");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  } else {
    Reference ref =
        FirebaseStorage.instance.ref().child("posts/post_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}
