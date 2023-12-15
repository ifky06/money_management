import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/theme/theme_constants.dart';

class TotalAmount extends StatefulWidget {
  final bool isIncome;

  const TotalAmount({super.key, required this.isIncome});

  @override
  State<TotalAmount> createState() => _TotalAmountState();
}

class _TotalAmountState extends State<TotalAmount> {
  final user = FirebaseAuth.instance.currentUser;
  final actionCollection = FirebaseFirestore.instance.collection('actions');

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: ThemeConstants.primaryBlack.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isIncome ? 'Uang Masuk' : 'Uang Keluar',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 7),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ThemeConstants.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    widget.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: ThemeConstants.primaryWhite,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              width: 3,
              color: ThemeConstants.primaryWhite,
            ),
            StreamBuilder<int>(
              stream: actionCollection
                  .where('user', isEqualTo: user!.email)
                  .where('isIncome', isEqualTo: widget.isIncome)
                  .snapshots()
                  .map((QuerySnapshot querySnapshot) {
                int totalAction = 0;
                querySnapshot.docs.forEach((doc) {
                  totalAction += int.parse(doc['amount'].toString());
                });
                return totalAction;
              }),
              builder: (context, snapshot) {
                // Jika query berhasil dan data tersedia
                if (snapshot.hasData) {
                  int totalAction = snapshot.data!;
                  return Text('Rp. $totalAction',
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.primaryBlack));
                }

                // Jika tidak ada data yang ditemukan
                return Text('Rp. 0',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: ThemeConstants.primaryBlack));
              },
            ),
          ],
        ));
  }
}
