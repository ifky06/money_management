import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseItem {
  final String id;
  final String name;
  final String amount;
  final DateTime dateTime;
  final String user;
  final expenseCollection = FirebaseFirestore.instance.collection('expense');

  ExpenseItem(
      {required this.id,
      required this.name,
      required this.amount,
      required this.dateTime,
      required this.user});

  factory ExpenseItem.fromJson(Map<String, dynamic> json) {
    return ExpenseItem(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      dateTime: json['dateTime'].toDate(),
      user: json['user'],
    );
  }

  factory ExpenseItem.fromSnapshot(DocumentSnapshot doc) {
    return ExpenseItem(
      id: doc.id,
      name: doc['name'],
      amount: doc['amount'].toString(),
      dateTime: doc['dateTime'].toDate(),
      user: doc['user'],
    );
  }

  // add data to firestore
  Future<void> addNewExpense(ExpenseItem newExpense) async {
    await expenseCollection.add({
      'name': newExpense.name,
      'amount': newExpense.amount,
      'dateTime': newExpense.dateTime,
      'user': newExpense.user,
    });
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'dateTime': dateTime,
      };

  void deleteExpense(String id) {
    expenseCollection.doc(id).delete();
  }
}
