import 'package:demo_bank/models/transaction_model.dart';

class BankModel{
  final String bankName;
  final String type;
  final String balance;

  BankModel({
    required this.bankName,
    required this.type,
    required this.balance,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    final bankName = json['bankName'];
    final balance = json['balance'];
    final type = json['type'];
    return BankModel(bankName: bankName, type: type, balance: balance);
  }

}