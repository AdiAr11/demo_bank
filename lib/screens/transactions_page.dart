import 'dart:convert';

import 'package:demo_bank/models/banks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import "package:collection/collection.dart";

class TransactionsPage extends StatefulWidget {

  final int index;

  const TransactionsPage({Key? key, required this.index}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {

  late int index;
  late BanksModel bank;
  bool isLoading = false;

  List<String> sortOptions = ["Latest to Oldest", "Oldest to Latest"];
  List transactions = [];
  List filteredTransactions = [];

  // bool bottomIsChecked = false;
  // bool bottomIsSwitched = false;
  int sortByTimeRadioValue = 0;

  bool creditCheckedValue = true;
  bool debitCheckedValue = true;
  bool amountCheckedValue = false;
  RangeValues _currentRangeValues = const RangeValues(10000, 80000);

  final filterDialogDecoration = BoxDecoration(
    color: Colors.lightBlueAccent.shade100,
  borderRadius: const BorderRadius.all(Radius.circular(20))
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transactions"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {

            },
          )
        ],
      ),

      body: isLoading ? const CircularProgressIndicator() :
      Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 40.0,
                      child: Image.network(bank.imageURL!)
                  ),
                  const SizedBox(width: 15.0),
                  Text(
                    bank.bankName ?? "Null",
                    style: const TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(width: 50.0,),

                  Text(
                      "₹ ${bank.balance}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 15.0),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: "${bank.type} (${bank.accountNo})" ,
                        style: const TextStyle(color: Colors.black)
                    ),
                    const TextSpan(
                      text: "  2.5 % p.a",
                      style: TextStyle(
                          color: Colors.red,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30.0),
              const Divider(thickness: 5.0),

              const SizedBox(height: 15.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Last 10 Transactions",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black87
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        _showBottomModalSheet();
                      },
                      icon:const Icon(Icons.filter_alt_sharp),
                  )
                ],
              ),

              Wrap(
                spacing: 9.0,
                runSpacing: 9.0,
                children: [
                  Container(
                    decoration: filterDialogDecoration,
                    child:
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: sortByTimeRadioValue == 0 ?
                      Text(sortOptions[0]) :
                      Text(sortOptions[1]),
                    )
                  ),

                  creditCheckedValue ?
                  Container(
                      decoration: filterDialogDecoration,
                      child:
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Text("Credit"),
                      )
                  ) : const Text(""),

                  debitCheckedValue ?
                  Container(
                      decoration: filterDialogDecoration,
                      child:
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Text("Debit"),
                      )
                  ) : const Text(""),

                  amountCheckedValue ?
                  Container(
                      decoration: filterDialogDecoration,
                      child:
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "Amount between "),
                              TextSpan(
                                  text: "₹${_currentRangeValues.start.toStringAsFixed(0)}" ,
                                  style: const TextStyle(fontWeight: FontWeight.bold)
                              ),
                              const TextSpan(text: " and "),
                              TextSpan(
                                  text: " ₹${_currentRangeValues.end.toStringAsFixed(0)}" ,
                                  style: const TextStyle(fontWeight: FontWeight.bold)
                              ),
                            ],
                          ),
                        ),
                      )
                  ) : const Text("")

                ],
              ),

              GroupedListView<dynamic, String>(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                elements: filteredTransactions,
                groupBy: (element) => element["date"],
                groupComparator: (value1, value2) => value2.compareTo(value1),
                // itemComparator: (item1, item2) =>
                //     item1['name'].compareTo(item2['name']),
                order: sortByTimeRadioValue == 0 ? GroupedListOrder.ASC : GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(thickness: 1.0,),
                      Text(
                        value.substring(0, 10),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                itemBuilder: (c, element) {

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(element['name'],
                              style: const TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 17.0,
                                color: Colors.black87
                            ),),
                            element['typeOfTransaction'] == "credit" ?
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("₹ ${element['amount']}",
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                const Icon(Icons.arrow_upward_rounded, color: Colors.red,)
                              ],
                            ) :
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("₹ ${element['amount']}",
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                                const Icon(Icons.arrow_downward, color: Colors.green,),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      )

    );
  }

  void _showBottomModalSheet(){
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)
            )
        ),
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, state){
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20.0,),
                          const Text(
                            "Sort and Filter",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          const Divider(thickness: 1.0,),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0, left: 5.0, right: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Sort by Time",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),

                                Row(
                                  children: [
                                    Radio(
                                      value: 0,
                                      groupValue: sortByTimeRadioValue,
                                      onChanged: (int? value) {
                                        state(() {
                                          sortByTimeRadioValue = value!;
                                        });
                                        setState((){
                                          sortByTimeRadioValue = value!;
                                        });
                                      },
                                    ),
                                    Text(sortOptions[0]),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: sortByTimeRadioValue,
                                      onChanged: (int? value) {
                                        state(() {
                                          sortByTimeRadioValue = value!;
                                        });
                                        setState((){
                                          sortByTimeRadioValue = value!;
                                        });
                                      },
                                    ),
                                    Text(sortOptions[1]),
                                  ],
                                ),

                              ],
                            ),
                          ),

                          const Text(
                            "\nFilter by",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          CheckboxListTile(
                            title: const Text("Credit"),
                            value: creditCheckedValue,
                            onChanged: (newValue) {
                              state(() {
                                creditCheckedValue = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),

                          CheckboxListTile(
                            title: const Text("Debit"),
                            value: debitCheckedValue,
                            onChanged: (newValue) {
                              state(() {
                                debitCheckedValue = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),

                          CheckboxListTile(
                            // title: Text("Amount between ₹ ${_currentRangeValues.start} "
                            //     "and ₹ ${_currentRangeValues.end}"),
                            title: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: "Amount between "),
                                  TextSpan(
                                      text: "₹${_currentRangeValues.start.toStringAsFixed(0)}" ,
                                      style: const TextStyle(fontWeight: FontWeight.bold)
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                      text: " ₹${_currentRangeValues.end.toStringAsFixed(0)}" ,
                                      style: const TextStyle(fontWeight: FontWeight.bold)
                                  ),
                                ],
                              ),
                            ),
                            value: amountCheckedValue,
                            onChanged: (newValue) {
                              state(() {
                                amountCheckedValue = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          ),

                          RangeSlider(
                            values: _currentRangeValues,
                            max: 100000,
                            divisions: 1000,
                            labels: RangeLabels(
                              _currentRangeValues.start.round().toString(),
                              _currentRangeValues.end.round().toString(),
                            ),
                            onChanged: (RangeValues values) {
                              state(() {
                                _currentRangeValues = values;
                              });
                            },
                          ),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("₹0"),
                              Text("₹1L+"),
                            ],
                          ),

                          const SizedBox(height: 15.0,),

                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2 - 20.0 ,
                                height: 50.0,
                                child: ElevatedButton(
                                    onPressed: (){
                                      resetFilters();
                                      state((){});
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                side: BorderSide(color: Colors.purple)
                                            )
                                        )
                                    ),
                                    child: const Text("Reset", style: TextStyle(color: Colors.purple),)),
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2 - 20.0 ,
                                height: 50.0,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                // side: BorderSide(color: Colors.red)
                                            )
                                        )
                                    ),
                                    onPressed: (){
                                      applyFilters();
                                      state((){});
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                        "Apply",
                                        style: TextStyle(fontSize: 14)
                                    )
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                    ),
                  ),
                );
              }
          );
        }
    );
  }

  void resetFilters(){
    // bottomIsChecked = false;
    // bottomIsSwitched = false;
    sortByTimeRadioValue = 0;

    creditCheckedValue = true;
    debitCheckedValue = true;
    amountCheckedValue = false;
    _currentRangeValues = const RangeValues(10000, 80000);

    filteredTransactions = transactions;
    setState((){});
  }

  applyFilters(){

    if(creditCheckedValue && !debitCheckedValue) {
      filteredTransactions = transactions.where((transaction) =>
      transaction['typeOfTransaction'] == 'credit'
      ).toList();

    } else if(debitCheckedValue && !creditCheckedValue) {
      filteredTransactions = transactions.where((transaction) =>
      transaction['typeOfTransaction'] == 'debit'
      ).toList();
    }else{
      filteredTransactions = transactions;
    }

    if(amountCheckedValue) {
      filteredTransactions = filteredTransactions.where((transaction) =>
      transaction['amount'] >= _currentRangeValues.start && transaction['amount'] <= _currentRangeValues.end
      ).toList();
    }

    setState((){});

  }

  Future loadJson() async {
    setState((){
      isLoading = true;
    });
    String data = await rootBundle.loadString("assets/demo.json");
    final jsonResult = jsonDecode(data);

    bank = BanksModel.fromJson(jsonResult[index]);
    transactions = bank.transactions!.map((h) => {"date": h.date, "name": h.name,
      "amount": h.amount, "typeOfTransaction": h.typeOfTransaction}).toList();

    filteredTransactions = transactions;

    setState((){
      isLoading = false;
    });

    // groupByDate();

  }

  // groupByDate(){
  //   orderedTransactions = groupBy(transactions, (Transactions t){
  //     return t.name;
  //   });
  //   print(orderedTransactions);
  // }

}
