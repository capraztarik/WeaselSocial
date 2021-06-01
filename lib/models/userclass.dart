import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  final String uid;
  final String photoUrl;
  final String username;
  final String displayName;
  final String bio;
  final Map followers;
  final Map followings;
  final bool isPrivate;

  const UserClass({
    this.username,
    this.uid,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.followers,
    this.followings,
    this.isPrivate,
  });

  List<UserClass> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data();

      return UserClass(
          username: dataMap['username'],
          bio: dataMap['bio'],
          photoUrl: dataMap['profile_picture'],
          uid: dataMap['uid'],
          displayName: dataMap['name'],
          isPrivate: dataMap['isPrivate']);
    }).toList();
  }

  factory UserClass.fromDocument(DocumentSnapshot document) {
    return UserClass(
        username: document['username'],
        uid: document.id,
        photoUrl: document['profile_picture'],
        displayName: document['name'],
        bio: document['bio'],
        followers: document['followers'],
        followings: document['followings'],
        isPrivate: document['isPrivate']);
  }
}
