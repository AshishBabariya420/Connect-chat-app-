import 'package:connect/Screens/LoginPage.dart';
import 'package:connect/Screens/SignupPage.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showSignIn = true;

  void toggleSignView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn == true) {
      return SignupPage(toggleSignView: toggleSignView,);
    } else {
      return LoginPage(toggleSignView: toggleSignView);
    }
  }
}
