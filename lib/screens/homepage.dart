import 'dart:convert';

import 'package:demo_bank/models/banks_model.dart';
import 'package:demo_bank/screens/transactions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<BanksModel> listOfBanks = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Bank Accounts"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {
              // loadJson();
            },
          )
        ],
      ),

      body: isLoading ? const CircularProgressIndicator() :
      ListView.builder(
        padding: const EdgeInsets.all(5.5),
        itemCount: listOfBanks.length,
        itemBuilder: _itemBuilder,
      ),


    );
  }

  Widget _itemBuilder(BuildContext context, int index) {

    var bank = listOfBanks[index];

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 40.0,
                    child: Image.network(bank.imageURL!)
                ),
                const SizedBox(width: 15.0),
                // SizedBox(
                //   height: 40.0,
                //     child: Image.network(bank.imageURL!)),
                Text(
                  bank.bankName ?? "Null",
                  style: const TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold
                  ),
                ),

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${bank.type}\n${bank.accountNo}"
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Your Balance\n'),
                      TextSpan(
                        text: "₹ ${bank.balance}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          fontSize: 20.0
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 17.0),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  // print(index);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransactionsPage(index: index)),
                  );
                },
                child: const Text(
                    "View Transactions",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30.0),

            const Divider(
              height: 1.0,
              color: Colors.grey,
            ),

          ],
        ),
      ),
    );
  }

  Future loadJson() async {

    setState((){
      isLoading = true;
    });
    String data = await rootBundle.loadString("assets/demo.json");
    final jsonResult = jsonDecode(data);

    for(Map i in jsonResult){
      listOfBanks.add(BanksModel.fromJson(i));
      // print(BanksModel.fromJson(i).bankName);
      // print(BanksModel.fromJson(i).transactions![0].name);
    }

    setState((){
      isLoading = false;
    });

    // print(listOfBanks.toString());

    // return jsonResult.map((json) => BankModel.fromJson(json)).toList();
  }

}
