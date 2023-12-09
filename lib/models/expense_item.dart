import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseItem {
  final String name;
  final String amount;
  final DateTime dateTime;

  ExpenseItem(
      {required this.name, required this.amount, required this.dateTime});

  static List<String> docIDs = [];

  static Future<void> getDocIDs() async {
    await FirebaseFirestore.instance.collection('expense').get().then(
          (snapshot) => snapshot.docs.forEach(
            (doc) {
              print(doc.reference);
              docIDs.add(doc.id);
            },
          ),
        );
  }
}
