import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class AuthScreen extends StatelessWidget {
  Future<void> signIn(BuildContext context) async {
    final user = await GoogleSignIn().signIn();
    final auth = await user!.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(cred);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Sign in with Google"),
          onPressed: () => signIn(context),
        ),
      ),
    );
  }
}