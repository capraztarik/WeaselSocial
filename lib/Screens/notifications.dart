import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/widgets/notification_view.dart';
import 'package:weasel_social_media_app/models/notification.dart';

import '../main.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with AutomaticKeepAliveClientMixin<Notifications> {
  List<NotificationCard> notificationCardList = []; //views that we generated.
  List<notification_info> notificationList = []; //info taken from backend
  bool finished=false;
  bool firstLoad = true;

  void initState() {
    super.initState();
    this._getNotifications();
    _setCurrentScreen();
    initialFunction().whenComplete(() => setState(() {
      firstLoad = false;
    }));
  }

  Future<void> initialFunction() async {
    await _getNotifications();
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
      screenName: 'Notifications Page',
    );
    print('setCurrentScreen succeeded');
  }

  @override
  bool get wantKeepAlive => true;

  _generateNotifications(List<notification_info> notificationList) {
    /* TODO Generates notifCards(view) with information taken from backend*/
    notificationCardList.clear();
    int index = 0;
    while (index < notificationList.length) {
      NotificationCard temp = NotificationCard(
        username: notificationList[index].username,
        photoUrl: notificationList[index].photoUrl,
        notificationType: notificationList[index].notificationType,
        profilePhotoUrl: notificationList[index].profilePhotoUrl,
        uid:notificationList[index].uid,
      );
      notificationCardList.add(temp);
      index++;
    }
    finished=true;
  }

  buildNotifications() {
    /*This creates notif view from list of notif card views*/
    if(finished){
    if (notificationCardList.isNotEmpty) {
      return ListView(
        children: notificationCardList,
      );
    } else {
      return Center(
          child:Text("Welcome to Weasel, you will see your notifications here!"),
      );
    }
    }
    else{
      return Center(child: CircularProgressIndicator());
    }
  }

  _getNotifications() async {
    notificationList.clear();

    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("notifications").doc(currentUserModel.uid).collection("items").orderBy("timestamp", descending: true).get();
    for (int i = 0; i < querySnapshot.docs.length ?? 0; i++) {
      notification_info temp = notification_info.fromDocument(querySnapshot.docs[i]);
      notificationList.add(temp);
    }

    _generateNotifications(notificationList);
    setState(() {});
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
          child: buildNotifications(),
        ),
      );
    }
  }

  Future<Null> _refresh() async {
    await _getNotifications();

    _setLogEvent("Notifications", "Notifications refreshed.");

    setState(() {});

    return;
  }
}
