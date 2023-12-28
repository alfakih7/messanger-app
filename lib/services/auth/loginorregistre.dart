import 'package:flutter/material.dart';
import 'package:messanger/loginpage.dart';
import 'package:messanger/registrepage.dart';

class LoginOrRegistre extends StatefulWidget {
  const LoginOrRegistre({super.key});

  @override
  State<LoginOrRegistre> createState() => _LoginOrRegistreState();
}

class _LoginOrRegistreState extends State<LoginOrRegistre> {
  //initialy show the login screen
  bool showLoginPage = true;
  // toogle between login and registrepage
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegistrePage(onTap: togglePages);
    }
  }
}
