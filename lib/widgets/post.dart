import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Utilities/demo_values.dart';

class PostCard extends StatefulWidget {

  const PostCard(
    {  this.username,
      this.location,
      this.caption,
      this.mediaUrl,
      this.postId,
      this.ownerId,}
      );

  factory PostCard.fromJSON(Map data) {
    return PostCard(
      username: data['username'],
      location: data['location'],
      caption: data['caption'],
      mediaUrl: data['mediaUrl'],
      ownerId: data['ownerId'],
      postId: data['postId'],
    );
  }
  final String username;
  final String location;
  final String caption;
  final String postId;
  final String ownerId;
  final String mediaUrl;
  _PostCard createState() =>
      _PostCard(
        username: this.username,
        location: this.location,
        caption:this.caption,
        postId:this.postId,
      );
}

class _PostCard extends State<PostCard> {
  final String username;
  final String location;
  final String caption;
  final String postId;
  final String ownerId;
  int likeCount;
  bool liked=false;

  _PostCard(
      {
        this.username,
        this.location,
        this.caption,
        this.postId,
        this.likeCount,
        this.ownerId});



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
          _likePost(postId);
        });
  }
  void _likePost(String postId2) {
    bool _liked =false;

    if (_liked) {
      print('removing like');
      _liked=false;
      likeCount--;
    }

    if (!_liked) {
      print('liked');
       _liked=true;
      likeCount++;
  }
  }

  GestureDetector buildLikeableImage() {
    return GestureDetector(
      onDoubleTap: () => _likePost(postId),
      child: Image.asset(DemoValues.postImage)
    );
  }

  buildPostHeader({String ownerId}) {
    if (ownerId == null) {
      return Text("owner error");
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(DemoValues.userImage),
        backgroundColor: Colors.grey,
      ),
      title: GestureDetector(
        child: Text(username),
        onTap: () {
          //openProfile(context, ownerId);
        },
      ),
      subtitle: Text("location"),
      trailing: const Icon(Icons.more_vert),
    );

  }

  Widget build(BuildContext context) {
    final TextStyle titleTheme = Theme.of(context).textTheme.bodyText1;
    final TextStyle captionTheme = Theme.of(context).textTheme.bodyText2;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildPostHeader(ownerId: username),
        buildLikeableImage(),
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
                  goToComments(
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
  void goToComments(){}

}