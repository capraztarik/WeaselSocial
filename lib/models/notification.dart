class notification_info {

  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final String uid;
  final int notificationType; /*it can be like or comment 1 or 2*/

  const notification_info(
      {this.username,
        this.photoUrl,
        this.profilePhotoUrl,
        this.notificationType,
        this.uid,
      });
}