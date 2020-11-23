import 'package:shared_preferences/shared_preferences.dart';


class HelperFunctions{
  
  //*Shared Preferences key
  static String sharedPreferenceUserLoggedInKey = "ISUSERLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //*Saving Data to the shared preferences

  static Future<bool> saveUserLoggedInSharedPreferences(bool isUserLoggedIn) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return await preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  //!CHange to bool if fucked
  static Future saveUserNameSharedPreferences(String userName) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future saveUserEmailSharedPreferences(String userEmail) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  //*Getting the data from the Shared preferences

  static Future getUserLoggedInSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return  preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future getUserNameSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return  preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future getUserEmailSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return  preferences.getString(sharedPreferenceUserEmailKey);
  }
}