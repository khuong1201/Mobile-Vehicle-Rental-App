class BankAccount {
  final String accountNumber;
  final String bankName;
  final String accountHolderName;

  BankAccount({
    required this.accountNumber,
    required this.bankName,
    required this.accountHolderName,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountNumber: json['accountNumber']?.toString() ?? '',
      bankName: json['bankName']?.toString() ?? '',
      accountHolderName: json['accountHolderName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountNumber': accountNumber,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
    };
  }
}