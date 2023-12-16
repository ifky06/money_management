import 'package:flutter/material.dart';
import 'package:money_management/auth/main_page.dart';
import 'package:money_management/theme/theme_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainPage()));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            ThemeConstants.primaryBlue,
            ThemeConstants.primaryWhite,
            ThemeConstants.primaryBlue,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/SplashLogo.png',
                ),
                const CircularProgressIndicator(
                  color: ThemeConstants.primaryWhite,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
