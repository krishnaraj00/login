import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatelessWidget {
   ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title:  Text("Forgot Password")),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(children: [
           Text("Enter your registered email to reset your password"),
          TextField(controller: emailController, decoration:  InputDecoration(labelText: "Email")),
           SizedBox(height: 10),
          ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      content: Text("Reset link sent to your email.")));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              },
              child:  Text("Reset Password")),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text("Back to Login"))
        ]),
      ),
    );
  }
}
