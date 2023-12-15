import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:money_management/components/expense_tile.dart';
// import 'package:money_management/data/expense_data.dart';
import 'package:money_management/models/expense_item.dart';
import 'package:money_management/pages/scan_page.dart';

class OldHomePage extends StatefulWidget {
  

  const OldHomePage({super.key});

  @override
  State<OldHomePage> createState() => _OldHomePageState();
}

class _OldHomePageState extends State<OldHomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final expenseCollection = FirebaseFirestore.instance.collection('expense');

  // text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  // add new expense
  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add New Expense'),
              content: Column(
                children: [
                  // expense name
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expense Name',
                    ),
                    controller: newExpenseNameController,
                  ),
                  // expense amount

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Expense Amount',
                    ),
                    keyboardType: TextInputType.number,
                    controller: newExpenseAmountController,
                  ),
                ],
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
    ExpenseItem expenseItem = ExpenseItem(
      id: '',
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
      user: user!.email!,
    );

    // add to firestore
    await expenseItem.addNewExpense(expenseItem);
    // await expenseCollection.add({
    //   'name': expenseItem.name,
    //   'amount': expenseItem.amount,
    //   'dateTime': expenseItem.dateTime,
    //   'user': expenseItem.user,
    // });
    // add to database

    // Provider.of<ExpenseData>(context, listen: false).addNewExpense(expenseItem);

    // close dialog
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

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
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  // get total expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme:
              const IconThemeData(size: 22.0, color: Colors.white),
          backgroundColor: Colors.grey[800],
          visible: true,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.post_add, color: Colors.white),
              backgroundColor: Colors.grey[800],
              onTap: addNewExpense,
            ),
            SpeedDialChild(
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
              backgroundColor: Colors.grey[800],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScanPage(),
                  ),
                );
              },
            ),
          ],
        ),
        // FloatingActionButton(
        //   backgroundColor: Colors.grey[800],
        //   onPressed: addNewExpense,
        //   child: const Icon(Icons.add, color: Colors.white),
        // ),
        body: ListView(
          children: [
            //weekly summary
            StreamBuilder<double>(
              stream: expenseCollection
                  .where('user', isEqualTo: user!.email)
                  .snapshots()
                  .map((QuerySnapshot querySnapshot) {
                double totalExpense = 0;
                querySnapshot.docs.forEach((doc) {
                  totalExpense += double.parse(doc['amount'].toString());
                });
                return totalExpense;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Total Expense: Rp. 0');
                }

                if (snapshot.hasError) {
                  return Text('Total Expense: Rp. 0');
                }

                // Jika query berhasil dan data tersedia
                if (snapshot.hasData) {
                  double totalExpense = snapshot.data!;
                  return Text('Total Expense: $totalExpense');
                }

                // Jika tidak ada data yang ditemukan
                return Text('Total Expense: Rp. 0');
              },
            ),

            // ExpenseSummary(startOfWeek: ExpenseData.startOfWeekDate()),
            // expense list
            StreamBuilder(
              stream: expenseCollection
                  .where('user', isEqualTo: user!.email)
                  .orderBy('dateTime', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final expense =
                        ExpenseItem.fromSnapshot(snapshot.data!.docs[index]);

                    return ExpenseTile(expenseItem: expense);
                  },
                );
              },
            ),
          ],
        ));
  }

  //  return Scaffold(
  //       body: Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text('signed in as: ${user!.email!}'),
  //         MaterialButton(
  //           onPressed: () {
  //             FirebaseAuth.instance.signOut();
  //           },
  //           color: Colors.deepPurple[200],
  //           child: const Text('Sign Out'),
  //         ),
  // Expanded(
  //     child: FutureBuilder(
  //   future: ExpenseItem.getDocIDs(),
  //   builder: (context, snapshot) {
  //     return ListView.builder(
  //       itemCount: ExpenseItem.docIDs.length,
  //       itemBuilder: (context, index) {
  //         return ListTile(
  //           title: Text(ExpenseItem.docIDs[index]),
  //         );
  //       },
  //     );
  //   },
  // ))
  //     ],
  //   ),
  // ));
}
