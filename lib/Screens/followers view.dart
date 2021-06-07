import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/main.dart';
import 'package:weasel_social_media_app/models/userclass.dart';
import 'package:weasel_social_media_app/widgets/Followers_view.dart';


class Followers_view extends StatefulWidget {
  @override
  _Followers_viewState createState() => _Followers_viewState();
}

class _Followers_viewState extends State<Followers_view>
    with AutomaticKeepAliveClientMixin<Followers_view> {
  List<FollowersCard> followersCardList = []; //views that we generated.
  List<UserClass> followersList = []; //info taken from backend
  List<UserClass> AllUsers = [];
  List<UserClass> followerUsersfinal = [];
  List<UserClass> followingUsersfinal = [];
  bool firstLoad = true;

  String id=currentUserModel.uid;

  void initState() {
    super.initState();
    _setCurrentScreen();
    initialFunction().whenComplete(() => setState(() {
      firstLoad = false;
    }));;
  }

  Future<void> _setLogEvent(String name, String action) async {
    await FirebaseAnalytics()
        .logEvent(name: name, parameters: <String, dynamic>{
      'action': action,
    });
    print('Custom event log succeeded');
  }

  Future<void> initialFunction() async {
    await getuser();
    await _getFollowers();
    await _getFollowings();
  }

  Future<void> _setCurrentScreen() async {
    await FirebaseAnalytics().setCurrentScreen(
      screenName: 'Notifications Page',
    );
    print('setCurrentScreen succeeded');
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> getuser() async {
    QuerySnapshot querySnapshot = await usersReference.get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      UserClass temp = UserClass.fromDocument(querySnapshot.docs[i]);
      AllUsers.add(temp);
    }
  }

  _getFollowers() async {
    for (int x = 0; x < AllUsers.length; x++) {
      for (int y = 0; x < AllUsers[x].followings.length; y++) {
        if (AllUsers[x].followings[y] == id) {
          followerUsersfinal.add(AllUsers[x]);
        }
      }
    }
    _generateFollowers(followerUsersfinal);
  }

  _generateFollowers(List<UserClass> followerUsersfinal) {
    /* TODO Generates notifCards(view) with information taken from backend*/
    int index = 0;
    while (index < followerUsersfinal.length) {
      FollowersCard temp = FollowersCard(
        username: followerUsersfinal[index].username,
        profilePhotoUrl: followerUsersfinal[index].photoUrl,
        uid:followerUsersfinal[index].uid,
      );
      followersCardList.add(temp);
      index++;
    }
  }

  /*_generateFollowings(List<UserClass> _followersList) {
    int index = 0;
    while (index < _followersList.length) {
      FollowersCard temp = FollowersCard(
        username: _followersList[index].username,
        profilePhotoUrl: _followersList[index],
        uid:_followersList[index].uid,
      );
      followersCardList.add(temp);
      index++;
    }
  }*/

  buildFollowers() {
    if (followersCardList != null && followersCardList.length != 0) {
      return ListView(
        children: followersCardList,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: Text(
            'No followers to show.'
          ));
    }
  }


  _getFollowings() async {
    for (int x = 0; x < AllUsers.length; x++) {
      for (int y = 0; x < AllUsers[x].followers.length; y++) {
        if (AllUsers[x].followers[y] == id) {
          followingUsersfinal.add(AllUsers[x]);
        }
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (firstLoad) {
      return Scaffold(
          body: SafeArea(
            child: Center(
                child: Container(
                    height: 50, width: 50, child: CircularProgressIndicator())),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white30,
          title: Text(
            "Weasel",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: buildFollowers(),
        ),
      );
    }
  }

  Future<Null> _refresh() async {
    await getuser();
    await _getFollowers();
    await _getFollowings();
    await _generateFollowers;

    _setLogEvent("_getFollowers, getFollowings", "Following ans Followers refreshed.");

    setState(() {});

    return;
  }
}