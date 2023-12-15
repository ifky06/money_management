import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_management/models/action_item.dart';
import 'package:money_management/theme/theme_constants.dart';

class ActionTile extends StatelessWidget {
  final ActionItem actionItem;

  const ActionTile({super.key, required this.actionItem});

  void deleteTapped(BuildContext context) {
    // delete expense
    // Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
    // delete expense from firestore
    actionItem.deleteAction(actionItem);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: ThemeConstants.primaryWhite))),
          child: ListTile(
            leading: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ThemeConstants.primaryWhite)),
                child: Image.asset(actionItem.isIncome
                    ? 'assets/icon/input_circle.png'
                    : 'assets/icon/output_circle.png')),
            title: Text(actionItem.isIncome ? 'Uang Keluar' : 'Uang Masuk'),
            subtitle: Text(
                '${actionItem.dateTime.day}/${actionItem.dateTime.month}/${actionItem.dateTime.year}'),
            trailing: Text(actionItem.isIncome
                ? 'Rp. ${actionItem.amount}'
                : '-Rp. ${actionItem.amount}'),
          ),
        ),
      ),
    );
  }
}
