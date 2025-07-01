class MomoPayment {
  final String payUrl;
  final String paymentId;
  final String message;

  MomoPayment({
    required this.payUrl,
    required this.paymentId,
    required this.message,
  });

  factory MomoPayment.fromJson(Map<String, dynamic> json) {
    return MomoPayment(
      payUrl: json['payUrl'],
      paymentId: json['paymentId'],
      message: json['message'] ?? '',
    );
  }
}
