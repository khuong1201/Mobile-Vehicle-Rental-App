class ReviewModel {
  final String id;
  final String vehicleId;
  final String comment;
  final int rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  final RenterInfo renter;

  ReviewModel({
    required this.id,
    required this.vehicleId,
    required this.comment,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
    this.updatedAt,
    required this.renter,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      renter: RenterInfo.fromJson(json['renterId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vehicleId': vehicleId,
      'comment': comment,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'renterId': renter.toJson(),
    };
  }
}

class RenterInfo {
  final String id;
  final String email;
  final String fullName;
  final String? imageAvatarUrl;

  RenterInfo({
    required this.id,
    required this.email,
    required this.fullName,
    required this.imageAvatarUrl,
  });

  factory RenterInfo.fromJson(Map<String, dynamic> json) {
    return RenterInfo(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      imageAvatarUrl: json['imageAvatarUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'fullName': fullName,
      'imageAvatarUrl': imageAvatarUrl ?? '',
    };
  }
}
