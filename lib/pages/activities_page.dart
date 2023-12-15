import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/components/action_tile.dart';
import 'package:money_management/models/action_item.dart';
import 'package:money_management/theme/theme_constants.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  final user = FirebaseAuth.instance.currentUser;
  final actionCollection = FirebaseFirestore.instance.collection('actions');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeConstants.primaryBlue,
          title: Center(
              child: const Text(
            'Aktivitas',
            style: TextStyle(
                color: ThemeConstants.primaryWhite,
                fontWeight: FontWeight.bold),
          )),
        ),
        body: StreamBuilder(
          stream: actionCollection
              .where('user', isEqualTo: user!.email)
              .orderBy('dateTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: ThemeConstants.primaryBlue,
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final action =
                    ActionItem.fromSnapshot(snapshot.data!.docs[index]);

                return ActionTile(actionItem: action);
              },
            );
          },
        ));
  }
}
