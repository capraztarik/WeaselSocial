import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/Utilities/styles.dart';
import 'package:weasel_social_media_app/models/post_info.dart';
import 'package:weasel_social_media_app/models/userclass.dart';
import 'package:weasel_social_media_app/widgets/post_view.dart';
import '../Utilities/custom_search_delegates.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../main.dart';
import 'profile.dart';

class SearchPage extends StatefulWidget {
  final String query;
  final String pageState;

  SearchPage({this.query, this.pageState});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<UserClass> userList = [];
  Future<QuerySnapshot> userDocs;

  void initState() {
    super.initState();
    _setCurrentScreen();
    print(widget.query);
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
      screenName: 'Search Page',
    );
    print('setCurrentScreen succeeded');
  }

  int _currentState = 0;
  bool boolState = false;

  Widget swapTile() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      firstChild: userSearchView(widget.query),
      secondChild: postSearchView(widget.query),
      crossFadeState:
          boolState ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.pageState != "search")
          ? AppBar(
              backgroundColor: Colors.white30,
              title: Text(
                "Weasel",
                style: TextStyle(color: Colors.black87),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    _setLogEvent("Search", "Search button pressed.");
                    showSearch(
                      context: context,
                      delegate: SearchWithSuggestionDelegate(),
                    );
                  },
                ),
              ],
            )
          : AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              elevation: 2,
            ),
      body: ListView(
        children: [
          Center(
            child: Container(
              height: 50,
              //width: MediaQuery.of(context).size.width,
              child: ToggleSwitch(
                cornerRadius: 0.0,
                minWidth: MediaQuery.of(context).size.width,
                fontSize: 17.0,
                initialLabelIndex: _currentState,
                activeBgColor: Color(0xFF03B898),
                activeFgColor: Colors.black87,
                inactiveBgColor: Colors.white,
                inactiveFgColor: Colors.black87,
                labels: ['Username', 'Post Content'],
                onToggle: (index) {
                  print('switched to: $index');
                  setState(() {
                    _currentState = index;
                    if (index == 0)
                      boolState = false;
                    else
                      boolState = true;
                  });
                },
              ),
            ),
          ),
          swapTile(),
        ],
      ),
    );
  }
}

Widget userSearchView(String query) {
  final ScrollController controller = new ScrollController();
  return StreamBuilder<QuerySnapshot>(
      stream: (query != " " && query != null)
          ? FirebaseFirestore.instance
              .collection('users')
              .where('username', isGreaterThanOrEqualTo: query)
              .where('username', isLessThan: query + 'z')
              .snapshots()
          : FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                controller: controller,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, i) {
                  DocumentSnapshot data = snapshot.data.docs[i];
                  return userSearchUI(data["uid"], data["username"],
                      data["profile_picture"], context);
                },
              );
      });
}

Widget postSearchView(String query) {
  List<PostCard> feedData = [];
  List<PostInfo> searchedPostList = [];

  List<PostCard> _generateFeed(List<PostInfo> postList) {
    /*Generates postCards(view) with information taken from backend*/
    int index = 0;
    List<PostCard> feedData = [];
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
    return feedData;
  }

  return StreamBuilder<QuerySnapshot>(
      stream: (query != " " && query != null)
          ? FirebaseFirestore.instance
              .collection('posts')
              .where('description', isGreaterThanOrEqualTo: query)
              .where('description', isLessThan: query + 'z')
              .snapshots()
          : FirebaseFirestore.instance.collection("posts").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(child: CircularProgressIndicator()));
        } else
          print("done");
        QuerySnapshot querySnapshot = snapshot.data;
        searchedPostList.clear();
        feedData.clear();
        for (int i = 0; i < querySnapshot.docs.length ?? 0; i++) {
          PostInfo temp = PostInfo.fromDocument(querySnapshot.docs[i]);
          searchedPostList.add(temp);
        }
        feedData = _generateFeed(searchedPostList);
        ScrollController _controller = new ScrollController();
        return ListView(
          scrollDirection: Axis.vertical,
          controller: _controller,
          shrinkWrap: true,
          children: feedData,
        );
      });
}

Widget userSearchUI(
    String key, String name, String imageUrl, BuildContext context) {
  return Container(
    child: Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(uid: key),
                      ),
                    );
                  },
                  child: Row(children: <Widget>[
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage('$imageUrl'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      '$name',
                      style: kTextStyle,
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget postSearchUI(
    var key, String name, String profileImageUrl, String postImageUrl) {
  return Container(
    child: Column(
      children: <Widget>[
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage('$profileImageUrl'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                    ),
                    Text(
                      '$name',
                      style: kTextStyle,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('$postImageUrl'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
