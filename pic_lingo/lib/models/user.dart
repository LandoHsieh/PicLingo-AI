class User {
  final int id;
  final String username;
  final String email;
  final String tier;
  final int dailyCreditLimit;
  final int currentCredits;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.tier,
    required this.dailyCreditLimit,
    required this.currentCredits,
    required this.createdAt,
    required this.updatedAt,
  });
} 