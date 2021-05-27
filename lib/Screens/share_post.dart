import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';

File file;

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

  //method to build buttons with location.

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  void postImage() {
    /*setState(() {
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
      });
    });*/
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
                child: const Text('Choose from Gallery'),
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
              backgroundImage: NetworkImage(
                  "https://www.trtspor.com.tr/resimler/366000/366896.jpg"), /*todo currentUserModel.photoUrl*/
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
                      image: file == null
                          ? NetworkImage(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/OOjs_UI_icon_add.svg/768px-OOjs_UI_icon_add.svg.png")
                          : FileImage(file),
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: widget.locationController,
              decoration: InputDecoration(
                  hintText: "Where was this photo taken?",
                  border: InputBorder.none),
            ),
          ),
        )
      ],
    );
  }
}

Future<String> uploadImage(var imageFile) async {
  var uuid = Uuid().v1();
  Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
  UploadTask uploadTask = ref.putFile(imageFile);

  String downloadUrl = await (await uploadTask).ref.getDownloadURL();
  return downloadUrl;
}

/*void postToFireStore(
    {String mediaUrl, String location, String description}) async {
  var reference = FirebaseFirestore.instance.collection('insta_posts');

  reference.add({
    "username": currentUserModel.username,
    "location": location,
    "likes": {},
    "mediaUrl": mediaUrl,
    "description": description,
    "ownerId": googleSignIn.currentUser.id,
    "timestamp": DateTime.now(),
  }).then((DocumentReference doc) {
    String docId = doc.id;
    reference.doc(docId).update({"postId": docId});
  });
}*/
