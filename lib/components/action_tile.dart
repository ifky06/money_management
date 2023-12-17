import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_management/formatter/currency_formatter.dart';
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
  final money = NumberFormat("#,##0", "en_US");

  void deleteTapped(BuildContext context) {
    // delete expense
    // Provider.of<ExpenseData>(context, listen: false).deleteExpense(expenseItem);
    // delete expense from firestore
    widget.actionItem.deleteAction(widget.actionItem);
  }

  final TextEditingController _amountController = TextEditingController();

  void editTapped(BuildContext context) {
    _amountController.text = money.format(int.parse(widget.actionItem.amount));
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Edit Jumlah'),
              content: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyFormatter(),
                ],
                decoration: const InputDecoration(
                  hintText: 'Jumlah baru',
                  icon: Text('Rp.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                controller: _amountController,
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
                        amount: editedAmount.replaceAll(",", ""),
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
            trailing: Text(
              widget.actionItem.isIncome
                  ? currencyFormat(int.parse(widget.actionItem.amount))
                  : '- ${currencyFormat(int.parse(widget.actionItem.amount))}',
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
