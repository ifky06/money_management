import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/components/expense_tile.dart';
import 'package:money_management/data/expense_data.dart';
import 'package:money_management/models/expense_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

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
  void save() {
    // create expense item
    ExpenseItem expenseItem = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );

    Provider.of<ExpenseData>(context, listen: false).addNewExpense(expenseItem);

    // close dialog
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              child: const Icon(Icons.add),
            ),
            body: ListView(
              children: [
                //weekly summary
                
                // expense list
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Provider.of<ExpenseData>(context)
                        .getExpenseList()
                        .length,
                    itemBuilder: (context, index) => ExpenseTile(
                          name: value.getExpenseList()[index].name,
                          amount: value.getExpenseList()[index].amount,
                          dateTime: value.getExpenseList()[index].dateTime,
                        )),
              ],
            )));
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
