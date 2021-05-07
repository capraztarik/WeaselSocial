import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weasel_social_media_app/widgets/notification_view.dart';
import 'package:weasel_social_media_app/models/notification.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with AutomaticKeepAliveClientMixin<Notifications> {
  List<NotificationCard> notificationCardList = [];//views that we generated.
  List<notification_info> notificationList =[];//info taken from backend

  void initState() {
    super.initState();
    this._getNotifications();
  }

  @override
  bool get wantKeepAlive => true;

  _generateNotifications(List <notification_info>notificationList) {/* TODO Generates notifCards(view) with information taken from backend*/
    int index=0;
    while(index<notificationList.length){
      NotificationCard temp = NotificationCard(
        username: notificationList[index].username,
        photoUrl: notificationList[index].photoUrl,
        notificationType: notificationList[index].notificationType,
        profilePhotoUrl:notificationList[index].profilePhotoUrl,
      );
      notificationCardList.add(temp);
      index++;
    }
  }
  buildNotifications() { /*This creates notif view from list of notif card views*/
    if (notificationCardList != null) {
      return ListView(
        children: notificationCardList,
      );
    } else {
      return Container(
          alignment: FractionalOffset.center,
          child: CircularProgressIndicator());
    }
  }
  _getNotifications()async { /*TODO this would get notifs info from backend then give it to generate list*/
    notification_info temp=notification_info(
        username:"mbappe",
        photoUrl:
        "https://www.yenicaggazetesi.com.tr/d/other/esgxywducae-yho.jpg",
        profilePhotoUrl:
        "https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg",
        notificationType:1
    );
    notification_info temp2=notification_info(
        username:"mbappe",
        photoUrl:
        "https://www.yenicaggazetesi.com.tr/d/other/esgxywducae-yho.jpg",
        profilePhotoUrl:
        "https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg",
        notificationType:2
    );
    notification_info temp3=notification_info(
        username:"mbappe",
        photoUrl:
        "https://www.yenicaggazetesi.com.tr/d/other/esgxywducae-yho.jpg",
        profilePhotoUrl:
        "https://i12.haber7.net//haber/haber7/photos/2021/11/devrekliler_maci_mesut_ozilin_locasindan_izledi_1615873131_6892.jpg",
        notificationType:0
    );
    for(int x=0;x<3;x++){
      notificationList.add(temp);
      notificationList.add(temp2);
      notificationList.add(temp3);
    }
    _generateNotifications(notificationList);
    setState(() {});
  }

  @override
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
        child: buildNotifications(),
      ),
    );
  }

  Future<Null> _refresh() async {
    await _getNotifications();

    setState(() {});

    return;
  }
}