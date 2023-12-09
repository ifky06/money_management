import 'package:flutter/foundation.dart';
import 'package:money_management/datetime/date_time_helper.dart';
import 'package:money_management/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getExpenseList() {
    return overallExpenseList;
  }

  // add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    // notify listeners
    notifyListeners();
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    // notify listeners
    notifyListeners();
  }

  // get weekday (Monday, Tuesday, etc.) from a DateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  // get the date for the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get today's date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sunday') {
        startOfWeek = today.subtract(Duration(days: i));
        break;
      }
    }
    return startOfWeek!;
  }

  /*
  convert overall list of expenses into a daily expense summary

  e.g.

  overallExpenseList = 
  [
    [food, 2023/01/30, Rp. 10000],
    [food, 2023/01/30, Rp. 20000],
    [food, 2023/01/30, Rp. 30000],
    [food, 2023/01/31, Rp. 10000],
  ]


  */

  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {
      // date (yyyymmdd) : amountTotalForDay
    };

    for (var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSummary.containsKey(date)) {
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
      } else {
        dailyExpenseSummary.addAll({date: amount});
      }
    }
    return dailyExpenseSummary;
  }
}
