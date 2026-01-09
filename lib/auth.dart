import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  String error = "";

  // ---------------- EMAIL AUTH ----------------
  Future<void> submitEmail() async {
    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      }
      setState(() => error = "");
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  // ---------------- GOOGLE AUTH ----------------
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final cred = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(cred);
      setState(() => error = "");
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FindIt AI Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            SizedBox(height: 15),

            ElevatedButton(
              onPressed: submitEmail,
              child: Text(isLogin ? "Login" : "Register"),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(isLogin
                  ? "Create new account"
                  : "Already have account? Login"),
            ),

            Divider(),

            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text("Sign in with Google"),
              onPressed: signInWithGoogle,
            ),

            if (error.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(error, style: TextStyle(color: Colors.red)),
              )
          ],
        ),
      ),
    );
  }
}