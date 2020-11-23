import 'package:connect/Services/AuthServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //TextForm field
  TextEditingController _email = TextEditingController();

  AuthServices _authServices = AuthServices();

  resetPassword()  {
    _authServices.resetPassword(_email.text).catchError((e) => print("[RESET METHOD]: $e"));
    Fluttertoast.showToast(
        msg: 'Email Sent',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0
        );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/loginPage');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 50.0)),
            Center(
              child: Text(
                "Please Enter the email address",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15.0, bottom: 15.0)),
            Card(
              margin: EdgeInsets.only(left: 30, right: 30, top: 20),
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
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
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(30.0),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                color: Colors.pink,
                onPressed: () {
                  resetPassword();
                },
                elevation: 11,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40.0))),
                child: Text("Reset Password",
                    style: TextStyle(color: Colors.white70)),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              //padding: EdgeInsets.only(top: 70.0),
              child: Text(
                "Reset Password Link will be emailed to you shortly!",
                style: TextStyle(fontSize: 16.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
