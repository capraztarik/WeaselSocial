import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Screens/comment_screen.dart';
import 'package:weasel_social_media_app/Screens/profile.dart';
import 'package:weasel_social_media_app/main.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController _cameraVideoPlayerController;
  String currentUserId = currentUserModel.uid;

  _PostCard(
      {this.username,
      this.caption,
      this.likeCount,
      this.uid,
      this.mediaUrl,
      this.profilePhotoUrl,
      this.liked});

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
    try {
      return GestureDetector(
        onDoubleTap: () => _likePost(/*postId*/),
        child: Image.network(mediaUrl),
      );
    } catch (e) {
      //THESE MEANS İT İS VİDEO
      _cameraVideoPlayerController = VideoPlayerController.network(mediaUrl)..initialize().then((_) {
        setState(() { });

      });
      return GestureDetector(
        onDoubleTap: () => _likePost(/*postId*/),
          onTap: () =>  _cameraVideoPlayerController.play(),
         onTapCancel:() =>_cameraVideoPlayerController.pause(),
        child: VideoPlayer(_cameraVideoPlayerController),
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
          trailing: GestureDetector(
            child: Icon(Icons.report_gmailerrorred_outlined),
            onTap: () {
              //openPostSettings();
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
