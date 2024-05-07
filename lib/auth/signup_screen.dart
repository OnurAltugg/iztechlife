import 'package:flutter/material.dart';
import 'package:iztechlife/pages/main_page.dart';

import '../widgets/button.dart';
import '../widgets/textfield.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
      body: Padding(
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
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Enter Name",
              label: "Name",
              controller: _name,
            ),
            const SizedBox(height: 20),
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
              label: "SIGN UP",
              onPressed: _signup,
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => goToLogin(context),
                  child: const Text("Login", style: TextStyle(color: Color(0xFFB71C1C))),
                )
              ],
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MainPage()),
    );
  }

  Future<void> _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text, context);
    if (user != null) {
      _showAlert("User Created Successfully");
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
