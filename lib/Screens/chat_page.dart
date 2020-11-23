import 'package:connect/Helper/Constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String userName;

  const ChatPage({Key key, @required this.chatRoomId, @required this.userName})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream chats;
  bool sendBy;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _messageController = TextEditingController();

  sendMessage() async {
    if (_messageController.text.length > 0) {
      Map<String, dynamic> chatMessagesData = {
        "sendBy": Constants.myName,
        "message": _messageController.text,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      //_databaseServices.addMessages(widget.chatRoomId, chatMessagesData);
      _firestore
          .collection("chatRoom")
          .doc(widget.chatRoomId)
          .collection("chats")
          .add(chatMessagesData);
      print("IDDDDR23232");
      setState(() {
        _messageController.clear();
      });
    }
  }

  chatMessages() {
    return StreamBuilder(
        stream: _firestore
            .collection("chatRoom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .orderBy("time")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return ListView.separated(
              physics: BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10.0,
                );
              },
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Message(
                  //isSendByMe: Constants.myName == snapshot.data.docs[index].data()["userName"],
                  isSendByMe: Constants.myName != widget.userName,
                  message: snapshot.data.docs[index].data()["message"],
                );
              },
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/chat_wallpaper.jpg"),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.userName),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            chatMessages(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  color: Colors.transparent,
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            
                            controller: _messageController,
                            //keyboardType: KeyboardT,
                            decoration: InputDecoration(
                                
                                hintText: "Type a message...",
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
                        margin: EdgeInsets.only(bottom: 10),
                        child: FloatingActionButton(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.send),
                            onPressed: () {
                              sendMessage();
                            }),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  const Message({Key key, @required this.message, @required this.isSendByMe})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment:
            isSendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isSendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: isSendByMe ? 30.0 : 20.0,
          ),
          //IMAGE OF THE USER <FUTURE SCOPE>
          if (!isSendByMe) ...[
            CircleAvatar(
              backgroundColor:
                  isSendByMe ? Colors.redAccent : Colors.lightBlueAccent,
              radius: 20.0,
            ),
            SizedBox(
              width: 5.0,
            )
          ],

          Container(
              padding: EdgeInsets.only(bottom: 5.0, right: 5.0),
              child: Column(
                crossAxisAlignment: isSendByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                      constraints: BoxConstraints(
                        minHeight: 40,
                        maxHeight: 250,
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                        minWidth: MediaQuery.of(context).size.width * 0.1,
                      ),
                      decoration: BoxDecoration(
                        color: isSendByMe ? Colors.red : Colors.white,
                        borderRadius: isSendByMe
                            ? BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              )
                            : BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, bottom: 5, right: 5),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: isSendByMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text(
                                  message,
                                  style: TextStyle(
                                    color: isSendByMe
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ]),
                      ))
                ],
              ))
        ]);
  }
}
