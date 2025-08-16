import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/Firebase/sign.dart';


import 'forgetpass.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // used for updates like user input,error message
  final emailController =
      TextEditingController(); // used for get user input like store
  final passwordController = TextEditingController();

  Future<void> loginUser() async {
    // used to handle the entry login proces
    try {
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        //Gets the Firebase Authentication instance and
        // Calls the Firebase method to log in using email and password // await for Tells Dart to wait for Firebase to respond
        email: emailController.text.trim(), // to get email enterd by user
        password: passwordController.text.trim(),
      );

      final doc =
          await FirebaseFirestore
              .instance // This gets the instance of your Firestore database
              .collection(
                'users',
              ) // "users" collection inside your Firestore database.
              .doc(userCred.user!.uid)
              .get(); // This line is used to fetch the logged-in user's data from Firestore.

      if (doc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        showError('User data not found');
      }
    } catch (e) {
      showError("Entered details are incorrect");
    }
  }

  void showError(String msg) {
    // Shows an AlertDialog popup with the error message
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Error"),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue, // button background color
                  foregroundColor: Colors.white,
                ),
                onPressed: loginUser,
                child: Text("Login"),
              ),
              TextButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
                    ),
                child: Text("Forgot Password?"),
              ),
              TextButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupPage()),
                    ),
                child: Text("Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
