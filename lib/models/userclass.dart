class UserClass {
  final String email;
  final String id;
  final String photoUrl;
  final String username;
  final String displayName;
  final String bio;
  /*final Map followers;
  final Map following;*/
  final int followerCount;
  final int followingCount;

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
}
