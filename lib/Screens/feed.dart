import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/models/post_info.dart';
import 'package:weasel_social_media_app/widgets/post_view.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
  List<PostCard> feedData = [];
  List<PostInfo> postList = [];

  @override
  void initState() {
    _setCurrentScreen();
    super.initState();
    this._getFeed();
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
    if (feedData != null) {
      return ListView(
        children: feedData,
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

  Future<Null> _refresh() async {
    await _getFeed();

    setState(() {});

    return;
  }

  _getFeed() async {
    /*TODO this would get feed info from backend then give it to generate feed*/
    print("Starting getFeed");
    _setLogEvent("Feed", "Posts refreshed.");
    /*post info list taken from backend would given to generatefeed with postList*/
    PostInfo temp = PostInfo(
      username: "mesutozil",
      location: "Istanbul",
      caption: "ThrowBack Thursday",
      photoUrl:
          "https://www.yenicaggazetesi.com.tr/d/other/esgxywducae-yho.jpg",
      profilePhotoUrl:
          "https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg",
      likeCount: 59,
      uid:"USM7K6scz1ZlrC0kfMg6VWNj0Xc2"
    );
    PostInfo temp2 = PostInfo(
      username: "neymar",
      location: "Paris",
      caption: "Psg is the best",
      photoUrl: "https://www.trtspor.com.tr/resimler/366000/366896.jpg",
      profilePhotoUrl: "https://www.trtspor.com.tr/resimler/366000/366896.jpg",
      likeCount: 88,
        uid:"USM7K6scz1ZlrC0kfMg6VWNj0Xc2"
    );
    List<PostInfo> postList = [];
    for (int x = 0; x < 3; x++) {
      postList.add(temp);
      postList.add(temp2);
    }
    _generateFeed(postList);
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  _generateFeed(List<PostInfo> postList) {
    /* TODO Generates postCards(view) with information taken from backend*/
    int index = 0;
    while (index < postList.length) {
      PostCard temp = PostCard(
        username: postList[index].username,
        location: postList[index].location,
        uid:postList[index].uid,
        caption: postList[index].caption,
        mediaUrl: postList[index].photoUrl,
        profilePhotoUrl: postList[index].profilePhotoUrl,
      );
      feedData.add(temp);
      index++;
    }
  }
}
