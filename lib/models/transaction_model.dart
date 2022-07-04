
class TransactionModel{
  final String date;
  final String name;
  final String amount;
  final String typeOfTransaction;

  TransactionModel({
    required this.date,
    required this.name,
    required this.amount,
    required this.typeOfTransaction
});

  // factory TransactionModel.fromJson(Map<String, dynamic> json) {
  //   final name = json['name'];
  //   final amount = json['amount'];
  //   final typeOfTransaction = json['typeOfTransaction'];
  //   return TransactionModel(name: name, amount: amount, typeOfTransaction: typeOfTransaction);
  // }


}