import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_management/pages/forgot_pw_page.dart';
import 'package:money_management/theme/theme_constants.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Future signIn() async {
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim());
  //   } on FirebaseAuthException catch (e) {
  //     print(e);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(e.message!),
  //       ),
  //     );
  //   }
  // }

  // use AuthService
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // hello again
              Text(
                'Login',
                style: GoogleFonts.bebasNeue(
                  fontSize: 50,
                ),
              ),
              const Text(
                'Selamat datang di KuiBel',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 50),
              // email text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeConstants.primaryLightBlue,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        icon: Icon(Icons.email),
                        iconColor: ThemeConstants.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // password text field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeConstants.primaryLightBlue,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                        icon: Icon(Icons.lock),
                        iconColor: ThemeConstants.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordPage();
                        }));
                      },
                      child: const Text('Forgot Password?',
                          style: TextStyle(color: ThemeConstants.primaryBlue)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              // login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: signIn,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: ThemeConstants.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?"),
                  GestureDetector(
                    onTap: widget.showRegisterPage,
                    child: const Text(" Register now",
                        style: TextStyle(
                            color: ThemeConstants.primaryBlue,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
