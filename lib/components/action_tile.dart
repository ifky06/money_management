import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_management/formatter/formatter.dart';
import 'package:money_management/models/action_item.dart';
import 'package:money_management/theme/theme_constants.dart';

class ActionTile extends StatefulWidget {
  final ActionItem actionItem;

  const ActionTile({super.key, required this.actionItem});

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {
  void deleteTapped(BuildContext context) {
    // delete expense
    // Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
    // delete expense from firestore
    widget.actionItem.deleteAction(widget.actionItem);
  }

  final TextEditingController _amountController = TextEditingController();

  void editTapped(BuildContext context) {
    _amountController.text = widget.actionItem.amount.toString();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Edit Action'),
              content: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Action Amount',
                    ),
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                  ),
                ],
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: () {
                    // actionItem.updateAction(actionItem);
                    if (_amountController.text.isNotEmpty) {
                      final String editedAmount = _amountController.text;
                      ActionItem newActionItem = ActionItem(
                        id: widget.actionItem.id,
                        amount: editedAmount,
                        dateTime: widget.actionItem.dateTime,
                        isIncome: widget.actionItem.isIncome,
                        user: widget.actionItem.user,
                      );
                      widget.actionItem.updateAction(newActionItem);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
                // cancel button
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          // slide to edit
          SlidableAction(
            onPressed: (context) {
              editTapped(context);
            },
            label: 'Edit',
            backgroundColor: ThemeConstants.primaryBlue,
            icon: Icons.edit,
          ),
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
                child: Image.asset(widget.actionItem.isIncome
                    ? 'assets/icon/input_circle.png'
                    : 'assets/icon/output_circle.png')),
            title:
                Text(widget.actionItem.isIncome ? 'Uang Masuk' : 'Uang Keluar'),
            subtitle: Text(
                '${widget.actionItem.dateTime.day} ${convertMonthNumberToString(widget.actionItem.dateTime.month)} ${widget.actionItem.dateTime.year}'),
            trailing: Text(widget.actionItem.isIncome
                ? 'Rp. ${widget.actionItem.amount}'
                : '-Rp. ${widget.actionItem.amount}'),
          ),
        ),
      ),
    );
  }
}
