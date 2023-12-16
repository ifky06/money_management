import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_management/auth/auth_page.dart';
import 'package:money_management/pages/activities_page.dart';
import 'package:money_management/pages/home_page.dart';
import 'package:money_management/pages/scan_page.dart';
import 'package:money_management/pages/profile_page.dart';
import 'package:money_management/theme/theme_constants.dart';

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
              const ScanPage(),
              const ProfilePage(),
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
                  icon: Icon(Icons.camera_alt),
                  label: 'Scan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              backgroundColor: ThemeConstants.primaryBlack,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              showUnselectedLabels: false,
              fixedColor: ThemeConstants.primaryBlue,
              unselectedIconTheme:
                  IconThemeData(color: ThemeConstants.primaryGrey),
            ),
          );
        } else {
          return const AuthPage();
        }
      },
    ));
  }
}
