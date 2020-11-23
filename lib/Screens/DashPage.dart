import 'package:connect/Helper/Constant.dart';
import 'package:connect/Helper/HelperFunctions.dart';
import 'package:connect/Screens/LoginPage.dart';
import 'package:connect/Services/AuthServices.dart';
import 'package:connect/Services/DatabaseServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_page.dart';

class DashPage extends StatefulWidget {
  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  AuthServices _authServices = AuthServices();
  DatabaseServices _databaseServices = DatabaseServices();

  QuerySnapshot searchResults;
  QuerySnapshot allUserList;

  TextEditingController _username = TextEditingController();

  bool isLoading = false;
  bool haveSearched = false;

  String chatRoomId;

  @override
  void initState() {
    HelperFunctions.getUserNameSharedPreferences().then((value) {
      Constants.myName = value;
    });
    getAllUserList();
    super.initState();
  }

  getAllUserList() {
    return FirebaseFirestore.instance.collection("users").get().then((value) {
      allUserList = value;
    });
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 2).codeUnitAt(0) > b.substring(0, 2).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  sendMessages(String userName) {
    List<String> users = [Constants.myName, userName];

    chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {"users": users, "chatRoomId": chatRoomId};

    _databaseServices.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ChatPage(chatRoomId: chatRoomId, userName: userName)));
  }

  searchByUsername() async {
    if (_username.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await _databaseServices.searchByName(_username.text).then((snapshot) {
        searchResults = snapshot;
        setState(() {
          isLoading = false;
          haveSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.docs.length,
            itemBuilder: (context, index) {
              return userTile(
                context,
                searchResults.docs[index].data()["userName"],
                searchResults.docs[index].data()["userEmail"],
              );
            },
          )
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return allUser(
                        context,
                        snapshot.data.docs[index].data()["userName"],
                        snapshot.data.docs[index].data()["userEmail"]);
                  },
                );
              }
            },
          );
  }

  Widget userTile(BuildContext context, String userName, String userEmail) {
    return ListTile(
      onTap: () {
        sendMessages(userName);
      },
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(userName[0].toUpperCase()),
      ),
      title: Text(userName),
      subtitle: Text(userEmail),
    );
  }

  Widget allUser(BuildContext context, String userName, String userEmail) {
    return ListTile(
      onTap: () {
        sendMessages(userName);
      },
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
        child: Text(userName[0].toUpperCase()),
      ),
      title: Text(userName,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
      subtitle: Text(userEmail),
    );
  }

  //SIGN OUT METHOD
  signOut() {
    _authServices.signOut().catchError((e) => print("[SignOut Method]: $e"));
    HelperFunctions.saveUserLoggedInSharedPreferences(false);
    Fluttertoast.showToast(
        msg: 'Sign Out Successful',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 18.0);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Connect Chat", style: TextStyle(color: Colors.blueAccent)),
        leading: IconButton(
          icon: Icon(
            Icons.person,
            color: Colors.blueAccent,
          ),
          onPressed: null,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              signOut();
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 0),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            controller: _username,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black26,
                                ),
                                hintText: "Search by Username",
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
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 19.0, 20.0, 0.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            searchByUsername();
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                  ),
                  userList(),
                ],
              ),
            ),
    );
  }
}
