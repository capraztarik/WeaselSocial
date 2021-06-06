import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/models/post_info.dart';
import 'package:weasel_social_media_app/widgets/post_view.dart';

import '../main.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
  List<PostCard> feedData = [];
  List<PostInfo> postList = [];
  List<PostInfo> allPostList = [];
  Map<dynamic, dynamic> followingUsers = {};
  bool firstLoad = true;

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
    initialFunction().whenComplete(() => setState(() {
          firstLoad = false;
        }));
  }

  Future<void> initialFunction() async {
    await getPosts();
    await getFollowings();
    await _getFeed();
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
      screenName: 'Feed Page',
    );
    print('setCurrentScreen succeeded');
  }

  buildFeed() {
    /*This creates feed from list of PostCards*/
    if (feedData != null && feedData.length != 0) {
      return ListView(
        children: feedData,
      );
    } else if (feedData.length == 0) {
      return Center(
        child: Text(
          "No posts to show.",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }

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
          child: buildFeed(),
        ),
      );
    }
  }

  Future<void> getFollowings() async {
    DocumentSnapshot docSnapshot =
        await usersReference.doc(currentUserModel.uid).get();
    followingUsers = docSnapshot.data();
    followingUsers = followingUsers["followings"];
  }

  Future<void> getPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("posts").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      PostInfo temp = PostInfo.fromDocument(querySnapshot.docs[i]);
      allPostList.add(temp);
    }
  }

  Future<void> _refresh() async {
    print("refresh");
    allPostList.clear();
    followingUsers.clear();
    postList.clear();
    feedData.clear();
    await getPosts();
    await getFollowings();
    await _getFeed();
  }

  Future<void> _getFeed() async {
    /*TODO this would get feed info from backend then give it to generate feed*/
    print("Starting getFeed");
    _setLogEvent("Feed", "Posts refreshed.");
    /*post info list taken from backend would given to generatefeed with postList*/
    /*PostInfo temp = PostInfo(
        username: "mesutozil",
        caption: "ThrowBack Thursday",
        photoUrl:
            "https://www.yenicaggazetesi.com.tr/d/other/esgxywducae-yho.jpg",
        profilePhotoUrl:
            "https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg",
        likeCount: 59,
        uid: "USM7K6scz1ZlrC0kfMg6VWNj0Xc2");
    PostInfo temp2 = PostInfo(
        username: "neymar",
        caption: "Psg is the best",
        photoUrl: "https://www.trtspor.com.tr/resimler/366000/366896.jpg",
        profilePhotoUrl:
            "https://www.trtspor.com.tr/resimler/366000/366896.jpg",
        likeCount: 88,
        uid: "USM7K6scz1ZlrC0kfMg6VWNj0Xc*/
    int length = allPostList.length ?? 0;
    for (int x = 0; x < length; x++) {
      if (followingUsers.containsKey(allPostList[x].uid)) {
        if (checkDuplicate(allPostList[x], postList)) {
          postList.add(allPostList[x]);
        }
      }
    }
    _generateFeed(postList);
    setState(() {});
  }

  bool checkDuplicate(PostInfo temp, List<PostInfo> postList) {
    for (int x = 0; x < postList.length; x++) {
      if (postList[x].pid == temp.pid) return false;
    }
    return true;
  }

  @override
  bool get wantKeepAlive => true;

  _generateFeed(List<PostInfo> postList) {
    /* TODO Generates postCards(view) with information taken from backend*/
    int index = 0;
    while (index < postList.length) {
      PostCard temp = PostCard(
        username: postList[index].username ?? "",
        pid: postList[index].pid ?? "",
        uid: postList[index].uid ?? "",
        caption: postList[index].caption ?? "",
        mediaUrl: postList[index].photoUrl ?? "",
        profilePhotoUrl: postList[index].profilePhotoUrl ?? "",
        isLiked: (postList[index].likerList.contains(currentUserModel.uid)),
        likeCount: postList[index].likerList.length ?? 0,
      );
      feedData.add(temp);
      index++;
    }
  }
}
