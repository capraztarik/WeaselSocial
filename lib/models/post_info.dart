class PostInfo {
  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final String caption;
  final String location;
  final Map likerList;
  final int likeCount;

  const PostInfo(
      {this.username,
      this.photoUrl,
      this.profilePhotoUrl,
      this.location,
      this.caption,
      this.likeCount,
      this.likerList});
}
