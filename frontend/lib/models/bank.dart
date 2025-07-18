class BankAccount {
  final String accountNumber;
  final String bankName;
  final String accountHolderName;
  // final String routingNumber;
  // final String? swiftCode; // vì swiftCode không bắt buộc nên để nullable

  BankAccount({
    required this.accountNumber,
    required this.bankName,
    required this.accountHolderName,
    // required this.routingNumber,
    // this.swiftCode,
  });

  // 👉 Tạo từ JSON
  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountNumber: json['accountNumber']?.toString() ?? 'unknown',
      bankName: json['bankName']?.toString() ?? 'unknown',
      accountHolderName: json['accountHolderName']?.toString() ?? 'unknown',
      // routingNumber: json['routingNumber'] as String,
      // swiftCode: json['swiftCode'] as String?, // có thể null
    );
  }

  // 👉 Chuyển thành JSON
  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber.toString(),
      'bankName': bankName,
      'accountHolderName': accountHolderName.toString(),
      // 'routingNumber': routingNumber,
      // if (swiftCode != null) 'swiftCode': swiftCode, // chỉ thêm nếu có
    };
  }
}
