class Notification {

  final String photoUrl;
  final String profilePhotoUrl;
  final String username;
  final int notificationType; /*it can be like or comment 1 or 2*/

  const Notification(
      {this.username,
        this.photoUrl,
        this.profilePhotoUrl,
        this.notificationType,
      });
}