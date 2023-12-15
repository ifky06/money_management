import 'package:cloud_firestore/cloud_firestore.dart';

class ActionItem {
  final String id;
  final String amount;
  final DateTime dateTime;
  final bool isIncome;
  final String user;
  final actionCollection = FirebaseFirestore.instance.collection('actions');
  final saldoCollection = FirebaseFirestore.instance.collection('saldo');

  ActionItem({
    required this.id,
    required this.amount,
    required this.dateTime,
    required this.isIncome,
    required this.user,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) {
    return ActionItem(
      id: json['id'],
      amount: json['amount'],
      dateTime: json['dateTime'].toDate(),
      isIncome: json['isIncome'],
      user: json['user'],
    );
  }

  factory ActionItem.fromSnapshot(DocumentSnapshot doc) {
    return ActionItem(
      id: doc.id,
      amount: doc['amount'].toString(),
      dateTime: doc['dateTime'].toDate(),
      isIncome: doc['isIncome'],
      user: doc['user'],
    );
  }

  Future<void> addNewAction(ActionItem newAction) async {
    final balance = await saldoCollection
        .where('user', isEqualTo: newAction.user)
        .get()
        .then((value) => value.docs.first);
    if (isIncome) {
      await saldoCollection.doc(balance.id).update({
        'amount': int.parse(balance['amount'].toString()) +
            int.parse(newAction.amount),
      });
    } else {
      await saldoCollection.doc(balance.id).update({
        'amount': int.parse(balance['amount'].toString()) -
            int.parse(newAction.amount),
      });
    }
    await actionCollection.add({
      'amount': newAction.amount,
      'dateTime': newAction.dateTime,
      'isIncome': newAction.isIncome,
      'user': newAction.user,
    });
  }

  Future<void> deleteAction(ActionItem action) async {
    final balance = await saldoCollection
        .where('user', isEqualTo: action.user)
        .get()
        .then((value) => value.docs.first);
    if (action.isIncome) {
      await saldoCollection.doc(balance.id).update({
        'amount':
            int.parse(balance['amount'].toString()) - int.parse(action.amount),
      });
    } else {
      await saldoCollection.doc(balance.id).update({
        'amount':
            int.parse(balance['amount'].toString()) + int.parse(action.amount),
      });
    }
    await actionCollection.doc(action.id).delete();
  }
}
