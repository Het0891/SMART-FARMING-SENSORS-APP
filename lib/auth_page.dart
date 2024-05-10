import 'package:app_dev/Pages/homepage.dart';
import 'package:app_dev/Pages/login_or_registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Homepage();
          }
          else {
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
