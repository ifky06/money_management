import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/components/total_amount_card.dart';
import 'package:money_management/theme/theme_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final saldoCollection = FirebaseFirestore.instance.collection('saldo');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo.png', height: 100),
              const Text(
                'KuiBel',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeConstants.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: ThemeConstants.primaryWhite,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          size: 20,
                          color: ThemeConstants.primaryBlue,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saldo',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: ThemeConstants.primaryBlue),
                            ),
                            StreamBuilder<int>(
                              stream: saldoCollection
                                  .where('user', isEqualTo: user!.email)
                                  .snapshots()
                                  .map((QuerySnapshot querySnapshot) {
                                int totalSaldo = 0;
                                querySnapshot.docs.forEach((doc) {
                                  totalSaldo +=
                                      int.parse(doc['amount'].toString());
                                });
                                return totalSaldo;
                              }),
                              builder: (context, snapshot) {
                                // Jika query berhasil dan data tersedia
                                if (snapshot.hasData) {
                                  int totalExpense = snapshot.data!;
                                  return Text('Rp. $totalExpense',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: ThemeConstants.primaryBlue));
                                }

                                // Jika tidak ada data yang ditemukan
                                return Text('Rp. 0',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: ThemeConstants.primaryBlue));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ThemeConstants.primaryWhite,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 20,
                          color: ThemeConstants.primaryBlue,
                        ),
                      ),
                    ),
                    Text(
                      'Top Up',
                      style: TextStyle(
                          fontSize: 12, color: ThemeConstants.primaryWhite),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
                color: ThemeConstants.primaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: Column(
              children: [
                TotalAmount(
                  isIncome: true,
                ),
                TotalAmount(
                  isIncome: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text('Kuitansi',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ThemeConstants.primaryBlack)),
          ),
        ],
      ),
    );
  }
}
