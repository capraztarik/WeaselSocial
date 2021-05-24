import 'package:cloud_firestore/cloud_firestore.dart';


class UserClass {
  final String email;
  final String id;
  final String photoUrl;
  final String username;
  final String displayName;
  final String bio;
  final int followerCount;
  final int followingCount;
  /*final Map followers;
  final Map following;*/

  const UserClass(
      {this.username,
      this.id,
      this.photoUrl,
      this.email,
      this.displayName,
      this.bio,
      /*this.followers,
        this.following*/
      this.followerCount,
      this.followingCount});

  factory UserClass.fromDocument(DocumentSnapshot document) {
    return UserClass(
      username: document['username'],
      id: document.id,
      photoUrl: document['photoUrl'],
      email: document['email'],
      displayName: document['displayName'],
      bio: document['bio'],
      /*followers: document['followers'],
      following: document['following'],*/
    );
  }
}
