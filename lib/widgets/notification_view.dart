import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    this.username,
    this.photoUrl,
    this.profilePhotoUrl,
    this.notificationType,
  });
  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final int notificationType;

  _NotificationCard createState() => _NotificationCard(
        username: this.username,
        photoUrl: this.photoUrl,
        profilePhotoUrl: this.profilePhotoUrl,
        notificationType: this.notificationType,
      );
}

class _NotificationCard extends State<NotificationCard> {
  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final int notificationType;
  int likeCount;
  bool followed = false;

  _NotificationCard({
    this.username,
    this.photoUrl,
    this.profilePhotoUrl,
    this.notificationType,
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
      int notificationType,
      String profilePhotoUrl,
      String photoUrl}) {
    String notification;
    if (ownerId == null) {
      return Text("owner error");
    }
    if (notificationType == 0) {
      notification = "followed you.";
    }
    if (notificationType == 1) {
      notification = "liked your post.";
    }
    if (notificationType == 2) {
      notification = "comment on your post.";
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
            //openProfile(context, ownerId);
          },
        ),
        subtitle: Text(notification),
        trailing: GestureDetector(
          child: Image.network(photoUrl),
          onTap: () {
            //openPost();
          },
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
  void goToProfile() {}
  void acceptFollowRequest() {}
  void declineFollowRequest() {}
}
