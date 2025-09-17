
class ReviewModel {
  final String id;
  final String vehicleId;
  final String comment;
  final int rating;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final RenterInfo renter;

  ReviewModel({
    required this.id,
    required this.vehicleId,
    required this.comment,
    required this.rating,
    required this.createdAt,
    this.updatedAt,
    required this.renter,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id']?.toString() ?? '',
      vehicleId: json['vehicleId']?['_id']?.toString() ?? '', // Lấy _id từ vehicleId
      comment: json['comment']?.toString() ?? '',
      rating: (json['rating'] is int) ? json['rating'] : 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']?.toString() ?? '') : null,
      renter: RenterInfo.fromJson(json['renterId'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vehicleId': {'_id': vehicleId}, // Trả về vehicleId như một đối tượng
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'renterId': renter.toJson(),
    };
  }
}

class RenterInfo {
  final String id;
  final String fullName;
  final String? userId; // Thêm userId để ánh xạ trường userId trong JSON
  final String? email; // Làm email tùy chọn
  final String? imageAvatarUrl; // Làm imageAvatarUrl tùy chọn

  RenterInfo({
    required this.id,
    required this.fullName,
    this.userId,
    this.email,
    this.imageAvatarUrl,
  });

  factory RenterInfo.fromJson(Map<String, dynamic> json) {
    return RenterInfo(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      userId: json['userId']?.toString(),
      email: json['email']?.toString(),
      imageAvatarUrl: json['imageAvatarUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      '_id': id,
      'fullName': fullName,
    };
    if (userId != null) data['userId'] = userId;
    if (email != null) data['email'] = email;
    if (imageAvatarUrl != null) data['imageAvatarUrl'] = imageAvatarUrl;
    return data;
  }
}