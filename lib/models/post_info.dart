import 'package:cloud_firestore/cloud_firestore.dart';

class PostInfo {
  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final String uid;
  final String pid;
  final String caption;
  final List likerList;
  final int likeCount;

  const PostInfo(
      {this.username,
      this.uid,
      this.pid,
      this.photoUrl,
      this.profilePhotoUrl,
      this.caption,
      this.likeCount,
      this.likerList});

  factory PostInfo.fromDocument(DocumentSnapshot document) {
    return PostInfo(
        username: document['username'],
        uid: document['ownerId'],
        pid: document['postId'],
        photoUrl: document['mediaUrl'],
        profilePhotoUrl: document['profilePhotoUrl'],
        caption: document['description'],
        likerList: document['likes'],
        likeCount: document['likes'].length);
  }
}
