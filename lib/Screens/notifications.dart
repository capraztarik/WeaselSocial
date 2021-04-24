import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


var followerList = [
  {
    "id": "1",
    "name": "Abidin Gokcekaya",
  },
  {
    "id": "2",
    "name": "Mert Kolabas",
  },
  {
    "id": "1",
    "name": "Sabanciuniv",
  },
  {
    "id": "1",
    "name": "Hamilton",
  },
  {
    "id": "1",
    "name": "vettel",
  },
  {
    "id": "1",
    "name": "istanbulpark",
  },
];

var likesList = [
  {
    "id": "1",
    "name": "Abidin Gokcekaya",
  },
  {
    "id": "2",
    "name": "Mert Kolabas",
  },
  {
    "id": "1",
    "name": "Sabanciuniv",
  },
  {
    "id": "1",
    "name": "Hamilton",
  },
  {
    "id": "1",
    "name": "vettel",
  },
  {
    "id": "1",
    "name": "istanbulpark",
  },
];

var commentList = [
  {
    "id": "1",
    "name": "Abidin Gokcekaya",
  },
  {
    "id": "2",
    "name": "Mert Kolabas",
  },
  {
    "id": "1",
    "name": "Sabanciuniv",
  },
  {
    "id": "1",
    "name": "Hamilton",
  },
  {
    "id": "1",
    "name": "vettel",
  },
  {
    "id": "1",
    "name": "istanbulpark",
  },
];



class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build (buildContext) {
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
        body: ListView(
            children:[
              SizedBox(height: 5,),
              Container(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Follow Requests',
                    style: TextStyle(fontSize: 22,
                      color:Colors.black,
                      fontWeight: FontWeight.w400
                  ),
                    textAlign: TextAlign.start,
                  ),
                ),
                height: 40,
                width: 10,
              ),
              ListView.builder
                (
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: followerList.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (buildContext, int index) {
                    return Column(
                      children: [
                        Container(
                            height: 50,
                            color: Colors.white10,
                            padding: const EdgeInsets.all(2),
                            margin: EdgeInsets.all(2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.blueAccent,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 5,
                                  height: 5,
                                ),

                                Expanded(
                                  child: Text(followerList[index]["name"] + " " + "started following you.",
                                    overflow: TextOverflow.clip, style: TextStyle(fontSize: 20),
                                  ),
                                flex: 1,
                                ),
                              ],
                            )
                        ),
                      ],
                    );
                  }
              ),
              Divider(
                color: Colors.grey,
                height: 20.0,
                thickness: 2.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child:Text(
                  'Likes',
                  style: TextStyle(fontSize: 22,
                      color:Colors.black,
                      fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.left,
                ),
                  height: 20,
                  width: 20,
                ),
              ),
              ListView.builder
                (
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: likesList.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (buildContext, int index) {
                    return Column(
                      children: [
                        Container(
                            height: 50,
                            color: Colors.white10,
                            padding: const EdgeInsets.all(2),
                            margin: EdgeInsets.all(2),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.red,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 5,
                                  height: 5,
                                ),

                                Expanded(
                                  child: Text(likesList[index]["name"] + " " + "liked you.",overflow: TextOverflow.clip, style: TextStyle(fontSize: 20),

                                  ),
                                flex: 1,
                                ),
                              ],
                            )
                        ),
                      ],
                    );
                  }
              ),
              Divider(
                color: Colors.grey,
                height: 20.0,
                thickness: 2.0,
              ),
              SizedBox(height: 5,),
              Container(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Comments',
                    style: TextStyle(fontSize: 22,
                        color:Colors.black,
                        fontWeight: FontWeight.w400
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                height: 40,
                width: 10,
              ),
              ListView.builder
                (
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: commentList.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (buildContext, int index) {
                    return Column(
                      children: [
                        Container(
                            height: 50,
                            color: Colors.white10,
                            padding: const EdgeInsets.all(2),
                            margin: EdgeInsets.all(2),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.add_comment,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                                SizedBox(
                                  width: 5,
                                  height: 5,
                                ),
                                Expanded(
                                  child: Text(commentList[index]["name"] + " " + "commented on your post.",overflow: TextOverflow.clip,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                    flex:1),
                              ],
                            )
                        ),
                      ],
                    );
                  }
              ),

            ]
        )
    );
  }
}