import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> signupUser({
  required String fullName,
  required String email,
  required String password,
  required String phoneNumber,
}) async {
  try {

    final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCred.user!.uid;


    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.now(),
    });

    print('User successfully created and stored in Firestore.');
  } catch (e) {
    print('Error during signup: $e');
  }
}
