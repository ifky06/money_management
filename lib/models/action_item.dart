import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

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
      id: '',
      amount: json['amount'],
      dateTime: DateTime.parse(json['dateTime']),
      isIncome: json['isIncome'] == 'true' ? true : false,
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

  // update action amount
  Future<void> updateAction(ActionItem action) async {
    final balanceSnapshot = await saldoCollection
        .where('user', isEqualTo: action.user)
        .get()
        .then((value) => value.docs.first);

    final oldAmountSnapshot = await actionCollection.doc(action.id).get();

    final int oldAmount = int.parse(oldAmountSnapshot['amount'].toString());
    print(oldAmount);
    final int newAmount = int.parse(action.amount);
    print(newAmount);

    final int balanceAmount = balanceSnapshot['amount'];

    int updateAmount = 0;

    if (action.isIncome) {
      updateAmount =
          oldAmount > newAmount ? oldAmount - newAmount : newAmount - oldAmount;
      updateAmount = balanceAmount +
          (oldAmount > newAmount ? -updateAmount : updateAmount);
    } else {
      updateAmount = oldAmount > newAmount
          ? updateAmount = oldAmount - newAmount
          : newAmount - oldAmount;
      updateAmount = balanceAmount +
          (oldAmount > newAmount ? updateAmount : -updateAmount);
    }

    await saldoCollection
        .doc(balanceSnapshot.id)
        .update({'amount': updateAmount});
    await actionCollection.doc(action.id).update({'amount': newAmount});
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

  static Future<ActionItem?> getDataByUploadImage(
      String filePath, String url, Dio dio) async {
    String fileName = filePath.split('/').last;
    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    late Response response;
    try {
      response = await dio.post(
        url,
        data: formData,
      );
    } on DioException catch (_) {
      return null;
    }
    return ActionItem.fromJson(response.data as Map<String, dynamic>);
  }

  // overide to string
  @override
  String toString() {
    return 'ActionItem{id: $id, amount: $amount, dateTime: $dateTime, isIncome: $isIncome, user: $user}';
  }
}
