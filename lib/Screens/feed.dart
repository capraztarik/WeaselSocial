import 'package:flutter/material.dart';
//import 'package:weasel_social_media_app/Utilities/demo_values.dart';
import 'package:weasel_social_media_app/widgets/post.dart';

class Feed extends StatefulWidget {
  _Feed createState() => _Feed();
}

class _Feed extends State<Feed> with AutomaticKeepAliveClientMixin<Feed> {
  List<PostCard> feedData = [];

  @override
  void initState() {
    super.initState();
    this._loadFeed();
  }

  buildFeed() {
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

  _loadFeed() async {
    _generateFeed();
    setState(() {});
  }

  _getFeed() async {
    print("Starting getFeed");
    _generateFeed();
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  _generateFeed() {
    PostCard temp = PostCard(
      username: "tarikcapraz",
      location: "Istanbul",
      caption: "ThrowBack Thursday",
      mediaUrl:
          "https://www.apple.com/v/macbook-pro-16/c/images/meta/og__csakh451i0eq_large.png",
      postId: "001",
      ownerId: "001",
    );
    for (int x = 0; x < 4; x++) {
      feedData.add(temp);
    }
  }
}
