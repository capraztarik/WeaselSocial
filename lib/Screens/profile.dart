import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Utilities/demo_values.dart';
import 'package:weasel_social_media_app/widgets/post.dart';
import 'package:weasel_social_media_app/widgets/user.dart';
import 'package:weasel_social_media_app/main.dart';
import 'dart:async';
//import 'edit_profile_page.dart';
//import 'models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({this.userId});

  final String userId;

  _ProfilePage createState() => _ProfilePage(this.userId);
}

class _ProfilePage extends State<ProfilePage> with AutomaticKeepAliveClientMixin<ProfilePage> {
  final String profileId;
  //String currentUserId
  String view = "grid"; // default view
  bool isFollowing = false;
  bool followButtonClicked = false;
  int postCount = 0;
  List<Image> userPosts=[];
  int followerCount = 850;
  int followingCount = 273;
  _ProfilePage(this.profileId);

  @override
  void initState() {
    super.initState();
    this._getUserPosts();
    postCount=userPosts.length;
  }

  _getUserPosts() async {
    print("Starting getting Posts");
    Image temp=Image.network("https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg");

    for (int x = 0; x < 13; x++) {
      userPosts.add(temp);
    }

    setState(() {});
  }
  editProfile(){
    Navigator.pushNamed(context, '/editProfile');
  }
  unfollowUser(){

  }
  followUser(){

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    User user = User(
      username:"mesutoezil",
        id:"mesutozil",
        photoUrl:"https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg",
        email:"tc@gmail.com",
        displayName:"M10 ",
        bio:"Player for Fenerbahçe.",
        /*followers"",
        following"",*/
      );

    Column buildStatColumn(String label, int number) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            number.toString(),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          Container(
              margin: const EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400),
              ))
        ],
      );
    }

    Container buildProfileFollowButton(User user) {
      // viewing your own profile - should show edit button
      if (user.id == profileId) {
        return buildFollowButton(
          text: "Edit Profile",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: editProfile,
        );
      }

      // already following user - should show unfollow button
      if (isFollowing) {
        return buildFollowButton(
          text: "Unfollow",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey,
          function: unfollowUser,
        );
      }

      // does not follow user - should show follow button
      if (!isFollowing) {
        return buildFollowButton(
          text: "Follow",
          backgroundcolor: Colors.blue,
          textColor: Colors.white,
          borderColor: Colors.blue,
          function: followUser,
        );
      }

      return buildFollowButton(
          text: "loading...",
          backgroundcolor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.grey);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white30,
        title: Text(
          this.profileId,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:24),
            Row(
            children: <Widget>[
                CircleAvatar(
                    radius: 55.0,
                    backgroundImage: NetworkImage(user.photoUrl),
                    backgroundColor: Colors.grey,
                  ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(width:12),
                        buildStatColumn("posts", postCount),
                        buildStatColumn("followers",followerCount),
                        buildStatColumn("following", followingCount),
                      ],
                    ),
                    Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(width:12),
                          buildProfileFollowButton(user)
                        ]),
                  ],
                ),
              )
            ]
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 12.0,left:10.0),
                child: Text(
                  user.displayName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 1.0,left:10.0),
              child: Text(user.bio),
            ),
            Expanded(
              child:GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 1.5,
                mainAxisSpacing: 0.10,
                shrinkWrap: true,
                children: userPosts,
                ),

              ),
          ]
      ),
    );

  }

  // state would kept when switching pages
  @override
  bool get wantKeepAlive => true;

  Container buildFollowButton({String text, Color backgroundcolor, Color textColor, MaterialColor borderColor, function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: TextButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
                color: backgroundcolor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5.0)),
            alignment: Alignment.center,
            child: Text(text,
                style: TextStyle(
                    color: textColor, fontWeight: FontWeight.bold)),
            width: 250.0,
            height: 27.0,
          )),
    );
  }
}

class ImageTile extends StatelessWidget {
  final PostCard imagePost;

  ImageTile(this.imagePost);

  clickedImage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute<bool>(builder: (BuildContext context) {
      return Center(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Photo',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  child: imagePost,
                ),
              ],
            )
        ),
      );
    })
    );
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => clickedImage(context),
        child: Image.network(imagePost.mediaUrl, fit: BoxFit.cover));
  }
}