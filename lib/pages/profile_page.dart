import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_management/models/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:money_management/theme/theme_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('users');

  UserDetail? userDetail;

  // get user detail

  void getUserDetail() async {
    final userDetail = await UserDetail.getUserByEmail(user!.email!);
    setState(() {
      this.userDetail = userDetail;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeConstants.primaryBlue,
          title: const Center(
              child: Text(
            'Profile Settings',
            style: TextStyle(
                color: ThemeConstants.primaryWhite,
                fontWeight: FontWeight.bold),
          )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  border: Border.all(color: ThemeConstants.primaryGrey),
                ),
                child: ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ganti Gambar Profil',
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.person),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  border: Border(
                    bottom: BorderSide(color: ThemeConstants.primaryGrey),
                    left: BorderSide(color: ThemeConstants.primaryGrey),
                    right: BorderSide(color: ThemeConstants.primaryGrey),
                  ),
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nama Asli',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${userDetail?.firstName} ${userDetail?.lastName}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  border: Border(
                    bottom: BorderSide(color: ThemeConstants.primaryGrey),
                    left: BorderSide(color: ThemeConstants.primaryGrey),
                    right: BorderSide(color: ThemeConstants.primaryGrey),
                  ),
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Username',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        userDetail?.username ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  border: Border(
                    bottom: BorderSide(color: ThemeConstants.primaryGrey),
                    left: BorderSide(color: ThemeConstants.primaryGrey),
                    right: BorderSide(color: ThemeConstants.primaryGrey),
                  ),
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nomor Telepon',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        userDetail?.phoneNumber ?? '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                  border: Border(
                    bottom: BorderSide(color: ThemeConstants.primaryGrey),
                    left: BorderSide(color: ThemeConstants.primaryGrey),
                    right: BorderSide(color: ThemeConstants.primaryGrey),
                  ),
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        // cut the email to 15 characters

                        user!.email!.substring(0, 10) + '...',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
                  border: Border(
                    bottom: BorderSide(color: ThemeConstants.primaryGrey),
                    left: BorderSide(color: ThemeConstants.primaryGrey),
                    right: BorderSide(color: ThemeConstants.primaryGrey),
                  ),
                ),
                child: ListTile(
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  trailing: const Icon(Icons.logout, color: Colors.red),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
