class ViettinPayment {
  final String paymentId;
  final String message;

  ViettinPayment({
    required this.paymentId,
    required this.message,
  });

  factory ViettinPayment.fromJson(Map<String, dynamic> json) {
    return ViettinPayment(
      paymentId: json['paymentId'],
      message: json['message'] ?? '',
    );
  }
}
