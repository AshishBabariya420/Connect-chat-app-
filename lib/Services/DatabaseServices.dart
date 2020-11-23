import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{

  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  //*Add the userdata to cloud firestore
  Future<void> addUserInformation(userData) async {
    _firebaseFirestore.collection("users").add(userData).catchError((e){
      print("[AddUserInfo] : $e");
    });
  }


  //*Fetch the user information from the firestore, where 
  getUserInformation(String email) async {
    return _firebaseFirestore
      .collection("users")
      .where("userEmail", isEqualTo: email)
      .get()
      .catchError((e){
        print("[getUserInfo] : $e");
      });
  }



  //*Using this, we can search for the users using the search option. 
  //*In firestore it searches the user collection where username is equal to the search field data
  searchByName(String searchField) async {
    return _firebaseFirestore
      .collection("users")
      .where("userName", isEqualTo: searchField)
      .get()
      .catchError((e){
        print("[SearchField] : $e");
      });
  }


  //* We are using this to add new chatRoom
  Future addChatRoom(chatRoom, chatRoomId) {
   return _firebaseFirestore
      .collection("chatRoom")
      .doc(chatRoomId)
      .set(chatRoom)
      .catchError((e){
        print("[AddChatRoom] : $e");
      });
  }


  //* Get the chatdata from the firestore, using the chatRoomId
  getChats(String chatRoomId) async {
    return _firebaseFirestore
      .collection("chatRoom")
      .doc(chatRoomId)
      .collection("chats")
      .get()
      .catchError((e){
        print("[GetChats] : $e");
      });
  }


  //* Add the chat messages to the firestore using ChatRoomId , and chatmessageData to add to the collection.
  Future addMessages(String chatRoomId, chatMessagesData) {
      _firebaseFirestore
      .doc(chatRoomId)
      .collection("chats")
      .add(chatMessagesData)
      .catchError((e){
        print("[Add Message]: $e");
      });
  }

  Future getUserChats(String itsMyName) async {
    return  _firebaseFirestore
      .collection("chatRoom")
      .where("users", arrayContains: itsMyName)
      .snapshots();
  }

}