import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Screens/profile.dart';

import '../main.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    this.username,
    this.photoUrl,
    this.profilePhotoUrl,
    this.notificationType,
    this.uid,
  });
  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final String notificationType;
  final String uid;

  _NotificationCard createState() => _NotificationCard(
        username: this.username,
        photoUrl: this.photoUrl,
        profilePhotoUrl: this.profilePhotoUrl,
        notificationType: this.notificationType,
        uid: this.uid,
      );
}

class _NotificationCard extends State<NotificationCard> {
  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final String uid;
  final String notificationType;
  int likeCount;
  bool followed = false;
  String logineduseruid = currentUserModel.uid;
  _NotificationCard({
    this.username,
    this.photoUrl,
    this.profilePhotoUrl,
    this.notificationType,
    this.uid,
  });
  Color _iconColor = Colors.black26;

  GestureDetector buildFollowIcon() {
    Color color;
    IconData icon;

    if (currentUserModel.followings.containsKey(widget.uid) &&
        currentUserModel.followings[widget.uid] == true) followed = true;
    if (followed) {
      color = Colors.pink;
      icon = Icons.auto_awesome;
    } else {
      color = Colors.grey;
      icon = Icons.person_add;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 40.0,
          color: color,
        ),
        onTap: () {
          if (followed) {
            color = Colors.grey;
            icon = Icons.person_add;
            unfollow();
          } else {
            color = Colors.pink;
            icon = Icons.auto_awesome;
            follow();
          }
        });
  }

  buildTrailer() {
    if (notificationType == "like" || notificationType == "comment") {
      return Image.network(photoUrl);
    } else if (notificationType == "follow") {
      return buildFollowIcon();
    } else if (notificationType == "followrequest") {
      return Container(
        height: 50,
        width: 100,
        child: Row(children: <Widget>[
          IconButton(
            icon: Icon(Icons.check_circle_rounded, color: _iconColor),
            onPressed: () {
              setState(() {
                _iconColor = Colors.green;
                acceptRequest();
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.do_not_disturb, color: _iconColor),
            onPressed: () {
              setState(() {
                _iconColor = Colors.red;
                unfollow();
              });
            },
          ),
        ]),
      );
    }
  }

  buildNotification(
      {String ownerId,
      String notificationType,
      String profilePhotoUrl,
      String photoUrl}) {
    String notification;
    if (ownerId == null) {
      return Text("owner error");
    }
    if (notificationType == "follow") {
      notification = "followed you.";
    }
    if (notificationType == "like") {
      notification = "liked your post.";
    }
    if (notificationType == "comment") {
      notification = "comment on your post.";
    }
    if (notificationType == "followrequest") {
      notification = "requested to follow you.";
    }
    if (photoUrl.contains("mp4")) {
      if (notificationType == "like") {
        notification = "liked your video.";
      }
      if (notificationType == "comment") {
        notification = "comment on your video.";
      }
      return ListTile(
        leading: CircleAvatar(
          //backgroundImage: AssetImage(DemoValues.userImage),
          backgroundImage: NetworkImage(profilePhotoUrl),
          backgroundColor: Colors.grey,
        ),
        title: GestureDetector(
          child: Text(ownerId),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: this.uid),
              ),
            );
          },
        ),
        subtitle: Text(notification),
        trailing: Icon(
          Icons.play_circle_outline_rounded,
          size: 40,
        ),
      );
    } else
      return ListTile(
          leading: CircleAvatar(
            //backgroundImage: AssetImage(DemoValues.userImage),
            backgroundImage: NetworkImage(profilePhotoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            child: Text(ownerId),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(uid: this.uid),
                ),
              );
            },
          ),
          subtitle: Text(notification),
          trailing: GestureDetector(
            child: buildTrailer(),
          ));
  }

  Widget build(BuildContext context) {
    //final TextStyle titleTheme = Theme.of(context).textTheme.bodyText1;
    //final TextStyle captionTheme = Theme.of(context).textTheme.bodyText2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildNotification(
            ownerId: this.username,
            notificationType: this.notificationType,
            profilePhotoUrl: this.profilePhotoUrl,
            photoUrl: this.photoUrl),
      ],
    );
  }

  void goToPost() {}
  void follow() {
    print('following user');

    usersReference.doc(currentUserModel.uid).update({'followings.$uid': true});
    usersReference.doc(uid).update({'followers.$logineduseruid': true});

    FirebaseFirestore.instance
        .collection("notifications")
        .doc(uid)
        .collection("items")
        .add({
      "username": currentUserModel.username,
      "userId": currentUserModel.uid,
      "type": "follow",
      "userProfileImg": currentUserModel.photoUrl,
      "timestamp": Timestamp.now(),
      "mediaUrl": ""
    });
  }

  void unfollow() {
    usersReference.doc(currentUserModel.uid).update({'followings.$uid': false});
    usersReference.doc(uid).update({'followers.$logineduseruid': false});
  }

  void acceptRequest() {
    print('following user');
    usersReference.doc(currentUserModel.uid).update({'followers.$uid': true});
    usersReference.doc(uid).update({'followings.$logineduseruid': true});

    setState(() {
      _iconColor = Colors.green;
    });
  }
}
