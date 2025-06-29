// models/user.dart
class User {
  final String id;
  final String userId;
  final String? googleId;
  final String fullName;
  final String email;
  final String imageAvatarUrl;
  late final String role;
  final bool verified;

  User({
    required this.id,
    required this.userId,
    this.googleId,
    required this.fullName,
    required this.email,
    required this.imageAvatarUrl,
    required this.role,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      googleId: json['googleId'],
      fullName: json['fullName'] ?? '',
      imageAvatarUrl: json['avatar'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'renter',
      verified: json['verified'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'googleId': googleId,
      'fullName': fullName,
      'email': email,
      'avatar': imageAvatarUrl,
      'role': role,
      'verified': verified,
    };
  }
}
