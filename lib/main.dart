import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppRoot());
}

class AppRoot extends StatefulWidget {
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool dark = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => dark = prefs.getBool("dark") ?? false);
  }

  Future toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dark = !dark;
      prefs.setBool("dark", dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snap) {
          if (!snap.hasData) return AuthScreen();
          return HomeScreen(onTheme: toggleTheme);
        },
      ),
    );
  }
}