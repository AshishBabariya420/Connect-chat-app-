import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/Helper/HelperFunctions.dart';
import 'package:connect/Screens/DashPage.dart';
import 'package:connect/Services/AuthServices.dart';
import 'package:connect/Services/DatabaseServices.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function toggleSignView;
  LoginPage({this.toggleSignView});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //login key
  GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  //Variables
  bool _hidePassword = true;
  bool isLoading = false;

  AuthServices _authServices = AuthServices();
  DatabaseServices _databaseServices = DatabaseServices();

  //Connect the backend Firebase
  logIn() async {
    if (_loginKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await _authServices
          .signInWithEmailAndPassword(_emailAddress.text, _password.text)
          .then((result) async {
        if (result != null) {
          
          QuerySnapshot userInfoSnapshot =
              await _databaseServices.getUserInformation(_emailAddress.text);
          HelperFunctions.saveUserLoggedInSharedPreferences(true);
          HelperFunctions.saveUserNameSharedPreferences(
            userInfoSnapshot.docs[0].data()["userName"]);
          HelperFunctions.saveUserEmailSharedPreferences(
              userInfoSnapshot.docs[0].data()["userEmail"]);

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashPage()));

        } else {
          setState(() {
            isLoading = false;
            
          });
        }
      }).catchError((e) => print("[LOGIN METHOD] : $e"));
    }
  }

  //Text Input field initisalized
  TextEditingController _emailAddress = TextEditingController();
  TextEditingController _password = TextEditingController();

  //Validation for the textform fields
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String passwordValidator(String value) {
    if (value.length < 6) {
      return 'Password is too short';
    } else {
      return null;
    }
  }

  //Password Peek function
  passwordPeak() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Login Page"),
        ),
        body:  isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) 
        :
        SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/connect_logo_text.png"),
                  ),
                ),
              ),
              Form(
                key: _loginKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextFormField(
                        controller: _emailAddress,
                        validator: emailValidator,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black26,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.black26),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0)),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      elevation: 11,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextFormField(
                        controller: _password,
                        validator: passwordValidator,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black26,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: Colors.black26,
                              onPressed: () {
                                passwordPeak();
                              },
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: Colors.black26,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0)),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 16.0)),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.0),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        color: Colors.pink,
                        onPressed: () {
                          logIn();
                        },
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: Text("Login",
                            style: TextStyle(color: Colors.white70)),
                      ),
                    ),
                    Container(
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/forgotPassword');
                          },
                          child: Text(
                            "Forgot Password? Click here",
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 40.0),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/signupPage');
                          },
                          child: Text(
                            "New User! Create Account",
                            style: TextStyle(
                              color: Colors.pink,
                              fontSize: 18.0,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ))

      );
  }
}
