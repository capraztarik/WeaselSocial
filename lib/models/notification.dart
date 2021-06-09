import 'package:cloud_firestore/cloud_firestore.dart';

class notification_info {
  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final String uid;
  final String
      notificationType; /*it can be= like , comment, follow,followrequest*/

  const notification_info({
    this.username,
    this.photoUrl,
    this.profilePhotoUrl,
    this.notificationType,
    this.uid,
  });

  factory notification_info.fromDocument(DocumentSnapshot document) {
    return notification_info(
        username: document['username'],
        photoUrl: document['mediaUrl'] ?? "",
        notificationType: document['type'],
        uid: document['userId'],
        profilePhotoUrl: document['userProfileImg']);
  }
}
