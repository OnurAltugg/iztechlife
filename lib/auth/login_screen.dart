import 'package:flutter/material.dart';
import 'package:iztechlife/auth/forgot_password.dart';
import 'package:iztechlife/auth/signup_screen.dart';
import 'package:iztechlife/pages/main_page.dart';

import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "IZTECH",
                    style: TextStyle(
                      color: Color(0xFFB71C1C),
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Life",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hint: "Enter Email",
                label: "Email",
                controller: _email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hint: "Enter Password",
                label: "Password",
                isPassword: true,
                controller: _password,
              ),
              const SizedBox(height: 30),
              CustomButton(
                label: "LOGIN",
                onPressed: _login,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  InkWell(
                    onTap: () => goToSignup(context),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Color(0xFFB71C1C)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPassword()),
                      );
                    },
                    child: const Text(
                      "Forgot Password?",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  Future<void> _login() async {
    final user = await _auth.loginUserWithEmailAndPassword(_email.text, _password.text, context);
    if (user != null) {
      _showAlert("User Logged In");
      goToHome(context);
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
