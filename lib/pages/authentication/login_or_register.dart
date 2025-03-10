import 'package:flutter/material.dart';
import 'package:vending_machine_ordering_app/pages/authentication/login.dart';
import 'package:vending_machine_ordering_app/pages/authentication/signup.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially show login page
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return Login(
        onTap: togglePages,
      );
    } else {
      return Signup(
        onTap: togglePages,
      );
    }
  }
}
