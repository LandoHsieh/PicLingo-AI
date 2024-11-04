class UserPicture {
  final int pictureId;
  final int userId;
  final String imageUrl;
  final String? analyzedText;
  final DateTime createdAt;

  UserPicture({
    required this.pictureId,
    required this.userId,
    required this.imageUrl,
    this.analyzedText,
    required this.createdAt,
  });
} 