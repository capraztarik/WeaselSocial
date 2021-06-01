import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Screens/profile.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    this.username,
    this.uid,
    this.location,
    this.caption,
    this.mediaUrl,
    this.profilePhotoUrl,
    this.likeCount,
  });

  factory PostCard.fromJSON(Map data) {
    return PostCard(
      username: data['username'],
      uid: data['uid'],
      location: data['location'],
      caption: data['caption'],
      mediaUrl: data['mediaUrl'],
      profilePhotoUrl: data['profilePhotoUrl'],
    );
  }
  final String username;
  final String uid;
  final String location;
  final String caption;
  final String mediaUrl;
  final String profilePhotoUrl;
  final int likeCount;
  _PostCard createState() => _PostCard(
        username: this.username,
        location: this.location,
        caption: this.caption,
        uid:this.uid,
        mediaUrl: this.mediaUrl,
        profilePhotoUrl: this.profilePhotoUrl,
        likeCount: this.likeCount,
      );
}

class _PostCard extends State<PostCard> {
  final String username;
  final String location;
  final String caption;
  final String mediaUrl;
  final String uid;
  final String profilePhotoUrl;
  int likeCount;
  bool liked = false;

  _PostCard({
    this.username,
    this.location,
    this.caption,
    this.likeCount,
    this.uid,
    this.mediaUrl,
    this.profilePhotoUrl,
  });

  GestureDetector buildLikeIcon() {
    Color color;
    IconData icon;

    if (liked) {
      color = Colors.pink;
      icon = Icons.favorite;
    } else {
      color = Colors.grey;
      icon = Icons.favorite;
    }

    return GestureDetector(
        child: Icon(
          icon,
          size: 25.0,
          color: color,
        ),
        onTap: () {
          //_likePost(postId);
        });
  }

  void _likePost(/*String postId2*/) {
    bool _liked = false;

    if (_liked) {
      print('removing like');
      _liked = false;
      this.likeCount--;
    }

    if (!_liked) {
      print('liked');
      _liked = true;
      this.likeCount++;
    }
  }

  GestureDetector buildLikeableImage({String mediaUrl}) {
    return GestureDetector(
      onDoubleTap: () => _likePost(/*postId*/),
      child: Image.network(mediaUrl),
    );
  }

  buildPostHeader({String ownerId, String location, String profilePhotoUrl}) {
    if (ownerId == null) {
      return Text("owner error");
    }

    return GestureDetector(
            child:ListTile(
              leading: CircleAvatar(
                //backgroundImage: AssetImage(DemoValues.userImage),
                backgroundImage: NetworkImage(profilePhotoUrl),
                backgroundColor: Colors.grey,
              ),
                title:  Text(ownerId),

                subtitle: Text(location),
                trailing: GestureDetector(
                  child: Icon(Icons.more_vert),
                onTap: () {
                  //openPostSettings();
                },
          )
            ),
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
            ownerId: this.username,
            location: this.location,
            profilePhotoUrl: this.profilePhotoUrl),
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
                  goToComments();
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

  void goToComments() {}
}
