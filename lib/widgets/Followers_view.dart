import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Screens/profile.dart';

class FollowersCard extends StatefulWidget {
  const FollowersCard({
    this.username,
    this.profilePhotoUrl,
    this.notificationType,
    this.uid,
  });
  final String profilePhotoUrl;
  final String username;
  final int notificationType;
  final String uid;

  _FollowersCard createState() => _FollowersCard(
    username: this.username,
    profilePhotoUrl: this.profilePhotoUrl,
    notificationType: this.notificationType,
    uid: this.uid,
  );
}

class _FollowersCard extends State<FollowersCard> {

  final String profilePhotoUrl;
  final String username;
  final String uid;
  final int notificationType;
  int likeCount;
  bool followed = false;

  _FollowersCard({
    this.username,
    this.profilePhotoUrl,
    this.notificationType,
    this.uid,
  });

  GestureDetector buildFollowIcon() {
    Color color;
    IconData icon;

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
          size: 25.0,
          color: color,
        ),
        onTap: () {
          //follow(postId);
        });
  }

  buildNotification(
      {String ownerId,
        String profilePhotoUrl}) {
    String notification;

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
      );
  }

  Widget build(BuildContext context) {
    //final TextStyle titleTheme = Theme.of(context).textTheme.bodyText1;
    //final TextStyle captionTheme = Theme.of(context).textTheme.bodyText2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildNotification(
            ownerId: this.username,
            profilePhotoUrl: this.profilePhotoUrl,
            ),
      ],
    );
  }

  void goToPost() {}

  void acceptFollowRequest() {}
  void declineFollowRequest() {}
}