import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nutz_app/home_screen/view/home_screen.dart';
import 'package:nutz_app/login_screen/view/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
