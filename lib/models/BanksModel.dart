/// bankName : "HDFC Bank"
/// type : "Savings A/C"
/// balance : "54,285"
/// transactions : [{"date":"2021-02-08T13:45:00.000Z","name":"PGVCL Electricity Bill","amount":2500.00,"typeOfTransaction":"credit"},{"date":"2021-02-03T13:45:00.000Z","name":"ATM Withdrawal","amount":1500.00,"typeOfTransaction":"credit"},{"date":"2021-02-03T13:45:00.000Z","name":"ATM Deposit","amount":1400.00,"typeOfTransaction":"debit"},{"date":"2021-02-03T13:45:00.000Z","name":"ATM Deposit","amount":8500.00,"typeOfTransaction":"debit"},{"date":"2021-02-01T13:45:00.000Z","name":"ATM Withdrawal","amount":1200.00,"typeOfTransaction":"credit"}]

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

/// date : "2021-02-08T13:45:00.000Z"
/// name : "PGVCL Electricity Bill"
/// amount : 2500.00
/// typeOfTransaction : "credit"

class Transactions {
  Transactions({
      this.date, 
      this.name, 
      this.amount, 
      this.typeOfTransaction,});

  Transactions.fromJson(dynamic json) {
    date = json['date'];
    name = json['name'];
    amount = json['amount'];
    typeOfTransaction = json['typeOfTransaction'];
  }
  String? date;
  String? name;
  double? amount;
  String? typeOfTransaction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['name'] = name;
    map['amount'] = amount;
    map['typeOfTransaction'] = typeOfTransaction;
    return map;
  }

  @override
  String toString() {
    return 'Transactions('
      'date: $date,'
      'name: $name,'
      'amount: $amount,'
      'typeOfTransaction: $typeOfTransaction'
    ')';
  }
}