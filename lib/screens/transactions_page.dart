import 'dart:convert';

import 'package:demo_bank/models/BanksModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionsPage extends StatefulWidget {

  final int index;
  static const id = "transactions";

  const TransactionsPage({Key? key, required this.index}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {

  late int index;
  late BanksModel bank;
  bool isLoading = false;

  List<String> sortOptions = ["Latest to Oldest", "Oldest to Latest"];

  bool bottomIsChecked = false;
  bool bottomIsSwitched = false;
  int bottomRadioValue = 0;

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
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 40.0,
                    child: Image.asset('assets/images/hdfc.png')
                ),
                const SizedBox(width: 15.0),
                Text(
                  bank.bankName ?? "Null",
                  style: const TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(width: 70.0,),

                Text(
                    "\$ ${bank.balance}",
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

            const SizedBox(height: 30.0),

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

            // RadioListTile<String>(
            //   title: Text(sortOptions[0]),
            //   value: sortOptions[0],
            //   groupValue: selectedSortByTime,
            //   onChanged: (String? value) {
            //     setState(() {
            //       selectedSortByTime = value!;
            //     });
            //   },
            // ),
            // RadioListTile<String>(
            //   title: Text(sortOptions[1]),
            //   value: sortOptions[1],
            //   groupValue: selectedSortByTime,
            //   onChanged: (String? value) {
            //     setState(() {
            //       selectedSortByTime = value!;
            //     });
            //   },
            // ),

          ],
        ),
      )

    );
  }

  void _showBottomModalSheet(){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)
            )
        ),
        context: context,
        builder: (context){
          return StatefulBuilder(
              builder: (context, state){
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20.0,),
                      Text(
                        "Sort and Filter",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
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
                                  groupValue: bottomRadioValue,
                                  onChanged: (int? value) {
                                    state(() {
                                      bottomRadioValue = value!;
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
                                  groupValue: bottomRadioValue,
                                  onChanged: (int? value) {
                                    state(() {
                                      bottomRadioValue = value!;
                                    });
                                  },
                                ),
                                Text(sortOptions[1]),
                              ],
                            ),

                          ],
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  Future loadJson() async {
    setState((){
      isLoading = true;
    });
    String data = await rootBundle.loadString("assets/demo.json");
    final jsonResult = jsonDecode(data);

    setState((){
      bank = BanksModel.fromJson(jsonResult[index]);
      isLoading = false;
    });

    print(bank.transactions);

  }

}
