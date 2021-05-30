import 'package:cloud_firestore/cloud_firestore.dart';

class UserClass {
  final String uid;
  final String photoUrl;
  final String username;
  final String displayName;
  final String bio;
  final Map followers;
  final Map following;
  final bool isPrivate;

  const UserClass({
    this.username,
    this.uid,
    this.photoUrl,
    this.displayName,
    this.bio,
    this.followers,
    this.following,
    this.isPrivate,
  });

  factory UserClass.fromDocument(DocumentSnapshot document) {
    return UserClass(
      username: document['username'],
      uid: document.id,
      photoUrl: document['profile_picture'],
      displayName: document['name'],
      bio: document['bio'],
      followers: document['followers'],
      following: document['following'],
      isPrivate: document['isPrivate']
    );
  }
}
