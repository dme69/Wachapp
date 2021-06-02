import 'package:flutter/material.dart';
import 'package:wachapp/ConversationScreen.dart';
import 'package:wachapp/HelperFunctions.dart';
import 'package:wachapp/registerPage.dart';
import 'package:wachapp/services/auth.dart';
import 'package:wachapp/services/database.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat> {

  Stream chatRooms;

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  static String myName = "";

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  /*@override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }*/

  getUserInfogetChats() async {
    myName = await HelperFunctions.getUserNameSharedPreference();
    Database().getUserChats(myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wachapp'),
      actions: [
          GestureDetector(
            onTap: () {
              Auth().cerrarSesion();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => RegisterPage(null)));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(Icons.message),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple[200],
      )
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(
            chatRoomId: chatRoomId,
          )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Color(0xff007EF4),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}