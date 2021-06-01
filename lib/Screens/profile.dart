import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weasel_social_media_app/main.dart';
import 'package:weasel_social_media_app/widgets/post_view.dart';
import '../models/userclass.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({this.uid});

  final String uid;
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  //String currentUserId
  bool isFollowing = false;
  bool firstLoad = true;
  bool followButtonClicked = false;
  int postCount = 0;
  List<Image> userPosts = []; //should be filled by backend
  UserClass currentProfile;

  @override
  void initState() {
    super.initState();
    this._getUserPosts();
    postCount = userPosts.length ?? 0;
    _setCurrentScreen();
    getUserCred().whenComplete(() => setState(() {
          firstLoad = false;
        }));
  }

  Future<void> getUserCred() async {
    DocumentSnapshot userRecord = await usersReference.doc(widget.uid).get();
    currentProfile = UserClass.fromDocument(userRecord);
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signOut() async {
    _setLogEvent("Profile", "User Signed out.");
    await auth.signOut();
    await googleSignIn.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, '/welcome', (Route<dynamic> route) => false);
  }

  Future<void> _setLogEvent(String name, String action) async {
    await FirebaseAnalytics()
        .logEvent(name: name, parameters: <String, dynamic>{
      'action': action,
    });
    print('Custom event log succeeded');
  }

  Future<void> _setCurrentScreen() async {
    await FirebaseAnalytics().setCurrentScreen(
      screenName: 'Profile Page',
    );
    print('setCurrentScreen succeeded');
  }

  _getUserPosts() async {
    //should get UserPosts from backend
    print("Starting getting Posts");
    _setLogEvent("Profile", "Profile posts fetched.");
    Image temp = Image.network(
        "https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg");

    for (int x = 0; x < 13; x++) {
      userPosts.add(temp);
    }

    setState(() {});
  }

  editProfile() {
    Navigator.pushNamed(context, '/edit_profile', arguments: {
      "username": currentProfile.username,
      "displayname": currentProfile.displayName,
      "bio": currentProfile.bio,
      "picture": currentProfile.photoUrl
    });
  }

  unfollowUser() {}
  followUser() {}

  @override
  Widget build(BuildContext context) {
    super.build(context);

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

    Container buildProfileFollowButton(UserClass user) {
      // viewing your own profile - should show edit button
      if (currentUserModel.username == currentProfile.username) {
        //should be current_user.username ==this.username but we cant do current user right now.
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

    if (firstLoad) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white30,
            centerTitle: true,
            title: Text(
              "TechScape",
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
                child: Container(
                    height: 50, width: 50, child: CircularProgressIndicator())),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.logout),
                color: Colors.black87,
                onPressed: () {
                  signOut();
                })
          ],
          backgroundColor: Colors.white30,
          title: Text(
            currentProfile.username,
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 24),
              Row(children: <Widget>[
                CircleAvatar(
                  radius: 55.0,
                  backgroundImage: NetworkImage(currentProfile.photoUrl),
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
                          SizedBox(width: 12),
                          buildStatColumn("posts", postCount),
                          buildStatColumn("followers",
                              currentProfile.followers.length ?? 0),
                          buildStatColumn("following",
                              currentProfile.following.length ?? 0),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(width: 12),
                            buildProfileFollowButton(currentUserModel)
                          ]),
                    ],
                  ),
                )
              ]),
              Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 12.0, left: 10.0),
                  child: Text(
                    currentProfile.displayName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 1.0, left: 10.0),
                child: Text(currentProfile.bio),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1.5,
                  mainAxisSpacing: 0.10,
                  shrinkWrap: true,
                  children: userPosts,
                ),
              ),
            ]),
      );
    }
  }

  // state would kept when switching pages
  @override
  bool get wantKeepAlive => true;

  Container buildFollowButton(
      {String text,
      Color backgroundcolor,
      Color textColor,
      MaterialColor borderColor,
      function}) {
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
                style:
                    TextStyle(color: textColor, fontWeight: FontWeight.bold)),
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
            )),
      );
    }));
  }

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => clickedImage(context),
        child: Image.network(imagePost.mediaUrl, fit: BoxFit.cover));
  }
}
