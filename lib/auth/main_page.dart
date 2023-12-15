import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/auth/auth_page.dart';
import 'package:money_management/pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          int currentPagesIndex = 0;
          return Scaffold(
            body: [
              const HomePage(),
            ][currentPagesIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentPagesIndex,
              onTap: (index) {
                currentPagesIndex = index;
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
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
