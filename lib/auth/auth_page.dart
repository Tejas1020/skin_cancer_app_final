import 'package:flutter/material.dart';
import 'package:skin_cancer_app_final/auth/log_in_page.dart';
import 'package:skin_cancer_app_final/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage(showRegisterPage: toggleScreens);
    } else {
      return SignUpPage(
        showLoginPage: toggleScreens,
      );
    }
  }
}
