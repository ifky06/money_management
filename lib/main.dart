import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:money_management/firebase_options.dart';
import 'package:money_management/pages/splash_page.dart';
import 'package:money_management/theme/theme_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Money Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ThemeConstants.primaryBlue),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
