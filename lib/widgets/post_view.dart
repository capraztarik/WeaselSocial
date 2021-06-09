import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Screens/comment_screen.dart';
import 'package:weasel_social_media_app/Screens/profile.dart';
import 'package:weasel_social_media_app/main.dart';
import 'package:better_player/better_player.dart';
import 'package:weasel_social_media_app/models/post_info.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {this.username,
      this.pid,
      this.uid,
      this.caption,
      this.mediaUrl,
      this.profilePhotoUrl,
      this.likeCount,
      this.isLiked});

  factory PostCard.fromJSON(Map data) {
    return PostCard(
        username: data['username'],
        uid: data['uid'],
        pid: data['postId'],
        caption: data['caption'],
        mediaUrl: data['mediaUrl'],
        profilePhotoUrl: data['profilePhotoUrl'],
        isLiked: data['isLiked'],
        likeCount: data['likeCount']);
  }
  final String username;
  final String uid;
  final String pid;
  final String caption;
  final String mediaUrl;
  final String profilePhotoUrl;
  final int likeCount;
  final bool isLiked;

  _PostCard createState() => _PostCard(
      username: this.username,
      caption: this.caption,
      uid: this.uid,
      mediaUrl: this.mediaUrl,
      profilePhotoUrl: this.profilePhotoUrl,
      likeCount: this.likeCount ?? 0,
      liked: this.isLiked);
}

class _PostCard extends State<PostCard> {
  final String username;
  final String caption;
  final String mediaUrl;
  final String uid;
  final String profilePhotoUrl;
  int likeCount = 0;
  bool liked = false;
  List<PostInfo> allPostList = [];
  String currentUserId = currentUserModel.uid;
  _PostCard(
      {this.username,
      this.caption,
      this.likeCount,
      this.uid,
      this.mediaUrl,
      this.profilePhotoUrl,
      this.liked});

  @override

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      setState(() {
        color = Colors.pink;
        icon = Icons.favorite;
      });
    } else {
      setState(() {
        color = Colors.grey;
        icon = Icons.favorite;
      });
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          _likePost();
        });
  }

  bool checkList(List<PostInfo> tempList) {
    int index = tempList.indexWhere((element) =>
        (element.uid == currentUserId && element.pid == widget.pid));
    if (index == -1)
      return false;
    else
      return true;
  }

  Future<void> showAlertDialog() async {
    String edit = widget.caption;
    return showDialog<void>(
        context: context,
        barrierDismissible: false, //User must tap button
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit Post Caption"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextField(
                    onChanged: (value) {
                      edit = value;
                    },
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Submit'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.pid)
                      .update({
                    "description": edit,
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _likePost(/*String postId2*/) {
    //bool _liked = false;

    if (liked) {
      print('removing like');
      setState(() {
        liked = false;
      });
      FirebaseFirestore.instance.collection("posts").doc(widget.pid).update({
        'likes': FieldValue.arrayRemove([currentUserId])
      });
      this.likeCount--;
      FirebaseFirestore.instance
          .collection("notifications")
          .doc(widget.uid) //post owners uid.
          .collection("items") //post owners notifs
          .doc(currentUserModel.uid) //delete that likers notif
          .delete();
    } else {
      print('liked');
      setState(() {
        liked = true;
      });
      FirebaseFirestore.instance.collection("posts").doc(widget.pid).update({
        'likes': FieldValue.arrayUnion([currentUserId])
      });
      this.likeCount++;
      FirebaseFirestore.instance
          .collection("notifications")
          .doc(widget.uid)
          .collection("items")
          .add({
        "username": currentUserModel.username,
        "userId": currentUserModel.uid,
        "type": "like",
        "userProfileImg": currentUserModel.photoUrl,
        "timestamp": Timestamp.now(),
        "postId": widget.pid,
        "mediaUrl": widget.mediaUrl,
      });
    }
  }

  GestureDetector buildLikeableImage({String mediaUrl}) {
    if (mediaUrl.contains('jpg')) {
      return GestureDetector(
        onDoubleTap: () => _likePost(/*postId*/),
        child: Image.network(mediaUrl),
      );
    } else {
      return GestureDetector(
        onDoubleTap: () => _likePost(),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer.network(
           mediaUrl,
            betterPlayerConfiguration: BetterPlayerConfiguration(
              aspectRatio: 16 / 9,
            ),
          ),
        )
      );
    }
  }

  buildPostHeader({String ownerId, String profilePhotoUrl}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return GestureDetector(
      child: ListTile(
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(uid: widget.uid),
                ),
              );
            },
            child: CircleAvatar(
              //backgroundImage: AssetImage(DemoValues.userImage),
              backgroundImage: NetworkImage(profilePhotoUrl),
              backgroundColor: Colors.grey,
            ),
          ),
          title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(uid: widget.uid),
                  ),
                );
              },
              child: Text(ownerId)),
          //subtitle: Text(""),
          trailing: PopupMenuButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            itemBuilder: (context) {
              List<PopupMenuEntry<Object>> list = [];
              if (widget.uid == currentUserId) {
                list.add(
                    PopupMenuItem(child: Text("Edit Post"), value: "edit"));
              } else
                list.add(PopupMenuItem(child: Text("Report"), value: "report"));
              return list;
            },
            icon: Icon(Icons.menu, size: 25),
            onSelected: (value) {
              if (value == "edit") {
                showAlertDialog();
                print("edit pressed");
              } else {
                var reference =
                    FirebaseFirestore.instance.collection('reports');
                reference.add({
                  "reported_post": widget.pid,
                  "reported_user_id": widget.uid,
                  "reported_username": widget.username,
                  "reporting_user": currentUserId,
                  "reported_post_caption": widget.caption,
                  "reported_post_media": widget.mediaUrl,
                  "timestamp": DateTime.now(),
                });
                print("Successfully reported.");
              }
            },
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(uid: uid),
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    final TextStyle titleTheme = Theme.of(context).textTheme.bodyText1;
    //final TextStyle captionTheme = Theme.of(context).textTheme.bodyText2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(
            ownerId: this.username, profilePhotoUrl: this.profilePhotoUrl),
        buildLikeableImage(mediaUrl: this.mediaUrl),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(left: 20.0, top: 40.0)),
            buildLikeIcon(),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            GestureDetector(
                child: const Icon(
                  Icons.comment,
                  size: 25.0,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        postId: widget.pid,
                        postOwner: widget.uid,
                        postMediaUrl: widget.mediaUrl,
                      ),
                    ),
                  );
                }),
            Padding(padding: const EdgeInsets.only(right: 20.0)),
            GestureDetector(
                child: const Icon(
                  Icons.repeat,
                  size: 25.0,
                ),
                onTap: () async {
                  allPostList.clear();
                  var reference =
                      FirebaseFirestore.instance.collection('posts');
                  QuerySnapshot querySnapshot = await reference.get();

                  for (int i = 0; i < querySnapshot.docs.length; i++) {
                    PostInfo temp =
                        PostInfo.fromDocument(querySnapshot.docs[i]);
                    allPostList.add(temp);
                  }

                  if (!checkList(allPostList)) {
                    print("Post reshared");
                    reference.add({
                      "username": currentUserModel.username,
                      "likes": [],
                      "comments": {},
                      "mediaUrl": widget.mediaUrl,
                      "description": widget.caption,
                      "ownerId": currentUserModel.uid,
                      "profilePhotoUrl": currentUserModel.photoUrl,
                      "timestamp": DateTime.now(),
                    }).then((DocumentReference doc) {
                      String docId = doc.id;
                      reference.doc(docId).update({"postId": widget.pid});
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 4),
                        content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Post successfully reshared",
                                style: TextStyle(fontSize: 15),
                              ),
                            ])));
                  } else
                    print("Post already exists");
                })
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: titleTheme,
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Text(
                  "$username ",
                  style: titleTheme,
                )),
            Expanded(child: Text(caption)),
          ],
        )
      ],
    );
  }
}
