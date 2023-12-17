import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_management/components/total_amount_card.dart';
import 'package:money_management/formatter/currency_formatter.dart';
import 'package:money_management/formatter/formatter.dart';
import 'package:money_management/models/action_item.dart';
import 'package:money_management/theme/theme_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final saldoCollection = FirebaseFirestore.instance.collection('saldo');

  // text controllers
  final newIncomeAmountController = TextEditingController();

  // add new expense
  void addNewIncome() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Tambah Saldo'),
              content: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyFormatter(),
                ],
                decoration: const InputDecoration(
                  hintText: 'Jumlah saldo',
                  icon: Text('Rp.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                controller: newIncomeAmountController,
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: const Text('Save'),
                ),
                // cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }

  // save new expense
  Future save() async {
    // create expense item
    ActionItem actionItem = ActionItem(
      id: '',
      amount: newIncomeAmountController.text.replaceAll(",", ""),
      dateTime: DateTime.now(),
      isIncome: true,
      user: user!.email!,
    );

    // add to firestore
    await actionItem.addNewAction(actionItem);

    cancel();

    clearControllers();
  }

  // cancel new expense
  void cancel() {
    // close dialog
    Navigator.of(context).pop();

    clearControllers();
  }

  // clear controllers
  void clearControllers() {
    newIncomeAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/logo.png', height: 100),
                const Text(
                  'KuiBel',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: BoxDecoration(
                color: ThemeConstants.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ThemeConstants.primaryWhite,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.account_balance_wallet,
                            size: 20,
                            color: ThemeConstants.primaryBlue,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Saldo',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: ThemeConstants.primaryBlue),
                              ),
                              StreamBuilder<int>(
                                stream: saldoCollection
                                    .where('user', isEqualTo: user!.email)
                                    .snapshots()
                                    .map((QuerySnapshot querySnapshot) {
                                  int totalSaldo = 0;
                                  querySnapshot.docs.forEach((doc) {
                                    totalSaldo +=
                                        int.parse(doc['amount'].toString());
                                  });
                                  return totalSaldo;
                                }),
                                builder: (context, snapshot) {
                                  // Jika query berhasil dan data tersedia
                                  if (snapshot.hasData) {
                                    int totalExpense = snapshot.data!;
                                    return Text(currencyFormat(totalExpense),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: ThemeConstants.primaryBlue));
                                  }

                                  // Jika tidak ada data yang ditemukan
                                  return const Text('Rp. 0',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeConstants.primaryBlue));
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: addNewIncome,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ThemeConstants.primaryWhite,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: ThemeConstants.primaryBlue,
                          ),
                        ),
                      ),
                      const Text(
                        'Top Up',
                        style: TextStyle(
                            fontSize: 12, color: ThemeConstants.primaryWhite),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              decoration: const BoxDecoration(
                  color: ThemeConstants.primaryWhite,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: const Column(
                children: [
                  TotalAmount(
                    isIncome: true,
                  ),
                  TotalAmount(
                    isIncome: false,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('Kuitansi',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: ThemeConstants.primaryBlack)),
            ),
          ],
        ),
      ),
    );
  }
}
