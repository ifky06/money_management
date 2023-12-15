import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/auth/auth_page.dart';
import 'package:money_management/pages/activities_page.dart';
import 'package:money_management/pages/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPagesIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: [
              const HomePage(),
              const ActivitiesPage(),
              const HomePage()
            ][currentPagesIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentPagesIndex,
              onTap: (index) {
                setState(() => currentPagesIndex = index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications),
                  label: 'Aktivitas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        } else {
          return const AuthPage();
        }
      },
    ));
  }
}
