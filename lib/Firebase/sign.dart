import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>(); // It allows you to validate all the fields inside a <Form> widget at once.

  Future<void> signupUser() async { //used to create a new user account in Firebase Authentication using email and password.
    if (formKey.currentState!.validate()) { //Checks if all form fields are valid
      try {
        final userCred = await FirebaseAuth.instance // userCred.user!.uid is the unique ID Firebase assigns to the new user.
            .createUserWithEmailAndPassword( // Calls Firebase Authentication API to create the user with email and password.
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        await FirebaseFirestore.instance  // access// used to newly registered user's profile data
            .collection('users')// collection named as users
            .doc(userCred.user!.uid)
            .set({ // saved the data
              'fullName': fullNameController.text.trim(),
              'phone': phoneController.text.trim(),
              'email': emailController.text.trim(),
          // Saves the user’s full name, phone number, and email in the Firestore database
            });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Signup successful!")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text("Signup")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form( //Group multiple input fields,Validate user input
        key: formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Enter full name" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        !value!.contains('@') ? "Enter valid email" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value!.length != 10 ? "Phone must be 10 digits" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator:
                    (value) =>
                        value!.length < 6 ? "Minimum 6 characters" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator:
                    (value) =>
                        value != passwordController.text
                            ? "Passwords don't match"
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: signupUser,
                child: Text("Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
