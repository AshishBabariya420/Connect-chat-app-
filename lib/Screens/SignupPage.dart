import 'package:connect/Helper/HelperFunctions.dart';
import 'package:connect/Services/AuthServices.dart';
import 'package:connect/Services/DatabaseServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DashPage.dart';

class SignupPage extends StatefulWidget {
  final Function toggleSignView;
  SignupPage({this.toggleSignView});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //Signup key
  GlobalKey<FormState> _signupKey = GlobalKey<FormState>();

  //*Backend firebase
  AuthServices _authServices = AuthServices();
  DatabaseServices _databaseServices = DatabaseServices();

  bool isLoading = false;

  //SignIN method
  signIn() async {
    //Validate the form, If validated set the loading to true
    if (_signupKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      //Method of the Sign In is called
      await _authServices
          .signUpWithEmailAndPassword(_email.text, _password.text)
          .then((result) {
        if (result != null) {
          //Mapping the userdata to a Map
          Map<String, String> userDataMap = {
            "userName": _userName.text,
            "fullName": _fullName.text,
            "userEmail": _email.text,
          };

          _databaseServices.addUserInformation(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreferences(true);
          HelperFunctions.saveUserNameSharedPreferences(_userName.text);
          HelperFunctions.saveUserEmailSharedPreferences(_email.text);

          Fluttertoast.showToast(
              msg: 'Succuessfully Created Account',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 18.0);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DashPage()));
        }
      }).catchError((e) => print("[SignIN Method]: $e"));
    }
  }

  //Variables
  bool _hidePassword = true;

  // fullname, username, email, password, confirm password
  //Text Editing controller
  TextEditingController _fullName = TextEditingController();
  TextEditingController _userName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  //Text Fields Validators
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
    } else if (value != _confirmPassword.text) {
      return 'Password and Confirm password do not match';
    } else {
      return null;
    }
  }

  String confirmPasswordValidator(String value) {
    if (value != _confirmPassword.text) {
      return 'Password and Confirm password do not match';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create Account"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/loginPage');
          },
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _signupKey,
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 15.0)),
                        //*Fullname
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            controller: _fullName,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black26,
                                ),
                                hintText: "Fullname",
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
                        //*Username
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            controller: _userName,
                            validator: (value) {
                              if (value.length < 4) {
                                return 'Username is too short';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black26,
                                ),
                                hintText: "Username",
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
                        //*EMAIL
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            controller: _email,
                            validator: emailValidator,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black26,
                                ),
                                hintText: "Email",
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
                        //*Password
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            controller: _password,
                            validator: passwordValidator,
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black26,
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
                        //*Confirm Password
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            controller: _confirmPassword,
                            validator: confirmPasswordValidator,
                            obscureText: _hidePassword,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black26,
                                ),
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  color: Colors.black26,
                                  onPressed: () {
                                    passwordPeak();
                                  },
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
                              //signIn
                              signIn();
                            },
                            elevation: 11,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                            child: Text("Sign up",
                                style: TextStyle(color: Colors.white70)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
