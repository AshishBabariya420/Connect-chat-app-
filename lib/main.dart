import 'package:connect/Helper/HelperFunctions.dart';
import 'package:connect/Screens/DashPage.dart';
import 'package:connect/Screens/ForgotPassword.dart';
import 'package:connect/Screens/HomePage.dart';
import 'package:connect/Screens/LoginPage.dart';
import 'package:connect/Screens/SignupPage.dart';
import 'package:connect/Screens/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/Chat.dart';
//import 'Screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreferences().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect Chat app',
      debugShowCheckedModeBanner: false,
      home: userIsLoggedIn != null
          ? userIsLoggedIn ? DashPage() : LoginPage()
          : Container(
              child: LoginPage(),
            ),
     // home: ChatPage(),
      theme: ThemeData(
        fontFamily: "ProductSans",
      ),
      routes: <String, WidgetBuilder>{
        '/loginPage': (BuildContext context) => LoginPage(),
        '/signupPage': (BuildContext context) => SignupPage(),
        '/forgotPassword': (BuildContext context) => ForgotPassword(),
        '/dashPage': (BuildContext context) => DashPage(),
      },
    );
  }
}
