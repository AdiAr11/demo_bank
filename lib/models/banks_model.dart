import 'package:demo_bank/models/transaction_model.dart';

class BanksModel {
  BanksModel({
      this.bankName, 
      this.type, 
      this.balance,
      this.accountNo,
      this.transactions,});

  BanksModel.fromJson(dynamic json) {
    bankName = json['bankName'];
    type = json['type'];
    balance = json['balance'];
    accountNo = json['accountNo'];
    if (json['transactions'] != null) {
      transactions = [];
      json['transactions'].forEach((v) {
        transactions?.add(Transactions.fromJson(v));
      });
    }
  }
  String? bankName;
  String? type;
  String? balance;
  String? accountNo;
  List<Transactions>? transactions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bankName'] = bankName;
    map['type'] = type;
    map['balance'] = balance;
    map['accountNo'] = accountNo;
    if (transactions != null) {
      map['transactions'] = transactions?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

