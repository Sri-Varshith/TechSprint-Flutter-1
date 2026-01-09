import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindIt AI',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          // While Firebase checks auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // User is logged in
          if (snapshot.hasData) {
            return HomeScreen();
          }

          // User is NOT logged in
          return AuthScreen();
        },
      ),
    );
  }
}