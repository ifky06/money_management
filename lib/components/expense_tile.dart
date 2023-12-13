import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_management/models/expense_item.dart';

class ExpenseTile extends StatelessWidget {
 final ExpenseItem expenseItem;

  const ExpenseTile({super.key, required this.expenseItem});

  void deleteTapped(BuildContext context) {
    // delete expense
    // Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
    // delete expense from firestore
    expenseItem.deleteExpense(expenseItem.id);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteTapped(context);
            },
            label: 'Delete',
            backgroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
      child: ListTile(
                  title: Text(expenseItem.name),
                  subtitle:
                      Text('${expenseItem.dateTime.day}/${expenseItem.dateTime.month}/${expenseItem.dateTime.year}'),
                  trailing: Text('Rp. ${expenseItem.amount}'),
                ),
    );
  }
}