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