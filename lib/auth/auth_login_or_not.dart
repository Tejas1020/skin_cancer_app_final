import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skin_cancer_app_final/Pages/homePage.dart';
import 'package:skin_cancer_app_final/auth/auth_page.dart';

class AuthLoginOrNot extends StatelessWidget {
  const AuthLoginOrNot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return NewHomePage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
