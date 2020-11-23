import 'package:connect/Models/CurrentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{

  final FirebaseAuth _auth = FirebaseAuth.instance;


  //MODEL to store the UID of the currentUser
  CurrentUser _userFromFirebaseUser(User user) {
    return user != null ? CurrentUser(uid: user.uid) : null;
  }


  //Login User using email address and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("[SignIn] : $e");
      return null;
    }
  }


  //Register new user using email address and password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("[SignUp]: $e");
    }
  }

  //Forgot password, Reset password email address
  Future resetPassword(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }

  //LogOUT
  Future signOut() async {
    return _auth.signOut();
  }

}