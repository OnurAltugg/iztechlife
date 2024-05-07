import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Password reset email sent successfully."),
            );
          },
      );
    }on FirebaseAuthException catch (e){
      showDialog(
          context: context,
          builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFB6ABAB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB6ABAB),
      ),
      body: Column(
        children: [
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
          const SizedBox(height: 150),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const Text(
                    "Enter your email and we will send you a password reset link.",
                    textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hint: "Enter Email",
                  label: "Email",
                  controller: _emailController,
                ),
              ],
            ),
          ),
          MaterialButton(
            onPressed: passwordReset,
            color: const Color(0xFFB71C1C),
            child: const Text("Reset password", style: TextStyle(color: Colors.white),),
          )
        ]
      )
    );
  }
}